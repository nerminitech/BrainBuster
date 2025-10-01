class Achievement < ApplicationRecord
  CONDITIONS = %w[
    matches_completed
    total_points
    daily_streak
    perfect_matches
    fast_time
    duel_wins
    best_streak
    achievements_collected
    match_score
  ].freeze

  CATALOG = [
    {
      code: "first_steps",
      name: "Erstes Quiz",
      description: "Schliesse dein erstes Quiz erfolgreich ab.",
      points_bonus: 50,
      category: "progression",
      threshold: 1,
      condition: "matches_completed"
    },
    {
      code: "quiz_rookie",
      name: "Quiz-Rookie",
      description: "Beende fuenf Quizrunden und sammle Erfahrung.",
      points_bonus: 75,
      category: "progression",
      threshold: 5,
      condition: "matches_completed"
    },
    {
      code: "quiz_enthusiast",
      name: "Quiz-Enthusiast",
      description: "Spiele zehn abgeschlossene Matches.",
      points_bonus: 100,
      category: "progression",
      threshold: 10,
      condition: "matches_completed"
    },
    {
      code: "quiz_veteran",
      name: "Quiz-Veteran",
      description: "Beweise Ausdauer mit 25 abgeschlossenen Matches.",
      points_bonus: 150,
      category: "progression",
      threshold: 25,
      condition: "matches_completed"
    },
    {
      code: "quiz_legend",
      name: "Quiz-Legende",
      description: "Schliesse 50 Matches ab und werde zur Legende.",
      points_bonus: 200,
      category: "progression",
      threshold: 50,
      condition: "matches_completed"
    },
    {
      code: "point_collector",
      name: "Punktesammler",
      description: "Sammle insgesamt 500 Punkte.",
      points_bonus: 50,
      category: "points",
      threshold: 500,
      condition: "total_points"
    },
    {
      code: "point_hoarder",
      name: "Punktehamster",
      description: "Erreiche insgesamt 1.500 Punkte.",
      points_bonus: 75,
      category: "points",
      threshold: 1_500,
      condition: "total_points"
    },
    {
      code: "point_tycoon",
      name: "Punkte-Tycoon",
      description: "Baue ein Punkte-Imperium mit 3.000 Punkten auf.",
      points_bonus: 100,
      category: "points",
      threshold: 3_000,
      condition: "total_points"
    },
    {
      code: "point_mogul",
      name: "Punkte-Mogul",
      description: "Sichere dir 5.000 Gesamtpunkte.",
      points_bonus: 150,
      category: "points",
      threshold: 5_000,
      condition: "total_points"
    },
    {
      code: "point_overlord",
      name: "Punkte-Uebermacht",
      description: "Sammle beeindruckende 10.000 Gesamtpunkte.",
      points_bonus: 250,
      category: "points",
      threshold: 10_000,
      condition: "total_points"
    },
    {
      code: "streak_starter",
      name: "Streak-Starter",
      description: "Halte eine Tages-Serie von drei Tagen am Stueck.",
      points_bonus: 40,
      category: "streaks",
      threshold: 3,
      condition: "daily_streak"
    },
    {
      code: "streak_keeper",
      name: "Streak-Keeper",
      description: "Bleibe sieben Tage in Folge aktiv.",
      points_bonus: 70,
      category: "streaks",
      threshold: 7,
      condition: "daily_streak"
    },
    {
      code: "streak_master",
      name: "Streak-Master",
      description: "Halte eine Serie von 14 Tagen.",
      points_bonus: 120,
      category: "streaks",
      threshold: 14,
      condition: "daily_streak"
    },
    {
      code: "streak_unbreakable",
      name: "Unbezwingbar",
      description: "Erreiche eine 30-Tage-Serie.",
      points_bonus: 200,
      category: "streaks",
      threshold: 30,
      condition: "daily_streak"
    },
    {
      code: "perfect_run",
      name: "Perfekter Lauf",
      description: "Beantworte alle Fragen eines Quiz korrekt.",
      points_bonus: 150,
      category: "accuracy",
      threshold: 1,
      condition: "perfect_matches"
    },
    {
      code: "sharpshooter",
      name: "Prazisionsschuetze",
      description: "Schaffe fuenf perfekte Quizdurchgaenge.",
      points_bonus: 200,
      category: "accuracy",
      threshold: 5,
      condition: "perfect_matches"
    },
    {
      code: "flawless_legend",
      name: "Makelose Legende",
      description: "Triumphiere in zehn perfekten Matches.",
      points_bonus: 300,
      category: "accuracy",
      threshold: 10,
      condition: "perfect_matches"
    },
    {
      code: "speedster",
      name: "Blitzschnell",
      description: "Halte deine durchschnittliche Antwortzeit unter fuenf Sekunden.",
      points_bonus: 100,
      category: "speed",
      threshold: 5_000,
      condition: "fast_time"
    },
    {
      code: "lightning_fast",
      name: "Gewitterhirn",
      description: "Erziele eine durchschnittliche Antwortzeit unter 3,5 Sekunden.",
      points_bonus: 125,
      category: "speed",
      threshold: 3_500,
      condition: "fast_time"
    },
    {
      code: "reaction_master",
      name: "Reaktionsmeister",
      description: "Unterbiete eine durchschnittliche Antwortzeit von 2,5 Sekunden.",
      points_bonus: 160,
      category: "speed",
      threshold: 2_500,
      condition: "fast_time"
    },
    {
      code: "duel_champion",
      name: "Duell-Champion",
      description: "Gewinne ein Duell gegen andere Spieler.",
      points_bonus: 200,
      category: "versus",
      threshold: 1,
      condition: "duel_wins"
    },
    {
      code: "duel_veteran",
      name: "Duell-Veteran",
      description: "Gewinne fuenf Duelle.",
      points_bonus: 250,
      category: "versus",
      threshold: 5,
      condition: "duel_wins"
    },
    {
      code: "duel_overlord",
      name: "Duell-Overlord",
      description: "Setze dich in 15 Duellen durch.",
      points_bonus: 350,
      category: "versus",
      threshold: 15,
      condition: "duel_wins"
    },
    {
      code: "hot_hand",
      name: "Heisse Hand",
      description: "Baue eine Fragenserie von fuenf richtigen Antworten auf.",
      points_bonus: 60,
      category: "focus",
      threshold: 5,
      condition: "best_streak"
    },
    {
      code: "unstoppable",
      name: "Unaufhaltsam",
      description: "Erreiche eine Serie von zehn richtigen Antworten.",
      points_bonus: 120,
      category: "focus",
      threshold: 10,
      condition: "best_streak"
    },
    {
      code: "blazing_mind",
      name: "Brennender Geist",
      description: "Beantworte 15 Fragen hintereinander richtig.",
      points_bonus: 180,
      category: "focus",
      threshold: 15,
      condition: "best_streak"
    },
    {
      code: "collection_hobbyist",
      name: "Achievement-Sammler",
      description: "Schalte fuenf Achievements frei.",
      points_bonus: 80,
      category: "collection",
      threshold: 5,
      condition: "achievements_collected"
    },
    {
      code: "collection_master",
      name: "Sammlermeister",
      description: "Schalte zwoelf Achievements frei.",
      points_bonus: 140,
      category: "collection",
      threshold: 12,
      condition: "achievements_collected"
    },
    {
      code: "collection_grandmaster",
      name: "Sammler-Grandmaster",
      description: "Schalte 20 Achievements frei.",
      points_bonus: 220,
      category: "collection",
      threshold: 20,
      condition: "achievements_collected"
    },
    {
      code: "big_game",
      name: "Grosses Spiel",
      description: "Erziele 800 Punkte in einem Match.",
      points_bonus: 90,
      category: "performance",
      threshold: 800,
      condition: "match_score"
    },
    {
      code: "score_machine",
      name: "Punkte-Maschine",
      description: "Schaffe 1.200 Punkte in einem einzigen Match.",
      points_bonus: 140,
      category: "performance",
      threshold: 1_200,
      condition: "match_score"
    },
    {
      code: "titan_score",
      name: "Punkte-Titan",
      description: "Erreiche 1.800 Punkte in einer Matchrunde.",
      points_bonus: 220,
      category: "performance",
      threshold: 1_800,
      condition: "match_score"
    }
  ].freeze

  has_many :user_achievements, dependent: :destroy

  validates :code, :name, :condition, :category, presence: true
  validates :code, uniqueness: true
  validates :condition, inclusion: { in: CONDITIONS }
  validates :threshold, numericality: { greater_than_or_equal_to: 0 }
  validates :points_bonus, numericality: { greater_than_or_equal_to: 0 }

  def self.catalog
    CATALOG
  end
end
