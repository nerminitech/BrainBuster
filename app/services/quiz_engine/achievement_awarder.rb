module QuizEngine
  class AchievementAwarder
    # Einstieg: Service mit Teilnahme-Objekt starten.
    def self.call(participation)
      new(participation).call
    end

    def initialize(participation)
      # Vorbereitung: Teilnahme und zugehörigen User merken, Ergebnisliste anlegen.
      @participation = participation
      @user = participation.user
      @awarded = []
    end

    def call
      # Zähler auf den aktuellen Stand bringen (z.B. bereits freigeschaltete Erfolge).
      initialize_counters!

      achievements_to_check.each do |achievement|
        # Überspringen, wenn der Erfolg schon gehört oder Bedingung nicht erfüllt.
        next if unlocked_ids.include?(achievement.id)
        next unless meets_condition?(achievement)

        # Erfolg freischalten, Punkte vergeben, merken.
        award(achievement)
      end

      # Liste der neu vergebenen Achievements zurückgeben.
      @awarded
    end

    private

    attr_reader :participation, :user

    def initialize_counters!
      @achievements_collected_count = user.user_achievements.count
    end

    def achievements_to_check
      # Einmalig alle Achievements in stabiler Reihenfolge holen.
      @achievements_to_check ||= Achievement.order(:created_at, :id)
    end

    def unlocked_ids
      # Cache der bereits freigeschalteten Achievements aufbauen.
      @unlocked_ids ||= user.user_achievements.pluck(:achievement_id)
    end

    def award(achievement)
      # Datenbankeintrag erzeugen, falls noch nicht vorhanden; Bonuspunkte gut schreiben.
      UserAchievement.find_or_create_by!(user:, achievement:) do |ua|
        ua.awarded_at = Time.current
        unlocked_ids << achievement.id
        @achievements_collected_count += 1
        user.add_points!(achievement.points_bonus) if achievement.points_bonus.positive?
        @awarded << achievement
      end
    end

    def meets_condition?(achievement)
      # Nach Bedingungstyp entscheiden, welcher Zähler relevant ist.
      case achievement.condition
      when "matches_completed"
        completed_matches >= achievement.threshold
      when "total_points"
        user.total_points >= achievement.threshold
      when "daily_streak"
        user.daily_streak >= achievement.threshold
      when "perfect_matches"
        perfect_match_count >= achievement.threshold
      when "fast_time"
        best_average_response_ms.positive? && best_average_response_ms <= achievement.threshold
      when "duel_wins"
        duel_wins_count >= achievement.threshold
      when "best_streak"
        best_question_streak >= achievement.threshold
      when "achievements_collected"
        achievements_collected_count >= achievement.threshold
      when "match_score"
        highest_match_score >= achievement.threshold
      else
        false
      end
    end

    def completed_matches
      # Bereits erfolgreich beendete Matches des Users zählen.
      @completed_matches ||= user.match_participations.completed.count
    end

    def perfect_match_count
      # Matches ohne Fehler und mit mindestens einer richtigen Antwort zählen.
      @perfect_match_count ||= user.match_participations
                                     .completed
                                     .where(incorrect_count: 0)
                                     .where("correct_count > 0")
                                     .count
    end

    def best_average_response_ms
      # Beste (kleinste) durchschnittliche Antwortzeit über alle Matches holen.
      @best_average_response_ms ||= user.match_participations
                                        .completed
                                        .where("average_response_ms > 0")
                                        .minimum(:average_response_ms).to_i
    end

    def duel_wins_count
      # Siege in Duellen erfassen: höchster Score, bei Gleichstand schnellere Zeit.
      @duel_wins_count ||= begin
        participations = user.match_participations
                             .includes(match: :match_participations)
                             .where(status: "completed")

        participations.count do |mp|
          next false unless mp.match.mode == "versus"

          winner = mp.match.match_participations.max_by do |candidate|
            [ candidate.score, -candidate.average_response_ms.to_i ]
          end

          winner&.user_id == user.id
        end
      end
    end

    def best_question_streak
      # Längste Serie richtiger Antworten aus allen Matches.
      @best_question_streak ||= user.match_participations.maximum(:best_streak).to_i
    end

    def achievements_collected_count
      @achievements_collected_count
    end

    def highest_match_score
      # Höchster erreichte Match-Score des Users.
      @highest_match_score ||= user.match_participations.maximum(:score).to_i
    end
  end
end
