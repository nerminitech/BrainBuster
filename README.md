# BrainBuster Team 11

BrainBuster ist ein deutschsprachiges Quizspiel, das sowohl im Browser als auch über die Konsole gespielt werden kann. Spieler:innen sammeln Punkte, schalten Achievements frei und treten in Solo- oder Mehrspielermodi gegeneinander an. Tailwind CSS sorgt für das UI, Devise für die Nutzerverwaltung.

## Funktionsumfang

otest

- Benutzerkonten mit Devise (Registrierung, Login, Rollenverwaltung)
- Kategorien- und Fragenverwaltung (inkl. Admin-Backend)
- Quizengine mit Solo- und Gruppen-Duell-Modus, Punktesystem und Geschwindigkeitsbonus
- Match-Code-Overlay mit Copy-Button, damit Gruppen-Duelle schneller starten
- Victory-Screen inklusive Live-Status, sobald alle Teilnehmenden fertig sind
- Globale Rangliste und wöchentliche Highlights
- Achievement-System mit automatischer Vergabe nach jedem Match
- Vollständiger Konsolenmodus (`bin/brain_buster`) inklusive Hilfeoption `-h`
- Seed-Daten mit 3 Kategorien und 15 Fragen
- Klassendiagramm (`docs/class_diagram.md`) als Überblick über die Domäne

## Voraussetzungen

- Ruby 3.2.x (RVM, rbenv oder Systemruby)
- Bundler ≥ 2.4
- PostgreSQL 14 oder neuer

## Installation & Setup

```bash
bundle install --local
bin/rails db:prepare
bin/rails db:seed
```

Beim Seed-Lauf wird automatisch ein Admin-Account erstellt:

- E-Mail: `admin@brainbuster.local`
- Passwort: `Passwort123!`

## Entwicklung starten

```bash
bin/rails server
# oder mit Tailwind-Compiler und Live-Reload
bin/dev
```

Die wichtigsten Routen:

- `/?` – Landing Page für Gäste
- `/dashboard` – persönliches Dashboard nach dem Login
- `/matches` – Übersicht, Match-Erstellung und Gruppen-Duelle
- `/leaderboards` – globale Rangliste
- `/admin/categories`, `/admin/questions` – Verwaltungsoberfläche (nur Admin)

## Konsolenmodus

```bash
bin/brain_buster -h            # Hilfe
bin/brain_buster               # Solo-Quiz
bin/brain_buster -m versus     # Gruppen-Duell erzeugen (Match-Code teilen)
```

Alle Antworten werden interaktiv eingegeben; nach Spielende erscheinen Match- und globale Rangliste automatisch.

## Tests

```bash
bin/rails test
```

Weitere Details:

- Integrations-Szenarien werden in `test/integration/README.md` beschrieben (Adminflüsse, Match-Gameplay, Profilpflege, Pagination).
- Unit- und Service-Tests samt Struktur erklärt `test/unit/README.md` (MatchParticipation, MatchBuilder, Scoring, AchievementAwarder).
- Für neue Tests finden sich kommentierte Beispiele in den jeweiligen Dateien.

## Achievements

