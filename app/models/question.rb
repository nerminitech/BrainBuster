class Question < ApplicationRecord
  DIFFICULTIES = %w[leicht mittel schwer experte].freeze

  belongs_to :category
  has_many :match_questions, dependent: :destroy
  has_many :answer_options, -> { order(:position) }, dependent: :destroy, inverse_of: :question

  accepts_nested_attributes_for :answer_options, allow_destroy: true

  validates :content, presence: true, length: { maximum: 350 }
  validates :difficulty, inclusion: { in: DIFFICULTIES }
  validates :base_points, numericality: { greater_than: 0 }
  validates :time_limit_seconds, numericality: { greater_than: 0 }
  validate :must_have_answer_options
  validate :must_have_correct_answer

  scope :in_language, ->(locale) { where(language: locale) }

  def correct_option
    answer_options.detect(&:correct?)
  end

  private

  def must_have_answer_options
    return if active_answer_options.any?

    errors.add(:base, "Mindestens eine Antwortoption muss angegeben werden.")
  end

  def must_have_correct_answer
    return unless active_answer_options.any?
    return if active_answer_options.any?(&:correct?)

    errors.add(:base, "Mindestens eine Antwortoption muss als korrekt markiert werden.")
  end

  def active_answer_options
    answer_options.reject(&:marked_for_destruction?)
  end
end
