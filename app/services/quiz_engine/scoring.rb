module QuizEngine
  class Scoring
    SPEED_BONUS_FACTOR = 0.5
    STREAK_THRESHOLD = 3
    STREAK_BONUS_MULTIPLIER = 10

    Result = Struct.new(:total_points, :components, keyword_init: true)

    def self.call(question:, response_time_ms:, correct:, current_streak: 0)
      new(question:, response_time_ms:, correct:, current_streak:).call
    end

    def initialize(question:, response_time_ms:, correct:, current_streak: 0)
      @question = question
      @response_time_ms = response_time_ms
      @correct = correct
      @current_streak = current_streak
    end

    def call
      return Result.new(total_points: 0, components: {}) unless correct

      base = question.base_points
      speed_bonus = calculate_speed_bonus(base)
      streak_bonus = calculate_streak_bonus

      Result.new(
        total_points: base + speed_bonus + streak_bonus,
        components: {
          base: base,
          speed_bonus: speed_bonus,
          streak_bonus: streak_bonus
        }
      )
    end

    private

    attr_reader :question, :response_time_ms, :correct, :current_streak

    def calculate_speed_bonus(base)
      time_limit_ms = question.time_limit_seconds * 1000
      return 0 if time_limit_ms.zero?

      remaining = [time_limit_ms - response_time_ms, 0].max
      ((remaining.to_f / time_limit_ms) * base * SPEED_BONUS_FACTOR).round
    end

    def calculate_streak_bonus
      return 0 if current_streak < STREAK_THRESHOLD

      (current_streak * STREAK_BONUS_MULTIPLIER)
    end
  end
end
