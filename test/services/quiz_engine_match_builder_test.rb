require "test_helper"

class QuizEngineMatchBuilderTest < ActiveSupport::TestCase
  def setup
    # Builder benoetigt eine Spielerin, eine Kategorie sowie ausreichende Fragen.
    @user = User.create!(
      email: "builder@example.com",
      username: "builder",
      display_name: "Builder",
      password: "Passwort123!",
      password_confirmation: "Passwort123!"
    )
    @category = Category.create!(name: "Builder Kategorie", featured: false)
    6.times do |index|
      # Jede Frage erhaelt mindestens eine korrekte Antwortoption, damit sie spielbar ist.
      @category.questions.create!(
        content: "Frage #{index}",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 80,
        answer_options_attributes: [
          { text: "Antwort", correct: true, position: 0 }
        ]
      )
    end
  end

  test "creates match with the requested number of questions" do
    # Builder aufrufen und ein Match mit genau 5 Fragen erzeugen.
    match = QuizEngine::MatchBuilder.new(
      user: @user,
      category: @category,
      mode: "solo",
      question_count: 5,
      time_per_question: 20
    ).call

    # Ergebnis pruefen: Fragenanzahl, Creator-Zuordnung und Teilnahme des Erstellers.
    assert_equal 5, match.match_questions.count
    assert_equal @user, match.creator
    assert match.match_participations.exists?(user: @user)
  end

  test "raises when not enough questions are available" do
    # Ueberzogene Fragenanzahl fuehrt zu einer Validierungs-Exception.
    assert_raises ActiveRecord::RecordInvalid do
      QuizEngine::MatchBuilder.new(
        user: @user,
        category: @category,
        mode: "solo",
        question_count: 42,
        time_per_question: 20
      ).call
    end
  end
end
