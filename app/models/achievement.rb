class Achievement < ApplicationRecord
  has_many :user_achievements, dependent: :destroy

  validates :code, :name, presence: true
  validates :code, uniqueness: true
end
