class MatchParticipation < ApplicationRecord
  STATUSES = %w[pending playing completed forfeited].freeze

  belongs_to :match
  belongs_to :user
  has_many :question_attempts, dependent: :destroy
  belongs_to :current_match_question, class_name: "MatchQuestion", optional: true

  validates :status, inclusion: { in: STATUSES }

  scope :completed, -> { where(status: "completed") }

  def completed?
    status == "completed"
  end

  def playing?
    status == "playing"
  end

  def finished?
    completed? || status == "forfeited"
  end

  def current_streak
    streak = 0
    question_attempts.order(created_at: :desc).each do |attempt|
      break unless attempt.correct?

      streak += 1
    end
    streak
  end

  def start_question!(match_question)
    return if current_match_question_id == match_question.id && current_question_started_at.present?

    update!(current_match_question: match_question, current_question_started_at: Time.current)
  end

  def current_question_elapsed_seconds
    return 0 unless current_question_started_at

    (Time.current - current_question_started_at).to_i
  end

  def clear_current_question!
    update_columns(current_match_question_id: nil, current_question_started_at: nil)
  end

  def register_attempt!(match_question:, answer_option:, correct:, response_time_ms:, points_awarded:)
    question_attempts.create!(
      match_question: match_question,
      answer_option: answer_option,
      correct: correct,
      response_time_ms: response_time_ms,
      awarded_points: points_awarded
    )

    update_statistics!(correct:, points_awarded:, response_time_ms:)
    clear_current_question!
  end

  def update_statistics!(correct:, points_awarded:, response_time_ms:)
    self.score += points_awarded
    if correct
      self.correct_count += 1
      self.best_streak += 1
    else
      self.incorrect_count += 1
      self.best_streak = 0
    end

    total_answers = correct_count + incorrect_count
    self.average_response_ms =
      if total_answers.positive?
        ((average_response_ms * (total_answers - 1)) + response_time_ms) / total_answers
      else
        response_time_ms
      end
    save!
  end

  def finish!
    clear_current_question!
    update!(status: "completed", completed_at: Time.current)
  end

  def forfeit!
    clear_current_question!
    update!(status: "forfeited", completed_at: Time.current)
  end
end
