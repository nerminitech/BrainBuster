module QuizEngine
  class MatchBuilder
    DEFAULT_QUESTION_COUNT = 10

    def initialize(user:, category:, mode:, question_count: DEFAULT_QUESTION_COUNT, time_per_question: 30)
      @user = user
      @category = category
      @mode = mode
      @question_count = question_count.to_i.positive? ? question_count.to_i : DEFAULT_QUESTION_COUNT
      @time_per_question = time_per_question.to_i.positive? ? time_per_question.to_i : 30
    end

    def call
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

        assign_questions!(match)
        create_participation!(match)

        match
      end
    end

    private

    attr_reader :user, :category, :mode

    def initial_state
      mode == "solo" ? "active" : "open"
    end

    def assign_questions!(match)
      sample_questions.each_with_index do |question, position|
        match.match_questions.create!(question: question, position: position)
      end
    end

    def create_participation!(match)
      status = match.solo? ? "playing" : "pending"
      match.match_participations.create!(user: user, status: status)
    end

    def sample_questions
      scope = category.questions
      if scope.count < @question_count
        category.errors.add(:base, "Für diese Kategorie existieren nicht genügend Fragen.")
        raise ActiveRecord::RecordInvalid.new(category)
      end

      scope.order("RANDOM()").limit(@question_count)
    end

    def generate_title
      base = match_title_prefix
      "#{base} – #{category.name}"
    end

    def match_title_prefix
      mode == "solo" ? "Solo-Quiz" : "Duell"
    end
  end
end
