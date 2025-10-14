# CI/CD Sequenzdiagramm

```mermaid
sequenceDiagram
    actor Dev as Entwickler:in
    participant Repo as GitHub Repository
    participant CI as GitHub Actions (CI Workflow)
    participant QA as Prüf-Pipeline
    participant Render as Render Plattform
    participant DB as PostgreSQL Service

    Dev->>Repo: git push (HTTPS)
    Repo-->>CI: Webhook Trigger (HTTPS)

    CI->>CI: Docker Container für Runner starten
    CI->>CI: Arbeitsverzeichnis anlegen
    CI->>CI: Checkout Repository (actions/checkout)
    CI->>CI: ruby/setup-ruby (Bundler Cache + bundle install)
    CI->>DB: PostgreSQL 16 Service starten
    CI->>CI: Warten bis DB bereit ist

    Note over CI: Qualitätssicherung (Schritt 1)
    CI->>QA: bundle exec rubocop (Qualitätssichernde Maßnahme: Stilprüfung)
    CI->>QA: bundle exec brakeman -q (Qualitätssichernde Maßnahme: Sicherheit)
    CI->>QA: bundle exec bundler-audit update && check (Qualitätssichernde Maßnahme: Bibliotheken auf Sicherheitslücken prüfen)

    Note over CI: Testdatenbank vorbereiten
    CI->>CI:  bin/rails db:test:prepare

    Note over QA: Automatisierte Tests
    CI->>QA: bin/rails test:integration
    CI->>QA: bin/rails test (gesamte Suite)

    QA-->>CI: Testergebnisse
    CI-->>Repo: Statusbericht (Commit-Status)
    Repo-->>Dev: Benachrichtigung (E-Mail / GitHub UI)
    CI->>Render: Deploy aktualisiertes Build (nach erfolgreicher CI)
```

- **Kommunikationsprotokolle:** Git-Push über HTTPS, GitHub-Webhooks ebenfalls HTTPS.
- **Qualitätssicherung:** RuboCop (Style), Brakeman (Security), Bundler Audit (Dependencies), sowie automatisierte Rails-Tests (Integration separat, danach gesamte Suite).
  RuboCop checkt ob der code den Stil- und QUalitätsregeln entspricht die vordefiniert wurden.
  Brakeman ist ein Sicherheits-Scanner speziell für Ruby on Rails. Er analysiert typische Schwachstellen wie SQL-Injektion oder ungesicherte Formulare. Und warnt vor diesen gefährlichen Stellen bevor man diese deployed.
  Bundler Audit ist ein Frühwarnsystem für externe Bibliotheken (Gems in Ruby genannt). Es zeigt Sicherheitslücken innerhalb dieser Bibliotheken auf.
- **Beteiligte Rollen/Systeme:** Entwickler:in, GitHub-Repository, GitHub Actions als CI-Plattform, Render als Hosting-Ziel sowie die QA-Schritte innerhalb des Workflows.
- **Infrastruktur:** GitHub Actions startet einen PostgreSQL-16-Service, damit die Tests auf einer frischen Datenbank laufen, und triggert nach erfolgreicher CI das Render-Deployment.
