class AchievementsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @achievements = Achievement.order(:name)
    if current_user
      @unlocked_ids = current_user.achievements.pluck(:id)
      @recent_achievements = current_user.user_achievements.includes(:achievement).order(awarded_at: :desc).limit(10)
    else
      @unlocked_ids = []
      @recent_achievements = []
    end
  end
end
