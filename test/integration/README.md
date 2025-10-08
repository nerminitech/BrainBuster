# Integration-Tests – Überblick

Diese Sammlung beschreibt, wie sich komplette Anwendungsflüsse in BrainBuster verhalten. Jeder Test spannt mehrere Ebenen – Controller, Views, Datenbank – auf, um echte Nutzeraktionen abzubilden.

## Enthaltene Szenarien

- **admin_question_management_test.rb**
  - Prüft, dass ein*e Administrator*in neue Fragen inklusive Antwortoptionen zu einer Kategorie hinzufügen kann.
  - Validiert zusätzlich, dass fehlerhafte Eingaben sauber abgefangen und als *Unprocessable Entity* (HTTP 422) zurückgegeben werden.

- **match_gameplay_flow_test.rb**
  - Simuliert das Starten eines Matches, das Beantworten einer Frage und den anschließenden Abschluss inklusive Erfolgsmeldung.
  - Stellt sicher, dass der Spielstand der Teilnahme korrekt aktualisiert wird.

- **matches_pagination_test.rb**
  - Deckt die Pagy-Navigation ab: mehrere abgeschlossene Matches erscheinen seitenweise, die Navigationslinks reagieren auf Seitenwechsel.

- **profile_management_test.rb**
  - Überprüft Sicht- und Bearbeitbarkeit des eigenen Profils: Anzeigenamen/Bio ändern, Redirects und Persistenz testen.

## Wie die Tests aufgebaut sind

1. **Anlegen der Testdaten** – In `setup` werden alle benötigten Objekte erzeugt (User, Kategorien, Matches …), damit jeder Test isoliert laufen kann.
2. **Simulieren echter Requests** – Mit `get`, `post`, `patch` usw. werden die gleichen Routen wie im Browser aufgerufen.
3. **Auswerten der Antworten** – Assertions prüfen HTTP-Status, gerenderte Inhalte und Datenbankzustände.
4. **Kommentare im Code** – Innerhalb der Tests beschreiben ausführliche Kommentare jeden Schritt, damit auch Neueinsteiger*innen den Ablauf leicht nachvollziehen können.

## Ausführung

```
bundle exec rails test test/integration
```

Die Tests benötigen eine saubere Datenbank. Im Zweifel vorher `rails db:test:prepare` ausführen.
