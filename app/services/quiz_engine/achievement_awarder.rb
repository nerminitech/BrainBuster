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
      initialize_counters!

      achievements_to_check.each do |achievement|
        next if unlocked_ids.include?(achievement.id)
        next unless meets_condition?(achievement)

        award(achievement)
      end
    end

    private

    attr_reader :participation, :user

    def initialize_counters!
      @achievements_collected_count = user.user_achievements.count
    end

    def achievements_to_check
      @achievements_to_check ||= Achievement.order(:created_at, :id)
    end

    def unlocked_ids
      @unlocked_ids ||= user.user_achievements.pluck(:achievement_id)
    end

    def award(achievement)
      UserAchievement.find_or_create_by!(user:, achievement:) do |ua|
        ua.awarded_at = Time.current
        unlocked_ids << achievement.id
        @achievements_collected_count += 1
        user.add_points!(achievement.points_bonus) if achievement.points_bonus.positive?
      end
    end

    def meets_condition?(achievement)
      case achievement.condition
      when "matches_completed"
        completed_matches >= achievement.threshold
      when "total_points"
        user.total_points >= achievement.threshold
      when "daily_streak"
        user.daily_streak >= achievement.threshold
      when "perfect_matches"
        perfect_match_count >= achievement.threshold
      when "fast_time"
        best_average_response_ms.positive? && best_average_response_ms <= achievement.threshold
      when "duel_wins"
        duel_wins_count >= achievement.threshold
      when "best_streak"
        best_question_streak >= achievement.threshold
      when "achievements_collected"
        achievements_collected_count >= achievement.threshold
      when "match_score"
        highest_match_score >= achievement.threshold
      else
        false
      end
    end

    def completed_matches
      @completed_matches ||= user.match_participations.completed.count
    end

    def perfect_match_count
      @perfect_match_count ||= user.match_participations
                                     .completed
                                     .where(incorrect_count: 0)
                                     .where("correct_count > 0")
                                     .count
    end

    def best_average_response_ms
      @best_average_response_ms ||= user.match_participations
                                        .completed
                                        .where("average_response_ms > 0")
                                        .minimum(:average_response_ms).to_i
    end

    def duel_wins_count
      @duel_wins_count ||= begin
        participations = user.match_participations
                             .includes(match: :match_participations)
                             .where(status: "completed")

        participations.count do |mp|
          next false unless mp.match.mode == "versus"

          winner = mp.match.match_participations.max_by do |candidate|
            [ candidate.score, -candidate.average_response_ms.to_i ]
          end

          winner&.user_id == user.id
        end
      end
    end

    def best_question_streak
      @best_question_streak ||= user.match_participations.maximum(:best_streak).to_i
    end

    def achievements_collected_count
      @achievements_collected_count
    end

    def highest_match_score
      @highest_match_score ||= user.match_participations.maximum(:score).to_i
    end
  end
end
