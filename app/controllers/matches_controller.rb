class MatchesController < ApplicationController
  # Verwalten des gesamten Match-Lebenszyklus: Übersicht, Erstellung, Spielablauf und Status.
  before_action :set_match, only: %i[show play status forfeit]
  before_action :set_participation, only: %i[play forfeit]
  before_action :ensure_participation_owner!, only: %i[play forfeit]
  before_action :ensure_match_participation!, only: %i[status]

  def index
    # Zeigt dem eingeloggten Account alle eigenen Matches in umgekehrter Reihenfolge.
    @pagy, @participations = pagy(
      current_user.match_participations.includes(match: :category).order(created_at: :desc)
    )
  end

  def new
    # Formular für ein neues Match vorbereiten (Default: Solo, 10 Fragen).
    @categories = Category.order(:name)
    @match = Match.new(question_count: 10, time_per_question: 30, mode: "solo")
  end

  def create
    # Aus Formular kommend: Ohne Kategorie dürfen wir nicht fortfahren.
    if match_params[:category_id].blank?
      @categories = Category.order(:name)
      @match = Match.new(match_params)
      @match.errors.add(:category, "muss ausgewählt werden")
      render :new, status: 422 and return
    end

    # Übergibt an den MatchBuilder, der Fragen zuteilt und Teilnahme erzeugt.
    category = Category.find(match_params[:category_id])
    builder = QuizEngine::MatchBuilder.new(
      user: current_user,
      category: category,
      mode: match_params[:mode],
      question_count: match_params[:question_count],
      time_per_question: match_params[:time_per_question]
    )

    @match = builder.call

    # Leitende Person direkt auf die Spieloberfläche schicken.
    notice = if @match.solo?
               "Viel Erfolg!"
             else
               "Quiz erstellt. Teile den Code #{@match.share_code} mit anderen Spielern."
             end
    redirect_to play_match_path(@match), notice: notice
  rescue ActiveRecord::RecordInvalid => e
    # Fehler aus dem Builder (z.B. zu wenige Fragen) wieder im Formular anzeigen.
    @categories = Category.order(:name)
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    @match = Match.new(match_params)
    render :new, status: 422
  end

  def show
    # Match-Ergebnis/Leaderboard inklusive eigener Teilnahme anzeigen.
    @leaderboard = @match.leaderboard.includes(:user)
    @participation = current_user.match_participations.find_by(match: @match)
    @finished_participations = @match.match_participations.where(status: %w[completed forfeited]).count
    @total_participations = @match.match_participations.count
    @winner = @match.completed? ? @leaderboard.first : nil
  end

  def play
    # Spieloberfläche. Bereits erledigte Matches senden wir zurück zur Auswertung.
    if @participation.finished?
      redirect_to match_path(@match), notice: "Dieses Quiz hast du bereits abgeschlossen." and return
    end

    # Erstes Betreten setzt das Match auf „active“.
    @match.update!(state: "active", started_at: Time.current) if @match.open?

    # Nächste offene Frage bestimmen – falls keine mehr da ist, Abschluss.
    match_question = next_question
    if match_question.blank?
      finalize_participation!(@participation)
      redirect_to match_path(@match), notice: "Gut gemacht!" and return
    end

    # Speichert Startzeit der Frage (für die Zeitmessung).
    @participation.start_question!(match_question)

    # Prüft Timeout, trägt sonst Fehlversuch ein.
    elapsed_seconds = @participation.current_question_elapsed_seconds
    if elapsed_seconds >= @match.time_per_question
      handle_time_expired(match_question)
      redirect_to play_match_path(@match), alert: "Zeit abgelaufen! Die Frage wurde als falsch gewertet." and return
    end

    # Daten für das View vorbereiten (aktueller Stand, Restzeit etc.).
    @match_question = match_question
    @current_question = match_question.question
    @positions_answered = @participation.question_attempts.count
    @time_remaining_seconds = [ @match.time_per_question - elapsed_seconds, 0 ].max
    started_at = @participation.current_question_started_at || Time.current
    @question_deadline_epoch_ms = ((started_at + @match.time_per_question.seconds).to_f * 1000).to_i
    @server_time_epoch_ms = (Time.current.to_f * 1000).to_i
  end

  def join
    # Teilnahme über Match-Code (z.B. bei Gruppenquiz) ermöglichen.
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
    # JSON-Endpunkt für Live-Status (z.B. Victory-Screen, Polling).
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
    # Manuelles Abbrechen durch Teilnehmende.
    if @participation.finished?
      redirect_to match_path(@match), alert: "Dieses Match ist bereits abgeschlossen." and return
    end

    @participation.forfeit!
    mark_match_completed_if_ready!(@match)

    redirect_to matches_path, notice: "Match wurde abgebrochen."
  end

  private

  def set_match
    # Lädt das Match anhand der URL-ID.
    @match = Match.find(params[:id])
  end

  def set_participation
    # Holt oder erstellt eine Teilnahme für die aktuelle Person.
    @participation = @match.match_participations.find_or_create_by!(user: current_user) do |record|
      record.status = "playing"
    end
  end

  def ensure_participation_owner!
    # Nur Match-Beteiligte dürfen spielen/abbrechen.
    return if @participation.user_id == current_user.id

    redirect_to matches_path, alert: "Kein Zugriff auf dieses Match." and return
  end

  def ensure_match_participation!
    # Zugriffsschutz für den Status-Endpunkt.
    return if @match.match_participations.exists?(user: current_user)

    head :forbidden
  end

  def next_question
    # Nächste offene MatchQuestion (oder nil) – gecachet bis zur nächsten Antwort.
    @next_question ||= begin
      answered_ids = @participation.question_attempts.select(:match_question_id)
      @match.match_questions.where.not(id: answered_ids).order(:position).first
    end
  end

  def finalize_participation!(participation)
    # Abschluss-Workflow: Teilnahme beenden, Punkte vergeben, Achievements prüfen.
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
    # Timeout-Logik: Falscher Versuch, danach ggf. Matchabschluss.
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
    # Whitelist für Match-Formularwerte.
    params.require(:match).permit(:category_id, :mode, :question_count, :time_per_question)
  end

  def mark_match_completed_if_ready!(match)
    # Wenn alle Teilnahmen abgeschlossen sind, gilt das Match als beendet.
    if match.match_participations.where.not(status: %w[completed forfeited]).none?
      match.update!(state: "completed", completed_at: Time.current)
    end
  end
end
