require "test_helper"

class MatchParticipationTest < ActiveSupport::TestCase
  def setup
    # Komplette Umgebung aufbauen: Spieler*in, Kategorie, Frage mit Antwort und ein Match.
    @user = User.create!(
      email: "participation@example.com",
      username: "participant",
      display_name: "Teilnehmer",
      password: "Passwort123!",
      password_confirmation: "Passwort123!"
    )
    @category = Category.create!(name: "Teilnahme", featured: false)
    @question = @category.questions.create!(
      content: "Wie viele Seiten hat ein Quadrat?",
      difficulty: "leicht",
      time_limit_seconds: 20,
      base_points: 80
    )
    @answer = @question.answer_options.create!(text: "4", correct: true, position: 0)
    @match = Match.create!(
      creator: @user,
      category: @category,
      mode: "solo",
      state: "active",
      question_count: 1,
      time_per_question: 20,
      share_code: "CLI123"
    )
    @match_question = @match.match_questions.create!(question: @question, position: 0)
    @participation = @match.match_participations.create!(user: @user, status: "playing")
  end

  test "register_attempt updates score and clears current question" do
    # Vorbereitung: Teilnahme weiss, welche Frage aktuell bearbeitet wird.
    @participation.start_question!(@match_question)

    @participation.register_attempt!(
      match_question: @match_question,
      answer_option: @answer,
      correct: true,
      response_time_ms: 4_000,
      points_awarded: 120
    )

    # Erwartung: Punkte, Zaehler und Durchschnittszeit aktualisiert, aktive Frage geloescht.
    assert_equal 120, @participation.score
    assert_equal 1, @participation.correct_count
    assert_equal 4_000, @participation.average_response_ms
    assert_nil @participation.current_match_question_id
    assert_nil @participation.current_question_started_at
  end

  test "register_attempt handles nil answer option" do
    # Testet edge-case: automatischer Fehlversuch ohne ausgewaehlte Antwort (z. B. Timeout).
    @participation.start_question!(@match_question)

    assert_nothing_raised do
      @participation.register_attempt!(
        match_question: @match_question,
        answer_option: nil,
        correct: false,
        response_time_ms: 20_000,
        points_awarded: 0
      )
    end

    @participation.reload
    assert_equal 1, @participation.incorrect_count
    assert_nil @participation.current_match_question_id
  end

  test "start_question stores active question once" do
    # Reise in die Zeit, damit wir deterministisch pruefen koennen, wann die Frage gestartet wurde.
    travel_to Time.zone.parse("2024-01-01 12:00:00")
    @participation.start_question!(@match_question)
    @participation.reload

    assert_equal @match_question.id, @participation.current_match_question_id
    assert_in_delta Time.zone.parse("2024-01-01 12:00:00").to_f, @participation.current_question_started_at.to_f, 0.01

    travel 5.seconds

    # Ein erneuter Aufruf soll den Zeitstempel nicht ueberschreiben.
    assert_no_changes -> { @participation.reload.current_question_started_at } do
      @participation.start_question!(@match_question)
    end
  ensure
    travel_back
  end

  test "finish! marks participation as completed" do
    # Abschluss eines Matches setzt Status und Zeitstempel sowie den aktuellen Fragen-Status.
    @participation.start_question!(@match_question)
    @participation.finish!

    assert @participation.completed?
    assert_not_nil @participation.completed_at
    assert_nil @participation.current_match_question_id
  end
end
