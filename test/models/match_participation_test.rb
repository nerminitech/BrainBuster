require "test_helper"

class MatchParticipationTest < ActiveSupport::TestCase
  def setup
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

  test "register_attempt updates score and counters" do
    @participation.register_attempt!(
      match_question: @match_question,
      answer_option: @answer,
      correct: true,
      response_time_ms: 4_000,
      points_awarded: 120
    )

    assert_equal 120, @participation.score
    assert_equal 1, @participation.correct_count
    assert_equal 4_000, @participation.average_response_ms
  end

  test "finish! marks participation as completed" do
    @participation.finish!
    assert @participation.completed?
    assert_not_nil @participation.completed_at
  end
end