| Code                     | Name                | Beschreibung                                                    | Bonus |
| ------------------------ | ------------------- | --------------------------------------------------------------- | ----- |
| `first_steps`            | Erstes Quiz         | Schliesse dein erstes Quiz erfolgreich ab.                      | 50    |
| `quiz_rookie`            | Quiz-Rookie         | Beende fuenf Quizrunden und sammle Erfahrung.                   | 75    |
| `quiz_enthusiast`        | Quiz-Enthusiast     | Spiele zehn abgeschlossene Matches.                             | 100   |
| `quiz_veteran`           | Quiz-Veteran        | Beweise Ausdauer mit 25 abgeschlossenen Matches.                | 150   |
| `quiz_legend`            | Quiz-Legende        | Schliesse 50 Matches ab und werde zur Legende.                  | 200   |
| `point_collector`        | Punktesammler       | Sammle insgesamt 500 Punkte.                                    | 50    |
| `point_hoarder`          | Punktehamster       | Erreiche insgesamt 1.500 Punkte.                                | 75    |
| `point_tycoon`           | Punkte-Tycoon       | Baue ein Punkte-Imperium mit 3.000 Punkten auf.                 | 100   |
| `point_mogul`            | Punkte-Mogul        | Sichere dir 5.000 Gesamtpunkte.                                 | 150   |
| `point_overlord`         | Punkte-Uebermacht   | Sammle beeindruckende 10.000 Gesamtpunkte.                      | 250   |
| `streak_starter`         | Streak-Starter      | Halte eine Tages-Serie von drei Tagen am Stueck.                | 40    |
| `streak_keeper`          | Streak-Keeper       | Bleibe sieben Tage in Folge aktiv.                              | 70    |
| `streak_master`          | Streak-Master       | Halte eine Serie von 14 Tagen.                                  | 120   |
| `streak_unbreakable`     | Unbezwingbar        | Erreiche eine 30-Tage-Serie.                                    | 200   |
| `perfect_run`            | Perfekter Lauf      | Beantworte alle Fragen eines Quiz korrekt.                      | 150   |
| `sharpshooter`           | Prazisionsschuetze  | Schaffe fuenf perfekte Quizdurchgaenge.                         | 200   |
| `flawless_legend`        | Makelose Legende    | Triumphiere in zehn perfekten Matches.                          | 300   |
| `speedster`              | Blitzschnell        | Halte deine durchschnittliche Antwortzeit unter fuenf Sekunden. | 100   |
| `lightning_fast`         | Gewitterhirn        | Erziele eine durchschnittliche Antwortzeit unter 3,5 Sekunden.  | 125   |
| `reaction_master`        | Reaktionsmeister    | Unterbiete eine durchschnittliche Antwortzeit von 2,5 Sekunden. | 160   |
| `duel_champion`          | Duell-Champion      | Gewinne ein Gruppen-Duell gegen andere Spieler.                 | 200   |
| `duel_veteran`           | Duell-Veteran       | Gewinne fuenf Gruppen-Duelle.                                   | 250   |
| `duel_overlord`          | Duell-Overlord      | Setze dich in 15 Gruppen-Duellen durch.                         | 350   |
| `hot_hand`               | Heisse Hand         | Baue eine Fragenserie von fuenf richtigen Antworten auf.        | 60    |
| `unstoppable`            | Unaufhaltsam        | Erreiche eine Serie von zehn richtigen Antworten.               | 120   |
| `blazing_mind`           | Brennender Geist    | Beantworte 15 Fragen hintereinander richtig.                    | 180   |
| `collection_hobbyist`    | Achievement-Sammler | Schalte fuenf Achievements frei.                                | 80    |
| `collection_master`      | Sammlermeister      | Schalte zwoelf Achievements frei.                               | 140   |
| `collection_grandmaster` | Sammler-Grandmaster | Schalte 20 Achievements frei.                                   | 220   |
| `big_game`               | Grosses Spiel       | Erziele 800 Punkte in einem Match.                              | 90    |
| `score_machine`          | Punkte-Maschine     | Schaffe 1.200 Punkte in einem einzigen Match.                   | 140   |
| `titan_score`            | Punkte-Titan        | Erreiche 1.800 Punkte in einer Matchrunde.                      | 220   |

## Dokumentation & Diagrammeee

- Klassendiagramm: `docs/class_diagram.md` (inkl. Erläuterung in `docs/class_diagram_README.md`)
- Aktivitätsdiagramm mit Nutzerfluss: `docs/activity_diagram.md` + `docs/activity_diagram_README.md`
- Pipeline-Notizen: `docs/pipeline_sequence.md`, `docs/pipeline_diagram_README.md`

## Sicherheit & Wartung

- Abhängigkeiten regelmäßig prüfen: `bundle exec bundler-audit check`
- Bei Warnungen (z. B. CVE-2025-61594) die betroffenen Gems aktualisieren und erneut prüfen.

## Weitere Hinweise

- Seeds können beliebig oft ausgeführt werden (idempotent)
- Anpassungen an Tailwind erfolgen in `app/assets/tailwind/application.css`
- Für neue Kategorien/Fragen empfiehlt sich das Admin-Interface oder eigene Seeds
- Test-Dokumentation siehe `test/integration/README.md` sowie `test/unit/README.md`

## Roadmap-Ideen

1. Live-Gruppen-Duelle mit WebSockets
2. Erweiterte Auswertungen (Kategorie-Heatmaps, Serien)
3. API-Anbindung an externe Quiz-Datenbanken (Open Trivia DB)
4. CI/CD-Pipeline (wird gemäß Aufgabenstellung später ergänzt)
