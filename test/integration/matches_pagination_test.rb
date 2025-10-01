require "test_helper"

class MatchesPaginationTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "paginator@example.com",
      username: "paginator",
      password: "Password123!",
      display_name: "Paginator"
    )
    category = Category.create!(name: "Pagy Category", featured: false)

    12.times do |idx|
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
    sign_in @user, scope: :user

    get matches_path
    assert_response :success
    # File.write("tmp/matches_nav.html", @response.body)
    assert_select "nav.pagy-nav ul li span", text: "1", count: 1

    get matches_path(page: 2)
    assert_response :success
    assert_select "nav.pagy-nav ul li span", text: "2", count: 1
  end
end
