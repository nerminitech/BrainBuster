module QuizEngine
  class Scoring
    # Konstanten beschreiben, wie Zusatzpunkte entstehen.
    SPEED_BONUS_FACTOR = 0.5 # Der Bonus bezieht sich auf die base points.
    STREAK_THRESHOLD = 3
    STREAK_BONUS_MULTIPLIER = 10

    # Ein neues Objet erstellt was das Debuggen einfacher macht.
    Result = Struct.new(:total_points, :components, keyword_init: true)

    # Baut eine Instanz und führt die Berechnung aus mit call. Syntaktischer Zucker.
    def self.call(question:, response_time_ms:, correct:, current_streak: 0)
      new(question:, response_time_ms:, correct:, current_streak:).call
    end

    # Der Konstruktor erstellt ein frisches Objekt mit Startwerten. Erste Methode die aufgerufen wird und initalisiert ein Objekt mit Startwerten.
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

    # Hilfsmethode von Rails: stellt Getter für die gespeicherten Werte bereit.
    attr_reader :question, :response_time_ms, :correct, :current_streak

    def calculate_speed_bonus(base)
      # Bonus orientiert sich daran, wie viel Zeit noch übrig war.
      # Beispiel: 100 Basis-Punkte, 30s Limit, Antwort nach 15s → (15/30)*100*0.5(diese 0.5 kommen von der Konstanten die oben definiert ist) = 25 Bonuspunkte.
      time_limit_ms = question.time_limit_seconds * 1000
      return 0 if time_limit_ms.zero?

      remaining = [ time_limit_ms - response_time_ms, 0 ].max
      ((remaining.to_f / time_limit_ms) * base * SPEED_BONUS_FACTOR).round
    end

    def calculate_streak_bonus
      # Serienbonus zählt erst ab einer Mindestanzahl richtiger Antworten in Folge.
      return 0 if current_streak < STREAK_THRESHOLD
      # Beispiel: Wenn current_streak 5 ist, dann wäre es 5 x 10 = 50 Zusatzpunkte
      (current_streak * STREAK_BONUS_MULTIPLIER)
    end
  end
end
