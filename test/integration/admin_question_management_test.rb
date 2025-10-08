require "test_helper"

class AdminQuestionManagementTest < ActionDispatch::IntegrationTest
  setup do
    # Admin-Nutzer und Beispielkategorie vorbereiten, damit Fragen angelegt werden koennen.
    @admin = User.create!(
      username: "admin_user",
      email: "admin@example.com",
      password: "Password123!",
      display_name: "Admin",
      role: :admin
    )
    @category = Category.create!(name: "Integration Kategorie", description: "Nur für Tests")
  end

  test "admin creates question inside category" do
    # 1) Admin anmelden, nur dann sind die Admin-Routen erreichbar.
    sign_in @admin, scope: :user

    # 2) POST-Request simuliert das Formular zum Erstellen einer Frage inklusive Antwortoptionen.
    post admin_category_questions_path(@category), params: {
      question: {
        content: "Wie lautet die Integrationsfrage?",
        explanation: "Eine Testfrage für den Admin-Flow.",
        difficulty: "leicht",
        time_limit_seconds: 30,
        base_points: 120,
        answer_options_attributes: {
          "0" => { text: "Antwort A", correct: true, position: 0 },
          "1" => { text: "Antwort B", correct: false, position: 1 },
          "2" => { text: "Antwort C", correct: false, position: 2 },
          "3" => { text: "Antwort D", correct: false, position: 3 }
        }
      }
    }

    # 3) Erfolgreiche Anlage fuehrt zur Kategorie-Seite zurueck.
    assert_redirected_to admin_category_path(@category)
    follow_redirect!

    # 4) Erfolgsmeldung und fachliche Prüfungen: Frage existiert und besitzt vier Optionen,
    # eine davon markiert als korrekt.
    assert_includes response.body, "Frage wurde hinzugefügt"

    question = @category.questions.find_by(content: "Wie lautet die Integrationsfrage?")
    assert_not_nil question
    assert_equal 4, question.answer_options.count
    assert_equal "Antwort A", question.correct_option.text
  end

  test "invalid data rerenders category show with errors" do
    # 1) Wieder als Admin anmelden.
    sign_in @admin, scope: :user

    # 2) Bewusst ungueltige Daten senden (fehlender Inhalt/Antworten), um die Fehlerbehandlung zu testen.
    post admin_category_questions_path(@category), params: {
      question: {
        content: "",
        difficulty: "leicht",
        time_limit_seconds: 30,
        base_points: 100,
        answer_options_attributes: {
          "0" => { text: "", correct: true, position: 0 },
          "1" => { text: "", correct: false, position: 1 },
          "2" => { text: "", correct: false, position: 2 },
          "3" => { text: "", correct: false, position: 3 }
        }
      }
    }

    # 3) Statt Redirect gibt es HTTP 422 und die Fehlerhinweise werden eingeblendet.
    assert_response 422
    assert_includes response.body, "Bitte behebe die folgenden Fehler"
  end
end
