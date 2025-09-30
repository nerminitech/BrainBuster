class Match < ApplicationRecord
  MODES = %w[solo versus].freeze
  STATES = %w[draft open active completed archived].freeze

  belongs_to :creator, class_name: "User"
  belongs_to :category

  has_many :match_questions, -> { order(:position) }, dependent: :destroy
  has_many :questions, through: :match_questions
  has_many :match_participations, dependent: :destroy

  validates :mode, inclusion: { in: MODES }
  validates :state, inclusion: { in: STATES }
  validates :question_count, numericality: { greater_than: 0, less_than_or_equal_to: 50 }
  validates :time_per_question, numericality: { greater_than: 0, less_than_or_equal_to: 120 }
  validates :share_code, presence: true, uniqueness: true

  before_validation :ensure_share_code

  scope :publicly_visible, -> { where(state: %w[open active completed]) }

  def solo?
    mode == "solo"
  end

  def versus?
    mode == "versus"
  end

  def active?
    state == "active"
  end

  def completed?
    state == "completed"
  end

  def open?
    state == "open"
  end

  def leaderboard
    match_participations.includes(:user).order(score: :desc, average_response_ms: :asc)
  end

  private

  def ensure_share_code
    self.share_code ||= SecureRandom.alphanumeric(6).upcase
  end
end
