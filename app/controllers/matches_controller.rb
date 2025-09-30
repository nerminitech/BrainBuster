class MatchesController < ApplicationController
  before_action :set_match, only: %i[show play]
  before_action :set_participation, only: %i[play]
  before_action :ensure_participation_owner!, only: %i[play]

  def index
    @open_matches = Match.publicly_visible.includes(:category, :creator).order(created_at: :desc)
    @participations = current_user.match_participations.includes(match: :category).order(created_at: :desc)
  end

  def new
    @categories = Category.order(:name)
    @match = Match.new(question_count: 10, time_per_question: 30, mode: "solo")
  end

  def create
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
    render :new, status: :unprocessable_entity
  end

  def show
    @leaderboard = @match.leaderboard.includes(:user)
    @participation = current_user.match_participations.find_by(match: @match)
  end

  def play
    if @participation.completed?
      redirect_to match_path(@match), notice: "Dieses Quiz hast du bereits abgeschlossen." and return
    end

    if @match.open?
      @match.update!(state: "active", started_at: Time.current)
    end

    if next_question.blank?
      finalize_participation!(@participation)
      redirect_to match_path(@match), notice: "Gut gemacht!" and return
    end

    @current_question = next_question.question
    @match_question = next_question
    @positions_answered = @participation.question_attempts.count
  end

  def join
    match = Match.find_by!(share_code: params[:share_code].to_s.upcase)
    participation = match.match_participations.find_or_create_by!(user: current_user) do |record|
      record.status = match.solo? ? "playing" : "pending"
    end

    if participation.completed?
      redirect_to match_path(match), alert: "Du hast dieses Quiz bereits abgeschlossen." and return
    end

    match.update!(state: "active", started_at: Time.current) if match.open?
    participation.update!(status: "playing") unless participation.playing?

    redirect_to play_match_path(match), notice: "Viel Erfolg!"
  rescue ActiveRecord::RecordNotFound
    redirect_to matches_path, alert: "Kein Match mit diesem Code gefunden."
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def set_participation
    @participation = @match.match_participations.find_or_create_by!(user: current_user) do |record|
      record.status = "playing"
    end
  end

  def ensure_participation_owner!
    return if @participation.user_id == current_user.id

    redirect_to matches_path, alert: "Kein Zugriff auf dieses Match." and return
  end

  def next_question
    @next_question ||= begin
      answered_ids = @participation.question_attempts.select(:match_question_id)
      @match.match_questions.where.not(id: answered_ids).order(:position).first
    end
  end

  def finalize_participation!(participation)
    participation.finish!
    current_user.add_points!(participation.score)
    QuizEngine::AchievementAwarder.call(participation)

    if participation.match.match_participations.where.not(status: "completed").none?
      participation.match.update!(state: "completed", completed_at: Time.current)
    end
  end

  def match_params
    params.require(:match).permit(:category_id, :mode, :question_count, :time_per_question)
  end
end
