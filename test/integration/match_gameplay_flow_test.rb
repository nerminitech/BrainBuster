require "test_helper"

class MatchGameplayFlowTest < ActionDispatch::IntegrationTest
  setup do
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
      time_limit_seconds: 45,
      base_points: 100
    )

    @correct_option = @question.answer_options.create!(text: "Paris", correct: true, position: 0)
    @question.answer_options.create!(text: "Berlin", correct: false, position: 1)
    @question.answer_options.create!(text: "Madrid", correct: false, position: 2)

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

    @match_question = @match.match_questions.create!(question: @question, position: 0)
    @participation = @match.match_participations.create!(user: @user, status: "pending")
  end

  test "player answers question and completes match" do
    sign_in @user, scope: :user

    get play_match_path(@match)
    assert_response :success
    assert_includes response.body, @question.content

    post match_attempts_path(@match), params: {
      match_question_id: @match_question.id,
      answer_option_id: @correct_option.id
    }

    assert_redirected_to play_match_path(@match)
    follow_redirect!

    assert_redirected_to match_path(@match)
    follow_redirect!

    assert_response :success
    assert_includes response.body, "Gut gemacht!"

    @participation.reload
    assert @participation.completed?
    assert_operator @participation.score, :>, 0
  end
end
