# BrainBuster soos

BrainBuster ist ein deutschsprachiges Quizspiel, das sowohl im Browser als auch über die Konsole gespielt werden kann. Spieler:innen sammeln Punkte, schalten Achievements frei und treten in Solo- oder Mehrspielermodi gegeneinander an. Tailwind CSS sorgt für das UI, Devise für die Nutzerverwaltung.

## Funktionsumfang

- Benutzerkonten mit Devise (Registrierung, Login, Rollenverwaltung)
- Kategorien- und Fragenverwaltung (inkl. Admin-Backend)
- Quizengine mit Solo- und Duellmodus, Punktesystem und Geschwindigkeitsbonus
- Globale Rangliste und wöchentliche Highlights
- Achievement-System mit automatischer Vergabe nach jedem Match
- Vollständiger Konsolenmodus (`bin/brain_buster`) inklusive Hilfeoption `-h`
- Seed-Daten mit 3 Kategorien und 15 Fragen
- Klassendiagramm (`docs/class_diagram.md`) als Überblick über die Domäne

## Voraussetzungen

- Ruby 3.2.x (RVM, rbenv oder Systemruby)
- Bundler ≥ 2.4
- SQLite (Standard) oder eine alternative Datenbank

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
- `/matches` – Übersicht, Match-Erstellung und Duelle
- `/leaderboards` – globale Rangliste
- `/admin/categories`, `/admin/questions` – Verwaltungsoberfläche (nur Admin)

## Konsolenmodus

```bash
bin/brain_buster -h            # Hilfe
bin/brain_buster               # Solo-Quiz
bin/brain_buster -m versus     # Duell erzeugen (Match-Code teilen)
```

Alle Antworten werden interaktiv eingegeben; nach Spielende erscheinen Match- und globale Rangliste automatisch.

## Tests

```bash
bin/rails test
```

Aktuell enthalten:

- Servicetests für Matchbuilder und Scoring
- Modeltests für MatchParticipation

## Achievements

| Code             | Beschreibung                                    | Bonus |
| ---------------- | ----------------------------------------------- | ----- |
| `first_steps`    | Erstes fertiges Quiz                            | 50    |
| `perfect_run`    | Alle Fragen korrekt                             | 150   |
| `speedster`      | Durchschnittliche Antwortzeit < 5 Sekunden      | 100   |
| `duel_champion`  | Duell mit höchster Punktzahl abschließen        | 200   |

## Weitere Hinweise

- Klassendiagramm: `docs/class_diagram.md`
- Seeds können beliebig oft ausgeführt werden (idempotent)
- Anpassungen an Tailwind erfolgen in `app/assets/tailwind/application.css`
- Für neue Kategorien/Fragen empfiehlt sich das Admin-Interface oder eigene Seeds

## Roadmap-Ideen

1. Live-Duelle mit WebSockets
2. Erweiterte Auswertungen (Kategorie-Heatmaps, Serien)
3. API-Anbindung an externe Quiz-Datenbanken (Open Trivia DB)
4. CI/CD-Pipeline (wird gemäß Aufgabenstellung später ergänzt)
