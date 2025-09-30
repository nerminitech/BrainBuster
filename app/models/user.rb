class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { player: 0, admin: 1 }, default: :player, validate: true

  has_many :created_matches, class_name: "Match", foreign_key: :creator_id, inverse_of: :creator, dependent: :nullify
  has_many :match_participations, dependent: :destroy
  has_many :matches, through: :match_participations
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements

  validates :username, presence: true, uniqueness: true, length: { maximum: 40 }
  validates :display_name, length: { maximum: 60 }, allow_blank: true

  before_validation :ensure_display_name

  def add_points!(points)
    self.total_points += points
    save!
  end

  def completed_matches
    match_participations.completed.count
  end

  private

  def ensure_display_name
    self.display_name = username if display_name.blank?
  end
end
