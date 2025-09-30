class QuestionAttempt < ApplicationRecord
  belongs_to :match_participation
  belongs_to :match_question
  belongs_to :answer_option, optional: true

  delegate :question, to: :match_question

  validates :response_time_ms, numericality: { greater_than_or_equal_to: 0 }
end
