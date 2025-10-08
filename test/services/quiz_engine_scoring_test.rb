require "test_helper"

class QuizEngineScoringTest < ActiveSupport::TestCase
  test "awards base points plus speed bonus" do
    # Ausgangsdaten: Frage mit korrekter Antwortoption fuer einen schnellen, richtigen Versuch.
    category = Category.create!(name: "Test", featured: false)
    question = category.questions.create!(
      content: "Wie viele Farben hat die deutsche Flagge?",
      difficulty: "mittel",
      time_limit_seconds: 30,
      base_points: 100
    )
    question.answer_options.create!(text: "3", correct: true, position: 0)

    # Spieler beantwortet die Frage schnell und mit laufender Streak.
    result = QuizEngine::Scoring.call(
      question: question,
      response_time_ms: 5_000,
      correct: true,
      current_streak: 4
    )

    # Erwartung: Bonuspunkte oberhalb des Basiswertes sowie korrekt ausgewiesene Komponenten.
    assert result.total_points > question.base_points, "Speed- oder Streak-Bonus sollte Punkte erhöhen"
    assert_equal question.base_points, result.components[:base]
  end

  test "returns zero points for wrong answers" do
    # Zweites Szenario: falsche Antwort, egal wie schnell, bringt 0 Punkte.
    category = Category.create!(name: "Test 2", featured: false)
    question = category.questions.create!(
      content: "Dummy",
      difficulty: "leicht",
      time_limit_seconds: 20,
      base_points: 80
    )
    question.answer_options.create!(text: "A", correct: false, position: 0)

    result = QuizEngine::Scoring.call(
      question: question,
      response_time_ms: 2_000,
      correct: false,
      current_streak: 5
    )

    # Erwartung: Gesamtpunkte 0.
    assert_equal 0, result.total_points
  end
end
