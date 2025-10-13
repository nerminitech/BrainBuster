require "test_helper"

class MatchGameplayFlowTest < ActionDispatch::IntegrationTest
  setup do
    # Vorbereitungen: Eine Spielerin, Kategorie, Frage samt Antworten und ein Match anlegen,
    # damit der Flow den kompletten Spielablauf nachvollziehen kann.
    @user = User.create!(
      username: "player_one",
      email: "player@example.com",
      password: "Password123!",
      display_name: "Player One"
    )

    @category = Category.create!(name: "Gameplay", description: "Integration flow category")

    @question = Question.create!(
      category: @category,
      content: "Wie heißt die Hauptstadt von Frankreich?",
      difficulty: "leicht",
      # Wird nichtmehr genutzt
      time_limit_seconds: 45,
      base_points: 100
    )

    @correct_option = @question.answer_options.create!(text: "Paris", correct: true, position: 0)
    @question.answer_options.create!(text: "Berlin", correct: false, position: 1)
    @question.answer_options.create!(text: "Madrid", correct: false, position: 2)
    @question.answer_options.create!(text: "Rom", correct: false, position: 3)

    @match = Match.create!(
      creator: @user,
      category: @category,
      mode: "solo",
      state: "draft",
      question_count: 1,
      time_per_question: 45,
      started_at: nil,
      share_code: "ABC123",
      title: "Gameplay Flow"
    )

    # Anlegen von einem Datensatz der Frage die gestellt wird im Match
    @match_question = @match.match_questions.create!(question: @question, position: 0)
    # Anlegen des Teilnehmers innerhalb des Matches als Datensatz
    @participation = @match.match_participations.create!(user: @user, status: "pending")
  end

  test "player answers question and completes match" do
    # 1) Spieler:in anmelden, damit geschuetzte Routen genutzt werden koennen.
    # Zum anmelden gibt es den scope user. Wir haben User und Admin
    sign_in @user, scope: :user

    # 2) Spielseite aufrufen und pruefen, ob die Frage tatsächlich angezeigt wird.
    # http get methode wird aufgerufen für das Match.
    get play_match_path(@match)
    # Prüfen ob die Rückmeldung erfolgreich war.
    assert_response :success
    # Prüfen ob die Frage im Body enthalten ist. Also werden die Fragen angezeigt im HTML body.
    assert_includes response.body, @question.content

    # 3) Antwort absenden (richtige Option) – simuliert den Form-Submit im Frontend.
    post match_attempts_path(@match), params: {
      # match_question_id welche frage wird da gerade beantwortet.
      match_question_id: @match_question.id,
      # welche antwort der user eingegeben hat
      answer_option_id: @correct_option.id
    }

    # 4) Nach dem Submit folgen zwei Redirects: zur Spielansicht und danach zur Ergebnisanzeige.
    # Erste redirect damit man zur nächsten Frage kommt
    # assertr_rdirected_to checkt ob nachdem post korrekt redirected wird. Also ein Check.
    assert_redirected_to play_match_path(@match)
    follow_redirect!

    # Zweiter redirect passiert wenn keine Fragen mehr vorhanden sind.
    assert_redirected_to match_path(@match)
    follow_redirect!

    # 5) Abschliessende Seite bestaetigen und Erfolgstext erwarten.
    assert_response :success
    assert_includes response.body, "Gut gemacht!"

    # 6) Teilnahme neu laden und sicherstellen, dass das Match abgeschlossen und gewertet wurde.
    @participation.reload
    assert @participation.completed?
    assert_operator @participation.score, :>, 0
    # match_participation.register_attempt! würde dann die punkte dem User gutschreiben.
  end
end
