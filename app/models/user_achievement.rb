class UserAchievement < ApplicationRecord
  belongs_to :user, counter_cache: :achievements_count
  belongs_to :achievement

  validates :awarded_at, presence: true
end
