class MatchesController < ApplicationController
  # Dieser Controller kuemmert sich um die komplette Match-Erfahrung: vom Anzeigen,
  # Erstellen und Betreten bis hin zum eigentlichen Spielen eines Quiz.
  before_action :set_match, only: %i[show play status forfeit]
  before_action :set_participation, only: %i[play forfeit]
  before_action :ensure_participation_owner!, only: %i[play forfeit]
  before_action :ensure_match_participation!, only: %i[status]

  def index
    # Holt alle Match-Teilnahmen der angemeldeten Person und paginiert sie.
    @pagy, @participations = pagy(
      current_user.match_participations.includes(match: :category).order(created_at: :desc)
    )
  end

  def new
    # Baut ein leeres Match-Objekt mit sinnvollen Voreinstellungen.
    @categories = Category.order(:name)
    @match = Match.new(question_count: 10, time_per_question: 30, mode: "solo")
  end

  def create
    # Sicherheitsnetz: Ohne Kategorie darf kein Match erzeugt werden.
    if match_params[:category_id].blank?
      @categories = Category.order(:name)
      @match = Match.new(match_params)
      @match.errors.add(:category, "muss ausgewählt werden")
      render :new, status: 422 and return
    end

    # Laesst den spezialisierten Builder ein Match inklusive Fragen zusammenstellen.
    category = Category.find(match_params[:category_id])
    builder = QuizEngine::MatchBuilder.new(
      user: current_user,
      category: category,
      mode: match_params[:mode],
      question_count: match_params[:question_count],
      time_per_question: match_params[:time_per_question]
    )

    @match = builder.call

    notice = @match.solo? ? "Viel Erfolg!" : "Quiz erstellt. Teile den Code #{@match.share_code} mit anderen Spielern."
    redirect_to play_match_path(@match), notice: notice
  rescue ActiveRecord::RecordInvalid => e
    @categories = Category.order(:name)
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    @match = Match.new(match_params)
    render :new, status: 422
  end

  def show
    # Zeigt das Leaderboard und ob der aktuelle Nutzende schon mitgespielt hat.
    @leaderboard = @match.leaderboard.includes(:user)
    @participation = current_user.match_participations.find_by(match: @match)
    # Zaehlt fertige Spieler und merkt sich den Sieger fuer den Victory-Screen.
    @finished_participations = @match.match_participations.where(status: %w[completed forfeited]).count
    @total_participations = @match.match_participations.count
    @winner = @match.completed? ? @leaderboard.first : nil
  end

  def play
    # Beendet sofort, wenn das Match bereits abgeschlossen oder abgebrochen ist.
    if @participation.finished?
      redirect_to match_path(@match), notice: "Dieses Quiz hast du bereits abgeschlossen." and return
    end

    # Markiert das Match als gestartet, sobald die erste Person spielt.
    @match.update!(state: "active", started_at: Time.current) if @match.open?

    # Holt die naechste noch unbeantwortete Frage.
    match_question = next_question
    if match_question.blank?
      # Es gibt keine Frage mehr -> Match abschliessen.
      finalize_participation!(@participation)
      redirect_to match_path(@match), notice: "Gut gemacht!" and return
    end

    # Speichert, welche Frage gerade bearbeitet wird.
    @participation.start_question!(match_question)

    # Prueft, ob die Zeit schon abgelaufen ist.
    elapsed_seconds = @participation.current_question_elapsed_seconds
    if elapsed_seconds >= @match.time_per_question
      handle_time_expired(match_question)
      redirect_to play_match_path(@match), alert: "Zeit abgelaufen! Die Frage wurde als falsch gewertet." and return
    end

    # Bereitet alle Werte fuer die Ansicht auf.
    @match_question = match_question
    @current_question = match_question.question
    @positions_answered = @participation.question_attempts.count
    @time_remaining_seconds = [ @match.time_per_question - elapsed_seconds, 0 ].max
    started_at = @participation.current_question_started_at || Time.current
    @question_deadline_epoch_ms = ((started_at + @match.time_per_question.seconds).to_f * 1000).to_i
    @server_time_epoch_ms = (Time.current.to_f * 1000).to_i
  end

  def join
    # Ermoeglicht Mitspielen via geteilter Code-Eingabe.
    match = Match.find_by!(share_code: params[:share_code].to_s.upcase)
    participation = match.match_participations.find_or_create_by!(user: current_user) do |record|
      record.status = match.solo? ? "playing" : "pending"
    end

    if participation.finished?
      redirect_to match_path(match), alert: "Du hast dieses Quiz bereits abgeschlossen." and return
    end

    match.update!(state: "active", started_at: Time.current) if match.open?
    participation.update!(status: "playing") unless participation.playing?

    redirect_to play_match_path(match), notice: "Viel Erfolg!"
  rescue ActiveRecord::RecordNotFound
    redirect_to matches_path, alert: "Kein Match mit diesem Code gefunden."
  end

  def status
    winner_participation = @match.leaderboard.first
    render json: {
      state: @match.state,
      completed: @match.completed?,
      finished_participations: @match.match_participations.where(status: %w[completed forfeited]).count,
      total_participations: @match.match_participations.count,
      winner_id: winner_participation&.user_id,
      winner_name: winner_participation&.user&.display_name,
      winner_score: winner_participation&.score
    }
  end

  def forfeit
    if @participation.finished?
      redirect_to match_path(@match), alert: "Dieses Match ist bereits abgeschlossen." and return
    end

    @participation.forfeit!
    mark_match_completed_if_ready!(@match)

    redirect_to matches_path, notice: "Match wurde abgebrochen."
  end

  private

  def set_match
    # Sucht das Match ueber die URL-Id heraus.
    @match = Match.find(params[:id])
  end

  def set_participation
    # Stellt sicher, dass die aktuelle Person eine Teilnahme zum Match hat.
    @participation = @match.match_participations.find_or_create_by!(user: current_user) do |record|
      record.status = "playing"
    end
  end

  def ensure_participation_owner!
    # Verhindert, dass jemand anderes fremde Matches spielt.
    return if @participation.user_id == current_user.id

    redirect_to matches_path, alert: "Kein Zugriff auf dieses Match." and return
  end

  def ensure_match_participation!
    # Nur wer am Match teilnimmt, darf den Live-Status abrufen.
    return if @match.match_participations.exists?(user: current_user)

    head :forbidden
  end

  def next_question
    # Merkt sich die naechste unbeantwortete Frage und fragt sie nur einmal ab.
    @next_question ||= begin
      answered_ids = @participation.question_attempts.select(:match_question_id)
      @match.match_questions.where.not(id: answered_ids).order(:position).first
    end
  end

  def finalize_participation!(participation)
    # Markiert das Match als geschafft, verteilt Punkte und prueft auf Achievements.
    participation.finish!
    current_user.add_points!(participation.score)
    newly_awarded = QuizEngine::AchievementAwarder.call(participation)
    if newly_awarded.present?
      flash[:achievement] = newly_awarded.map do |achievement|
        {
          code: achievement.code,
          name: achievement.name,
          description: achievement.description,
          points: achievement.points_bonus
        }
      end
    end

    mark_match_completed_if_ready!(participation.match)
  end

  def handle_time_expired(match_question)
    # Falls noch kein Versuch existiert, wird ein falscher Versuch eingetragen.
    return if @participation.question_attempts.exists?(match_question: match_question)

    @participation.register_attempt!(
      match_question: match_question,
      answer_option: nil,
      correct: false,
      response_time_ms: @match.time_per_question * 1_000,
      points_awarded: 0
    )

    @next_question = nil
    if next_question.blank?
      finalize_participation!(@participation)
    end
  end

  def match_params
    # Definiert klar, welche Felder aus dem Formular uebernommen werden.
    params.require(:match).permit(:category_id, :mode, :question_count, :time_per_question)
  end

  def mark_match_completed_if_ready!(match)
    if match.match_participations.where.not(status: %w[completed forfeited]).none?
      match.update!(state: "completed", completed_at: Time.current)
    end
  end
end
