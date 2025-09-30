class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[landing help]

  def landing
    return redirect_to dashboard_path if user_signed_in?

    @featured_categories = Category.featured.limit(6)
    render layout: "public"
  end

  def home
    @featured_categories = Category.featured.limit(3)
    @recent_matches = current_user.match_participations.order(created_at: :desc).limit(5)
    @leaderboard = Leaderboard::Global.top_players(limit: 5)
  end

  def help
    @categories = Category.order(:name)
  end
end
