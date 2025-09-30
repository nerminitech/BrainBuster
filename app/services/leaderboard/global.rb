module Leaderboard
  class Global
    def self.top_players(limit: 10)
      User.order(total_points: :desc).limit(limit)
    end

    def self.recent_matches(limit: 10)
      Match.where(state: "completed").order(completed_at: :desc).limit(limit)
    end

    def self.best_of_week(limit: 10)
      MatchParticipation.completed
                         .where("completed_at >= ?", 1.week.ago)
                         .includes(:user)
                         .order(score: :desc)
                         .limit(limit)
    end
  end
end
