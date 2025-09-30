class Category < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :featured, -> { where(featured: true) }

  def available_questions
    questions.size
  end
end
