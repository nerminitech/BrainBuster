module Matches
  class AttemptsController < ApplicationController
    before_action :set_match
    before_action :set_participation

    def create
      match_question = @match.match_questions.find(params[:match_question_id])
      ensure_attempt_not_recorded!(match_question)

      answer_option = match_question.question.answer_options.find(params[:answer_option_id])
      correct = answer_option.correct?
      response_time_ms = calculate_response_time
      current_streak = correct ? @participation.current_streak : 0
      scoring = QuizEngine::Scoring.call(
        question: match_question.question,
        response_time_ms: response_time_ms,
        correct: correct,
        current_streak: current_streak
      )

      @participation.register_attempt!(
        match_question: match_question,
        answer_option: answer_option,
        correct: correct,
        response_time_ms: response_time_ms,
        points_awarded: scoring.total_points
      )

      message = correct ? "Richtig! +#{scoring.total_points} Punkte" : "Leider falsch."
      redirect_to play_match_path(@match), notice: message
    rescue ActiveRecord::RecordInvalid => e
      redirect_to play_match_path(@match), alert: e.record.errors.full_messages.to_sentence
    end

    private

    def set_match
      @match = Match.find(params[:match_id])
    end

    def set_participation
      @participation = @match.match_participations.find_by!(user: current_user)
    end

    def calculate_response_time
      started_at = params[:started_at].presence
      return 0 unless started_at

      start_time = Time.zone.at(started_at.to_f)
      ((Time.current - start_time) * 1000).to_i.clamp(0, 120_000)
    end

    def ensure_attempt_not_recorded!(match_question)
      existing = @participation.question_attempts.find_by(match_question: match_question)
      return unless existing

      existing.errors.add(:base, "Diese Frage wurde bereits beantwortet.")
      raise ActiveRecord::RecordInvalid.new(existing)
    end
  end
end
