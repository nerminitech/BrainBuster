class MatchQuestion < ApplicationRecord
  belongs_to :match
  belongs_to :question
  has_many :question_attempts, dependent: :destroy

  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
