module QuizEngine
  class MatchBuilder
    # Standardanzahl an Fragen, falls nichts angegeben wird.
    DEFAULT_QUESTION_COUNT = 10

    # Baut einen MatchBuilder mit allen Eingaben, setzt Defaults bei ungültigen Werten.
    # Ist der Konsturktor. Läuft als erstes wenn ein neues Objekt erstellt wird.
    def initialize(user:, category:, mode:, question_count: DEFAULT_QUESTION_COUNT, time_per_question: 30)
      @user = user
      @category = category
      @mode = mode
      @question_count = question_count.to_i.positive? ? question_count.to_i : DEFAULT_QUESTION_COUNT
      @time_per_question = time_per_question.to_i.positive? ? time_per_question.to_i : 30
    end

    def call
      # Alles in einer Transaktion, damit bei Fehlern nichts halb-fertig gespeichert wird.
      Match.transaction do
        match = Match.create!(
          creator: user,
          category: category,
          mode: mode,
          state: initial_state,
          question_count: @question_count,
          time_per_question: @time_per_question,
          started_at: initial_state == "active" ? Time.current : nil,
          title: generate_title
        )

        # Fragen zuordnen und erste Teilnahme anlegen.
        assign_questions!(match)
        create_participation!(match)

        match
      end
    end

    private

    attr_reader :user, :category, :mode

    def initial_state
      # Solo-Matches starten sofort, andere bleiben offen für Mitspieler:innen.
      mode == "solo" ? "active" : "open"
    end

    def assign_questions!(match)
      # Ausgewählte Fragen der Kategorie an das Match anhängen.
      sample_questions.each_with_index do |question, position|
        match.match_questions.create!(question: question, position: position)
      end
    end

    def create_participation!(match)
      # Erste Teilnahme erzeugen – bei Solo direkt „playing“, sonst „pending". Fängt ein Spieler an mit dem Spiel so geht das Programm auf "playing" im MatchesController passiert das.
      # Ist eine Sache die leider nicht vollständig eingebaut wurde.
      status = match.solo? ? "playing" : "pending"
      match.match_participations.create!(user: user, status: status)
    end

    def sample_questions
      # Zufällige Fragen der Kategorie ziehen; Abbruch, wenn zu wenige existieren.
      scope = category.questions
      if scope.count < @question_count
        category.errors.add(:base, "Für diese Kategorie existieren nicht genügend Fragen.")
        raise ActiveRecord::RecordInvalid.new(category)
      end

      scope.order("RANDOM()").limit(@question_count)
    end

    def generate_title
      # Match-Titel zusammensetzen (z.B. „Solo-Quiz – Geschichte“).
      base = match_title_prefix
      "#{base} – #{category.name}"
    end

    def match_title_prefix
      # Präfix abhängig vom Modus bestimmen.
      mode == "solo" ? "Solo-Quiz" : "Gruppen-Quiz"
    end
  end
end
