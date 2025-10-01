class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  enum :role, { player: 0, admin: 1 }, default: :player, validate: true

  attr_accessor :remove_avatar

  has_many :created_matches, class_name: "Match", foreign_key: :creator_id, inverse_of: :creator, dependent: :nullify
  has_many :match_participations, dependent: :destroy
  has_many :matches, through: :match_participations
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements

  validates :username, presence: true, uniqueness: true, length: { maximum: 40 }
  validates :display_name, length: { maximum: 60 }, allow_blank: true
  validates :bio, length: { maximum: 280 }, allow_blank: true
  validate :avatar_format

  before_validation :ensure_display_name
  before_save :purge_avatar_if_requested

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

  def avatar_format
    return unless avatar.attached?

    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, "ist zu groß (maximal 5 MB)")
    end

    acceptable_types = %w[image/jpeg image/png image/webp image/jpg]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:avatar, "muss ein PNG, JPG oder WEBP sein")
    end
  end

  def purge_avatar_if_requested
    return unless ActiveModel::Type::Boolean.new.cast(remove_avatar)
    avatar.purge_later if avatar.attached?
  end
end
