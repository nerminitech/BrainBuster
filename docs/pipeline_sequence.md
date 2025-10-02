# CI/CD Sequenzdiagramm

```mermaid
sequenceDiagram
    actor Dev as Entwickler:in
    participant Repo as GitHub Repository
    participant CI as GitHub Actions (CI Workflow)
    participant QA as Prüf-Pipeline

    Dev->>Repo: git push (HTTPS)
    Repo-->>CI: Webhook Trigger (HTTPS)

    CI->>CI: Checkout Repository
    CI->>CI: ruby/setup-ruby (Bundler Cache)

    Note over CI: Qualitätssicherungsschritt 1
    CI->>QA: bundle exec rubocop
    CI->>QA: bundle exec brakeman -q
    CI->>QA: bundle exec bundler-audit update && check

    Note over CI: Testdatenbank vorbereiten
    CI->>CI:  bin/rails db:test:prepare

    Note over QA: Automatisierte Tests
    CI->>QA: bin/rails test (Unit & Integration)

    QA-->>CI: Testergebnisse
    CI-->>Repo: Statusbericht (Commit-Status)
    Repo-->>Dev: Benachrichtigung (E-Mail / GitHub UI)
```

- **Kommunikationsprotokolle:** Git-Push über HTTPS, GitHub-Webhooks ebenfalls HTTPS.
- **Qualitätssicherung:** RuboCop (Style), Brakeman (Security), Bundler Audit (Dependencies), sowie automatisierte Rails-Tests.
  RuboCop checkt ob der code den Stil- und QUalitätsregeln entspricht die vordefiniert wurden.
  Brakeman ist ein Sicherheits-Scanner speziell für Ruby on Rails. Er analysiert typische Schwachstellen wie SQL-Injektion oder ungesicherte Formulare. Und warnt vor diesen gefährlichen Stellen bevor man diese deployed.
  Bundler Audit ist ein Frühwarnsystem für externe Bibliotheken (Gems in Ruby genannt). Es zeigt Sicherheitslücken innerhalb dieser Bibliotheken auf.
- **Beteiligte Rollen/Systeme:** Entwickler:in, GitHub-Repository, GitHub Actions als CI-Plattform und die QA-Schritte innerhalb des Workflows.
