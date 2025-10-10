class LeaderboardsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @pagy, @top_players = pagy(Leaderboard::Global.top_players, limit: 50)
    @recent_matches = Leaderboard::Global.recent_matches(limit: 10)
    @best_of_week = Leaderboard::Global.best_of_week(limit: 10)
  end
end
