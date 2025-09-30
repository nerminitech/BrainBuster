class AnswerOption < ApplicationRecord
  belongs_to :question

  validates :text, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
