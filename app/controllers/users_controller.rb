class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @user = User.find(params[:id])
    @recent_achievements = @user.user_achievements.includes(:achievement).order(awarded_at: :desc).limit(10)
    @recent_participations = @user.match_participations.includes(match: :category).order(completed_at: :desc).limit(10)
  end
end
