# Klassendiagramm – Erläuterung

Das Klassendiagramm beschreibt die wichtigsten Bausteine der BrainBuster-Anwendung und wie sie miteinander verbunden sind. Hier die einzelnen Elemente im Klartext:

1. **User** – repräsentiert registrierte Spieler:innen. Sie besitzen u. a. einen `username`, einen Anzeigenamen (`display_name`), gesammelte Punkte (`total_points`) und eine Rolle (`role`, z. B. Spieler oder Admin). Über `add_points!` werden Bonuspunkte (z. B. für Achievements) gutgeschrieben.

2. **Category** – bündelt Fragen zu einem Thema. Felder wie `name`, `description` und `featured` steuern, was im Frontend prominent gezeigt wird.

3. **Question** – einzelne Quizfrage. Attribute wie `content`, `difficulty`, `base_points` und `time_limit_seconds` legen die Inhalte und Rahmenbedingungen fest. Mit `correct_option` ermittelt die Klasse die richtige Antwort.

4. **AnswerOption** – mögliche Antwort zu einer Frage (`text`), die über das Flag `correct` markiert sein kann.

5. **Match** – eine Quizrunde. `mode` (Solo oder Duell), `state`, `question_count`, `time_per_question` und `share_code` beschreiben den Spieltyp. `leaderboard` liefert die Rangliste zur Runde.

6. **MatchQuestion** – verbindet eine Frage mit einem konkreten Match und speichert die Reihenfolge (`position`). Dadurch kann dieselbe Frage in unterschiedlichen Matches auftauchen.

7. **MatchParticipation** – legt fest, wie ein User an einem Match teilnimmt: erzielte Punkte (`score`), Anzahl richtiger/falscher Antworten (`correct_count`, `incorrect_count`), beste Serie (`best_streak`) und die Durchschnittszeit (`average_response_ms`). Methoden wie `register_attempt!` bzw. `finish!` aktualisieren die Werte während des Spiels.

8. **QuestionAttempt** – dokumentiert jede beantwortete Frage innerhalb einer Teilnahme: `correct` (ja/nein), `response_time_ms` und vergebene Punkte (`awarded_points`). So lässt sich später nachvollziehen, wie die Leistung zustande kam.

9. **Achievement** – Auszeichnungen mit `code`, `name` und optionalem Punktebonus (`points_bonus`). Sie definieren die Kriterien, nach denen Spieler:innen belohnt werden.

10. **UserAchievement** – Verknüpfung zwischen User und Achievement. Speichert den Zeitpunkt (`awarded_at`), zu dem der Erfolg freigeschaltet wurde.

## Beziehungen im Überblick

- Ein **User** kann an vielen Matches teilnehmen (`MatchParticipation`) und Achievements erhalten. Außerdem kann er Matches erstellen (`Match` – über das Feld `creator`).
- Eine **Category** enthält viele Fragen, jede **Question** hat mehrere Antwortoptionen.
- Ein **Match** besteht aus mehreren **MatchQuestions**, die wiederum auf Fragen verweisen. Die Ergebnisse eines Matches entstehen über die zugehörigen **MatchParticipations**.
- Jede **MatchParticipation** besitzt viele **QuestionAttempts**, die wiederum die gewählte **AnswerOption** speichern.
- **UserAchievement** verbindet User und Achievement mit einer klassischen Viele-zu-Viele-Beziehung.

Diese Struktur sorgt dafür, dass Fragen, Spiele, Auswertungen und Auszeichnungen klar getrennt, aber dennoch verknüpft sind. Dadurch lassen sich neue Features (z. B. zusätzliche Spielmodi oder Auswertungen) gut einbauen, ohne bestehende Klassen umzuschreiben.
