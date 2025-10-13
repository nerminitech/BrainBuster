module QuizEngine
  class Scoring
    # Konstanten beschreiben, wie Zusatzpunkte entstehen.
    SPEED_BONUS_FACTOR = 0.5 # Der Bonus bezieht sich auf die base points.
    STREAK_THRESHOLD = 3
    STREAK_BONUS_MULTIPLIER = 10

    Result = Struct.new(:total_points, :components, keyword_init: true)

    # Einstiegspunkt: baut eine Instanz und führt die Berechnung aus.
    def self.call(question:, response_time_ms:, correct:, current_streak: 0)
      new(question:, response_time_ms:, correct:, current_streak:).call
    end

    # Der Konstruktor erstellt ein frisches Objekt mit Startwerten.
    def initialize(question:, response_time_ms:, correct:, current_streak: 0)
      @question = question
      @response_time_ms = response_time_ms
      @correct = correct
      @current_streak = current_streak
    end

    def call
      # Falsche Antworten bringen sofort 0 Punkte.
      return Result.new(total_points: 0, components: {}) unless correct

      # Basispunktzahl wird sich geholt
      base = question.base_points
      speed_bonus = calculate_speed_bonus(base)
      streak_bonus = calculate_streak_bonus

      # Results objekt wird erstellt und alle komponenten werden auch einzeln gespeichert.
      Result.new(
        total_points: base + speed_bonus + streak_bonus,
        # Components ist ur zum debuggen da damit man weiß wie die PUnktzahl am ende entstanden ist.
        components: {
          base: base,
          speed_bonus: speed_bonus,
          streak_bonus: streak_bonus
        }
      )
    end

    private

    # Hillfsmethoode von Rails. Man muss keine Instanzvariable schrieben oder getter methode benutzen.
    attr_reader :question, :response_time_ms, :correct, :current_streak

    def calculate_speed_bonus(base)
      # Bonus orientiert sich daran, wie viel Zeit noch übrig war.
=begin
      Eine Frage gibt 100 base points
      Zeit Limit ist 30sec
      Du brauchst aber nur 15sec
      (15/30) * 100 * 0.5 = 25 Zusatzpunkte
=end
      time_limit_ms = question.time_limit_seconds * 1000
      return 0 if time_limit_ms.zero?

      remaining = [ time_limit_ms - response_time_ms, 0 ].max
      ((remaining.to_f / time_limit_ms) * base * SPEED_BONUS_FACTOR).round
    end

    def calculate_streak_bonus
      # Serienbonus zählt erst ab einer Mindestanzahl richtiger Antworten in Folge.
      return 0 if current_streak < STREAK_THRESHOLD
      # Wenn current_streak 5 ist, dann wäre es 5 x 10 = 50 Zusatzpunkte
      (current_streak * STREAK_BONUS_MULTIPLIER)
    end
  end
end
