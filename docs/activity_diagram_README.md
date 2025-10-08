# Aktivitätsdiagramm – Erläuterung

Das Aktivitätsdiagramm bildet den typischen Ablauf in BrainBuster als Flussdiagramm ab. So lässt sich schnell nachvollziehen, welche Schritte ein*e Spieler*in durchläuft und welche automatischen Aktionen das System übernimmt.

1. **Spieler*in öffnet BrainBuster** – der Einstieg in die Anwendung.
2. **Abgleich, ob eine Anmeldung vorliegt** – nicht eingeloggte Nutzer*innen werden zum Registrieren/Anmelden geleitet.
3. **Dashboard** – Startseite nach dem Login mit Übersicht zu Matches, Punkten und Schnellaktionen.
4. **Neues Match?** – Entscheidung, ob ein neues Match erstellt oder einem bestehenden beigetreten wird.
5. **Match-Einstellungen wählen** – Kategorie, Modus (Solo oder Gruppen-Duell), Anzahl der Fragen, Zeitlimit.
6. **MatchBuilder** – erzeugt die konkreten Fragen (MatchQuestions) und legt die Match-Teilnahmen an.
7. **Match teilen oder solo starten** – im Gruppen-Duell wird der Match-Code verschickt, solo kann sofort losgelegt werden.
8. **Match beitreten** – Teilnehmende betreten den Spielbildschirm.
9. **Fragen beantworten** – Herzstück des Spiels. Währenddessen prüft das System:
   - Ist die Zeit abgelaufen? -> Frage wird als falsch gewertet.
   - War die Antwort korrekt? -> Punkte/Streak aktualisieren.
10. **Nächste Frage** – solange noch Fragen offen sind, wiederholt sich der Prozess.
11. **Match participation abschließen** – sobald alle Fragen beantwortet sind.
12. **Achievements prüfen** – ob durch die Teilnahme neue Erfolge freigeschaltet wurden.
13. **Leaderboard aktualisieren** – sortiert die Teilnehmenden nach Punkten und Reaktionszeit.
14. **Warten oder Victory-Screen** – solange andere noch spielen, wartet die Person; sonst erscheint der Sieg-/Ergebnis-Screen.

Mit diesem Ablaufdiagramm können Teammitglieder oder Stakeholder ohne tiefe technische Kenntnisse den Spielprozess nachvollziehen und leichter Feedback geben.
