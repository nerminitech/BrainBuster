CI/CD-Ablauf mit GitHub Actions (Rails)
(Ruby ist die Programmiersprache, Rails das Framework also eine Erweiterung für Ruby.)

Kurzüberblick:
Push → Pipeline startet automatisch → Stil- & Sicherheitschecks → Tests → Ergebnis in GitHub.

Schritt-für-Schritt

Änderungen pushen
Du arbeitest lokal und schickst deine Commits mit git push zu GitHub (verschlüsselte HTTPS-Verbindung).

Pipeline startet automatisch
GitHub erkennt den neuen Push und triggert den CI-Workflow (GitHub Actions) – ohne manuelles Anstoßen.

Arbeitskopie auschecken
Die Action checkt den aktuellen Stand des Repos aus, damit exakt der gepushte Code geprüft wird.

Ruby-Umgebung aufsetzen
Der Workflow richtet Ruby ein und installiert Gems. Mit Bundler-Cache geht das flotter.

Qualitätssicherung – Analyse

RuboCop: Stil & Formatierung → konsistenter, lesbarer Code.

Brakeman: Sicherheitsprüfung speziell für Rails.

Bundler Audit: Meldet bekannte CVEs in Abhängigkeiten.

Testdatenbank vorbereiten
Frische Test-DB wird angelegt/migriert, falls Tests DB-Zugriff brauchen.

Automatisierte Tests – Funktionalität
Rails-Tests (Unit & Integration) laufen durch und prüfen die Fachlogik.

Status zurück an GitHub
Die Action meldet Erfolg oder Fehler an Pull Request / Commit-Status.

Benachrichtigung
Ergebnis ist im PR, beim Commit-Status und ggf. per E-Mail/Notification sichtbar.
