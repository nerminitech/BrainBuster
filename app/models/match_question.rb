class MatchQuestion < ApplicationRecord
  belongs_to :match
  belongs_to :question

  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
