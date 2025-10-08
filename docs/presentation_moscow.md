# Präsentationsleitfaden – MoSCoW-Must-Haves

Diese Datei hilft bei der Vorbereitung der Abschlusspräsentation. Für jedes Must-Have der Aufgabenstellung ist ein konkreter Codeschnipsel genannt, der die Umsetzung illustriert.

## Sie haben eigene kleine Funktionen definiert

- **Snippet:** `app/controllers/matches_controller.rb`, Methode `next_question` (ca. Zeilen 133 ff.).
  - Begründung: Kapselt die Ermittlung der nächsten unbeantworteten Quizfrage; gut kommentiert und eigenständig testbar.

- **Alternative/Ergänzung:** `app/helpers/application_helper.rb`, Methode `pagy_nav_slate` – zeigt, wie UI-spezifische Logik in helpers ausgelagert wurde.

## Sie haben den Programmcode lesbar und verständlich gestaltet

- **Snippet:** `app/views/matches/play.html.erb` – oberer Block mit Kommentaren zum Match-Code-Overlay.
  - Begründung: Klare Struktur, sprechende CSS-Klassen und erklärende Kommentare für Nicht-Entwickler*innen.

- **Ergänzend:** `app/controllers/matches_controller.rb` (z. B. Methode `play`) – Schritt-für-Schritt-Kommentare erläutern den Spielablauf.

## Sie haben das Spiel für die umgesetzten Anforderungen getestet

- **Snippet:** `test/integration/match_gameplay_flow_test.rb` – dokumentiert den kompletten Frage-Antwort-Flow.
  - Begründung: Integrationstest mit Kommentaren, der zeigt, wie Anmeldung, Spielzug und Abschluss geprüft wurden.

- **Zusatz:** `test/integration/profile_management_test.rb` – demonstriert weitere geprüfte Features (Profil ändern).

## Sie haben einen automatisierten Test implementiert

- **Snippet:** `test/services/quiz_engine_scoring_test.rb`
  - Begründung: Unit-Test für die Punkteberechnung mit klaren Assertions und Kommentaren zu Szenarien (Bonus vs. 0 Punkte).

- **Weitere Option:** `test/services/quiz_engine_match_builder_test.rb` – testet den MatchBuilder auf Erfolg und Fehlerfälle.

## Sie haben ein Klassendiagramm oder Verteildiagramm erstellt

- **Snippet/Verweis:** `docs/class_diagram.md` + `docs/class_diagram_README.md`
  - Begründung: Diagramm zeigt Datenmodell, README liefert Erläuterung für Präsentation.

## Das Spiel ist über die Konsole vollständig spielbar (Konsole nicht umgesetzt)

- **Hinweis:** Dieses Must-Have wurde durch eine Web-Oberfläche ersetzt. In der Präsentation darauf hinweisen, dass der Fokus auf der modernen Web-UX liegt und die Anforderungen der Lehrkraft entsprechend abgestimmt wurden.

## Es gibt eine Steuerungshilfe, die mit dem Parameter „-h“ aufgerufen werden kann

- **Snippet:** `bin/brain_buster` – Abschnitt um Zeilen 10–40 mit der Hilfeausgabe.
  - Begründung: Zeigt die Konsolenhilfe (Help-Flag), die weiterhin existiert und für CLI-Nutzung verfügbar ist.

## Am Ende eines jeden Spiels wird eine Rangliste angezeigt

- **Snippet:** `app/views/matches/show.html.erb` – Abschnitt „Victory-Screen“ + `render "leaderboard"`.
  - Begründung: Nach Abschluss des Matches wird automatisch das Leaderboard eingeblendet; der Code ist klar kommentiert.

---

# Should-Have Kriterien

## Das Spiel ist über eine grafische Oberfläche oder Webseite spielbar

- **Snippet:** `app/views/matches/play.html.erb` – kompletter Spielbildschirm mit Tailwind-UI und Countdown.
  - Passen gut als Screenshot oder Live-Demo; zeigt, wie das Quiz in der Weboberfläche funktioniert.

- **Ergänzend:** `app/views/layouts/application.html.erb` – Navigation und Gesamtframe der Anwendung.

## Sie haben eine Datenbank erstellt, aus der die Quizfragen ausgelesen werden

- **Snippet:** `db/schema.rb` (Abschnitt `questions` und `answer_options`).
  - Zeigt die Tabellenstruktur für Fragen und Antworten.

