class MatchParticipation < ApplicationRecord
  STATUSES = %w[pending playing completed forfeited].freeze

  belongs_to :match
  belongs_to :user
  has_many :question_attempts, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }

  scope :completed, -> { where(status: "completed") }

  def completed?
    status == "completed"
  end

  def playing?
    status == "playing"
  end

  def current_streak
    streak = 0
    question_attempts.order(created_at: :desc).each do |attempt|
      break unless attempt.correct?

      streak += 1
    end
    streak
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
    self.average_response_ms = if total_answers.positive?
                                 ((average_response_ms * (total_answers - 1)) + response_time_ms) / total_answers
                               else
                                 response_time_ms
                               end
    save!
  end

  def finish!
    update!(status: "completed", completed_at: Time.current)
  end
end
