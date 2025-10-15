require "test_helper"

class QuizEngineAchievementAwarderTest < ActiveSupport::TestCase
  setup do
    # Jedes Szenario beginnt mit einem leeren Achievement-Setup, damit vorherige Vergaben nicht stoeren.
    UserAchievement.delete_all
    Achievement.delete_all
    Achievement.catalog.each { |attrs| Achievement.create!(attrs) }

    @category = Category.create!(name: "Test-Kategorie", featured: false)

    @user = User.create!(
      username: "player",
      email: "player@example.com",
      password: "Password123!",
      display_name: "Player"
    )
    @opponent = User.create!(
      username: "opponent",
      email: "opponent@example.com",
      password: "Password123!",
      display_name: "Opponent"
    )
  end

  test "awards a bundle of achievements based on match performance" do
    # Match mit sehr guter Leistung vorbereiten: perfekte Runde, hohe Punkte, schnelle Zeiten.
    match = Match.create!(
      creator: @user,
      category: @category,
      mode: "versus",
      state: "completed",
      question_count: 10,
      time_per_question: 20
    )

    participation = match.match_participations.create!(
      user: @user,
      status: "completed",
      score: 1_300,
      correct_count: 10,
      incorrect_count: 0,
      average_response_ms: 4_000,
      best_streak: 10,
      completed_at: Time.current
    )

    match.match_participations.create!(
      user: @opponent,
      status: "completed",
      score: 800,
      correct_count: 6,
      incorrect_count: 4,
      average_response_ms: 6_000,
      best_streak: 3,
      completed_at: Time.current
    )

    @user.update!(total_points: 3_200, daily_streak: 7)

    # Awarder ausfuehren und die vergebenen Codes auslesen.
    QuizEngine::AchievementAwarder.call(participation)

    awarded_codes = @user.user_achievements.includes(:achievement).map { |ua| ua.achievement.code }

    expected_codes = %w[
      first_steps
      point_collector
      point_hoarder
      point_tycoon
      streak_starter
      streak_keeper
      perfect_run
      speedster
      duel_champion
      hot_hand
      unstoppable
      big_game
      score_machine
      collection_hobbyist
      collection_master
    ]

    expected_codes.each do |code|
      assert_includes awarded_codes, code, "Expected achievement #{code} to be awarded"
    end

    # Keine zusaetzlichen Auszeichnungen und Punkte wurden durch Boni erhoeht.
    assert_equal expected_codes.size, awarded_codes.size
    assert @user.total_points > 3_200, "Total points should have increased through achievement bonuses"
  end

  test "awards higher tier perfect match achievements cumulatively" do
   tatus: "completed",
        score: 900,
        correct_count: 8,
        incorrect_count: 0,
        average_response_ms: 3_800,
        best_streak: 8,
        completed_at: Time.current
      )
    end

    final_match = Match.create!(base_match_attrs.merge(mode: "versus", title: "Final"))
    final_participation = final_match.match_participations.create!(
      user: @user,
      status: "completed",
      score: 950,
      correct_count: 8,
      incorrect_count: 0,
      average_response_ms: 3_500,
      best_streak: 8,
      completed_at: Time.current
    )

    final_match.match_participations.create!(
      user: @opponent,
      status: "completed",
      score: 400,
      correct_count: 3,
      incorrect_count: 5,
      average_response_ms: 4_500,
      best_streak: 2,
      completed_at: Time.current
    )

    @user.update!(total_points: 2_000, daily_streak: 2)

    # AchievementAwarder prueft die Zaehler und sollte verschiedene Stufen vergeben.
    QuizEngine::AchievementAwarder.call(final_participation)

    codes = @user.user_achievements.includes(:achievement).map { |ua| ua.achievement.code }

    # Erwartung: Die ersten beiden Stufen erreicht, die hoechste noch nicht.
    assert_includes codes, "perfect_run"
    assert_includes codes, "sharpshooter"
    assert_not_includes codes, "flawless_legend"
  end
end