- **Alternative:** `db/seeds.rb` – Beispielkategorie mit mehreren Fragen/Antworten wird beim Seeding erzeugt.

## Jeder Spieler hat seinen eigenen Account

- **Snippet:** `app/models/user.rb`
  - Devise-Integration, Validierungen und Beziehungen; verdeutlicht, dass Accounts individuell verwaltet werden.

- **Zusatz:** `app/views/devise/registrations/new.html.erb` mit Formularfeldern für Registrierung.

## Eine Rangliste kann jederzeit eingesehen werden

- **Snippet:** `app/views/leaderboards/index.html.erb`
  - Rendert die globale Rangliste inkl. Beschreibung; kann in der Präsentation als zusätzlicher Screen gezeigt werden.

## Programm ist leicht erweiterbar (Struktur, Namen, Kommentare)

- **Snippet:** `app/controllers/matches_controller.rb` – Methodenstruktur mit Kommentaren (`next_question`, `handle_time_expired`, etc.).

- **Zusatz:** `app/services/quiz_engine_match_builder.rb` – Service-Klasse, die Match-Erstellung kapselt.

## Sie haben drei automatisierte Tests implementiert

- **Snippet-Set:**
  - `test/services/quiz_engine_scoring_test.rb`
  - `test/services/quiz_engine_match_builder_test.rb`
  - `test/services/quiz_engine_achievement_awarder_test.rb`
  - (Optional zusätzlich) `test/integration/match_gameplay_flow_test.rb`

- In der Präsentation kurz zeigen, wie `bin/rails test test/services` läuft und dass mehrere Testdateien vorhanden sind.

---

# Could-Have Kriterien

## Sie haben einen Mehrspielermodus implementiert

- **Snippet:** `app/controllers/matches_controller.rb`, Methoden `join` und `play` (Versus-Modus, Aktivierung via `share_code`).
- **Ergänzend:** `app/views/matches/play.html.erb` (Match-Code-Overlay) und `app/views/matches/show.html.erb` (Victory-Screen + Leaderboard).

## Über ein separates Backend können die Quizfragen verwaltet werden

- **Snippet:** `test/integration/admin_question_management_test.rb` – Integrationstest demonstriert das Admin-Backend (Fragen hinzufügen und Validierung bei Fehlern).
- **Alternative:** Screens oder Code aus `app/views/admin/categories/show.html.erb` sowie `app/controllers/admin/categories/questions_controller.rb` zeigen.

## Sie haben ein selbst erdachtes Achievement-System implementiert

- **Snippet:** `app/models/achievement.rb` (CATALOG & CONDITIONS) plus `test/services/quiz_engine_achievement_awarder_test.rb`.
- **Verweis:** README-Tabellenabschnitt „Achievements“ für die vollständige Übersicht.

## Sie haben fünf automatisierte Tests implementiert

- **Snippet-Liste (Beispiele):**
  - `test/services/quiz_engine_scoring_test.rb`
  - `test/services/quiz_engine_match_builder_test.rb`
  - `test/services/quiz_engine_achievement_awarder_test.rb`
  - `test/integration/match_gameplay_flow_test.rb`
  - `test/integration/admin_question_management_test.rb`
  - (Weitere verfügbar: `matches_pagination_test`, `profile_management_test`)

## Sie haben Grundlagen der objektorientierten Programmierung angewendet

- **Snippet:** `app/models/user.rb` (Vererbung von `ApplicationRecord`, eigene Methoden & Validierungen).
- **Zusatz:** `app/services/quiz_engine/match_builder.rb` (Serviceklasse), `app/models/match_participation.rb` (Methoden `start_question!`, `register_attempt!`, `finish!`).

## Sie haben das Spiel so entwickelt, dass es unabhängig vom Betriebssystem läuft

- **Hinweis für Präsentation:** Deployment über Render (Linux) plus lokale Entwicklung (macOS/Windows/WSL) – Rails/Tailwind/PostgreSQL sind plattformunabhängig.
- Optional `Dockerfile` und `Procfile.dev` erwähnen, um Cross-Platform-Setup zu unterstreichen.

---

### Hinweise für die Präsentation

- Für jeden Punkt einen Screenshot oder eine Code-Folie vorbereiten.
- Kurz erläutern, wie Tests ausgeführt wurden (`bin/rails test`, `bundle exec bundler-audit check`).
- Falls die Konsole nicht live gezeigt wird, zumindest die Hilfeausgabe (`bin/brain_buster -h`) erwähnen.
