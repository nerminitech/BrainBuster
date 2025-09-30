class Question < ApplicationRecord
  DIFFICULTIES = %w[leicht mittel schwer experte].freeze

  belongs_to :category
  has_many :answer_options, -> { order(:position) }, dependent: :destroy, inverse_of: :question
  has_many :match_questions, dependent: :destroy

  accepts_nested_attributes_for :answer_options, allow_destroy: true

  validates :content, presence: true
  validates :difficulty, inclusion: { in: DIFFICULTIES }
  validates :base_points, numericality: { greater_than: 0 }
  validates :time_limit_seconds, numericality: { greater_than: 0 }

  scope :in_language, ->(locale) { where(language: locale) }

  def correct_option
    answer_options.detect(&:correct?)
  end
end
