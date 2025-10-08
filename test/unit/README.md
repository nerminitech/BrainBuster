# Unit-Tests – Überblick

Die Unit-Tests konzentrieren sich auf kleine, klar umrissene Bausteine der Anwendung. Ziel ist es, Geschäftslogik ohne Umweg über Controller oder Views abzusichern.

## Wichtige Testgruppen

- **Model-Tests (`test/models`)**
  - Aktuell zeigt *match_participation_test.rb* detailliert, wie `MatchParticipation` Fragen startet, Versuche registriert und Teilnahmen abschließt.
  - Weitere Model-Dateien enthalten Platzhalter und können als Ausgangspunkt für neue Tests dienen.

- **Service-Tests (`test/services`)**
  - *quiz_engine_match_builder_test.rb*: Überprüft, dass der MatchBuilder die gewünschte Anzahl Fragen zusammenstellt und bei Ressourcenmangel sauber scheitert.
  - *quiz_engine_scoring_test.rb*: Verifiziert die Punkteberechnung für richtige/schnelle Antworten sowie den Nullpunkt für falsche Versuche.
  - *quiz_engine_achievement_awarder_test.rb*: Prüft die Vergabe von Achievements bei herausragenden Partien und den stufenweisen Perfect-Run-Bonus.

## Struktur der Tests

1. **Setup-Blöcke** bereiten minimal notwendige Testdaten vor (Users, Kategorien, Fragen etc.).
2. **Methodenaufrufe** testen isoliert die Kernlogik (z. B. `register_attempt!`, `MatchBuilder.call`).
3. **Assertions** prüfen Rückgabewerte, Statusänderungen und Nebenwirkungen auf Datenbankfelder.
4. **Ausführliche Kommentare** in den Testdateien erklären Schritt für Schritt, was geprüft wird.

## Ausführung

```
bundle exec rails test test/models test/services
```

Die Unit-Tests laufen schnell und eignen sich gut, um neue Business-Regeln oder Refactorings abzusichern.
