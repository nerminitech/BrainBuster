module QuizEngine
  class AchievementAwarder
    def self.call(participation)
      new(participation).call
    end

    def initialize(participation)
      @participation = participation
      @user = participation.user
    end

    def call
      award("first_steps") if first_match_completed?
      award("perfect_run") if perfect_score?
      award("speedster") if fast_player?
      award("duel_champion") if duel_winner?
    end

    private

    attr_reader :participation, :user

    def award(code)
      achievement = Achievement.find_by(code: code)
      return unless achievement

      UserAchievement.find_or_create_by!(user:, achievement:) do |ua|
        ua.awarded_at = Time.current
        user.add_points!(achievement.points_bonus) if achievement.points_bonus.positive?
      end
    end

    def first_match_completed?
      user.completed_matches == 1
    end

    def perfect_score?
      participation.incorrect_count.zero? &&
        participation.correct_count.positive? &&
        participation.correct_count == participation.match.question_count
    end

    def fast_player?
      participation.average_response_ms.positive? && participation.average_response_ms < 5_000
    end

    def duel_winner?
      return false unless participation.match.versus?

      top_score = participation.match.leaderboard.first
      top_score&.user_id == user.id && participation.status == "completed"
    end
  end
end
