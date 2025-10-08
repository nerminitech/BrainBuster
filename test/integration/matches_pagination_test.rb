require "test_helper"

class MatchesPaginationTest < ActionDispatch::IntegrationTest
  setup do
    # User und ausreichend viele Matches erzeugen, um Paginierung sichtbar zu machen.
    @user = User.create!(
      email: "paginator@example.com",
      username: "paginator",
      password: "Password123!",
      display_name: "Paginator"
    )
    category = Category.create!(name: "Pagy Category", featured: false)

    12.times do |idx|
      # Jedes Match wird abgeschlossen, damit es in der Historie auftaucht.
      match = Match.create!(
        creator: @user,
        category: category,
        mode: "solo",
        state: "completed",
        question_count: 5,
        time_per_question: 30,
        share_code: SecureRandom.alphanumeric(6).upcase,
        title: "Match #{idx}"
      )
      match.match_participations.create!(user: @user, status: "completed")
    end
  end

  test "shows paginated matches with nav" do
    # 1) Anmelden, um die Match-Uebersicht aufzurufen.
    sign_in @user, scope: :user

    # 2) Erste Seite aufrufen: Navigations-Element fuer Seite 1 muss vorhanden sein.
    get matches_path
    assert_response :success
    # File.write("tmp/matches_nav.html", @response.body)
    assert_select "nav.pagy-nav ul li span", text: "1", count: 1

    # 3) Zweite Seite aufrufen und ebenfalls auf die Pagy-Navigation pruefen.
    get matches_path(page: 2)
    assert_response :success
    assert_select "nav.pagy-nav ul li span", text: "2", count: 1
  end
end
