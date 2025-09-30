module Matches
  class AttemptsController < ApplicationController
    before_action :set_match
    before_action :set_participation

    def create
      match_question = @match.match_questions.find(params[:match_question_id])
      ensure_attempt_not_recorded!(match_question)

      unless @participation.current_match_question_id == match_question.id
        redirect_to play_match_path(@match), alert: "Diese Frage ist nicht mehr aktiv." and return
      end

      answer_option = if params[:answer_option_id].present?
                        match_question.question.answer_options.find(params[:answer_option_id])
                      else
                        nil
                      end

      response_time_ms = calculate_response_time
      time_limit_ms = @match.time_per_question * 1000
      timed_out = response_time_ms >= time_limit_ms

      answer_is_correct = !!answer_option&.correct?
      correct = answer_is_correct && !timed_out
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

      if timed_out
        redirect_to play_match_path(@match), alert: "Zeit abgelaufen! Die Frage wurde als falsch gewertet." and return
      end

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
      started_at = @participation.current_question_started_at
      return @match.time_per_question * 1000 unless started_at

      ((Time.current - started_at) * 1000).to_i.clamp(0, 300_000)
    end

    def ensure_attempt_not_recorded!(match_question)
      existing = @participation.question_attempts.find_by(match_question: match_question)
      return unless existing

      existing.errors.add(:base, "Diese Frage wurde bereits beantwortet.")
      raise ActiveRecord::RecordInvalid.new(existing)
    end
  end
end
