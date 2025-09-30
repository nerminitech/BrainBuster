# frozen_string_literal: true

puts "==> Initialisiere BrainBuster-Datenbank"

admin = User.find_or_initialize_by(email: "admin@brainbuster.local")
if admin.new_record?
  admin.username = "admin"
  admin.display_name = "Administrator"
  admin.role = :admin
  admin.password = "Passwort123!"
  admin.password_confirmation = "Passwort123!"
  admin.total_points = 0
  admin.save!
  puts "   ✔ Admin-Konto erstellt (admin@brainbuster.local / Passwort123!)"
else
  puts "   ✔ Admin-Konto vorhanden"
end

achievements = [
  { code: "first_steps", name: "Erstes Quiz", description: "Schließe dein erstes Quiz erfolgreich ab.", points_bonus: 50 },
  { code: "perfect_run", name: "Perfekter Lauf", description: "Beantworte alle Fragen eines Quiz korrekt.", points_bonus: 150 },
  { code: "speedster", name: "Blitzschnell", description: "Halte deine durchschnittliche Antwortzeit unter 5 Sekunden.", points_bonus: 100 },
  { code: "duel_champion", name: "Duell-Champion", description: "Gewinne ein Duell gegen andere Spieler.", points_bonus: 200 }
]

achievements.each do |attrs|
  achievement = Achievement.find_or_initialize_by(code: attrs[:code])
  achievement.update!(attrs)
end
puts "   ✔ Achievements synchronisiert"

categories_payload = [
  {
    name: "Allgemeinwissen",
    description: "Querbeet durch die Welt des Wissens von Geografie bis Kultur.",
    featured: true,
    questions: [
      {
        content: "Welcher Planet ist bekannt als der Rote Planet?",
        explanation: "Durch seinen hohen Eisenoxid-Anteil wirkt der Mars rötlich.",
        difficulty: "leicht",
        time_limit_seconds: 25,
        base_points: 80,
        answers: [
          { text: "Mars", correct: true },
          { text: "Venus", correct: false },
          { text: "Jupiter", correct: false },
          { text: "Saturn", correct: false }
        ]
      },
      {
        content: "Wie viele Bundesländer hat Deutschland?",
        explanation: "Seit der Wiedervereinigung 1990 besteht Deutschland aus 16 Bundesländern.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "14", correct: false },
          { text: "15", correct: false },
          { text: "16", correct: true },
          { text: "17", correct: false }
        ]
      },
      {
        content: "Welcher ist der längste Fluss Europas?",
        explanation: "Die Wolga ist mit über 3.500 km der längste Fluss Europas.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 120,
        answers: [
          { text: "Donau", correct: false },
          { text: "Wolga", correct: true },
          { text: "Rhein", correct: false },
          { text: "Ural", correct: false }
        ]
      },
      {
        content: "Wie viele Kontinente werden allgemein anerkannt?",
        explanation: "In Europa wird meist mit sieben Kontinenten gearbeitet.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Fünf", correct: false },
          { text: "Sechs", correct: false },
          { text: "Sieben", correct: true },
          { text: "Acht", correct: false }
        ]
      },
      {
        content: "Welches Element hat das chemische Symbol Au?",
        explanation: "Au steht für Aurum, lateinisch für Gold.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Silber", correct: false },
          { text: "Aluminium", correct: false },
          { text: "Gold", correct: true },
          { text: "Argon", correct: false }
        ]
      },
      {
        content: "Welches ist das kleinste anerkannte Land der Welt?",
        explanation: "Der Vatikanstaat misst weniger als einen Quadratkilometer und ist damit das kleinste Land.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 115,
        answers: [
          { text: "Monaco", correct: false },
          { text: "Vatikanstaat", correct: true },
          { text: "Liechtenstein", correct: false },
          { text: "San Marino", correct: false }
        ]
      },
      {
        content: "Wer verfasste das Drama 'Faust'?",
        explanation: "Johann Wolfgang von Goethe veröffentlichte das Werk in zwei Teilen.",
        difficulty: "mittel",
        time_limit_seconds: 20,
        base_points: 105,
        answers: [
          { text: "Friedrich Schiller", correct: false },
          { text: "Gotthold Ephraim Lessing", correct: false },
          { text: "Johann Wolfgang von Goethe", correct: true },
          { text: "Theodor Fontane", correct: false }
        ]
      },
      {
        content: "Wie viele Planeten zählt unser Sonnensystem seit 2006 offiziell?",
        explanation: "Nach der Degradierung Plutos zu einem Zwergplaneten verbleiben acht Planeten.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "8", correct: true },
          { text: "9", correct: false },
          { text: "7", correct: false },
          { text: "10", correct: false }
        ]
      },
      {
        content: "In welcher Stadt befindet sich die berühmte Sagrada Família?",
        explanation: "Die Basilika des Architekten Antoni Gaudí steht in Barcelona.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 95,
        answers: [
          { text: "Madrid", correct: false },
          { text: "Barcelona", correct: true },
          { text: "Sevilla", correct: false },
          { text: "Valencia", correct: false }
        ]
      },
      {
        content: "Welche Farben hat die Flagge Deutschlands?",
        explanation: "Die Bundesflagge besteht aus drei waagerechten Streifen in Schwarz-Rot-Gold.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "Schwarz-Rot-Gold", correct: true },
          { text: "Schwarz-Gelb-Weiß", correct: false },
          { text: "Blau-Weiß-Rot", correct: false },
          { text: "Rot-Weiß-Grün", correct: false }
        ]
      },
      {
        content: "Wer ist laut griechischer Mythologie der Göttervater?",
        explanation: "Zeus herrschte vom Olymp aus über Götter und Menschen.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Poseidon", correct: false },
          { text: "Hades", correct: false },
          { text: "Zeus", correct: true },
          { text: "Ares", correct: false }
        ]
      },
      {
        content: "Welche Stadt gilt als Hauptstadt der Schweiz?",
        explanation: "Bern ist Bundesstadt und Sitz von Parlament und Regierung.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "Zürich", correct: false },
          { text: "Genf", correct: false },
          { text: "Bern", correct: true },
          { text: "Basel", correct: false }
        ]
      }
    ]
  },
  {
    name: "Technologie",
    description: "Aktuelle Trends aus IT, Wissenschaft und Zukunftstechnologien.",
    featured: true,
    questions: [
      {
        content: "Welches Unternehmen entwickelte das Betriebssystem Linux?",
        explanation: "Linux wurde 1991 von Linus Torvalds entwickelt und später von einer Community weitergeführt.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 130,
        answers: [
          { text: "IBM", correct: false },
          { text: "Linus Torvalds", correct: true },
          { text: "Microsoft", correct: false },
          { text: "Sun Microsystems", correct: false }
        ]
      },
      {
        content: "Was beschreibt das Mooresche Gesetz?",
        explanation: "Gordon Moore beobachtete, dass sich die Anzahl der Transistoren auf integrierten Schaltkreisen etwa alle zwei Jahre verdoppelt.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Rechenleistung halbiert sich jährlich", correct: false },
          { text: "Speicherpreise verdoppeln sich alle zwei Jahre", correct: false },
          { text: "Transistorzahl verdoppelt sich etwa alle zwei Jahre", correct: true },
          { text: "Batteriekapazität verdreifacht sich alle fünf Jahre", correct: false }
        ]
      },
      {
        content: "Welches Protokoll bildet das Fundament des Webs?",
        explanation: "HTTP ist das Protokoll, über das Web-Inhalte übertragen werden.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 100,
        answers: [
          { text: "SMTP", correct: false },
          { text: "FTP", correct: false },
          { text: "HTTP", correct: true },
          { text: "SSH", correct: false }
        ]
      },
      {
        content: "Welche Programmiersprache bildet die Grundlage für die JVM?",
        explanation: "Die Java Virtual Machine führt Bytecode aus, der meist aus Java stammt.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Java", correct: true },
          { text: "C", correct: false },
          { text: "Ruby", correct: false },
          { text: "Rust", correct: false }
        ]
      },
      {
        content: "Was versteht man unter Quantencomputing?",
        explanation: "Quantencomputer nutzen Qubits und Quantenmechanik, um bestimmte Probleme schneller zu lösen.",
        difficulty: "experte",
        time_limit_seconds: 40,
        base_points: 180,
        answers: [
          { text: "Einen besonders energieeffizienten Supercomputer", correct: false },
          { text: "Computer, die mit künstlicher Intelligenz programmiert werden", correct: false },
          { text: "Rechner, die Quantenphänomene zur Informationsverarbeitung nutzen", correct: true },
          { text: "Einen Algorithmus zur Verschlüsselung", correct: false }
        ]
      },
      {
        content: "Welches Unternehmen entwickelte den ersten kommerziell erfolgreichen Mikroprozessor 4004?",
        explanation: "Der Intel 4004 war 1971 der erste kommerzielle Mikroprozessor.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 160,
        answers: [
          { text: "AMD", correct: false },
          { text: "Motorola", correct: false },
          { text: "Intel", correct: true },
          { text: "Texas Instruments", correct: false }
        ]
      },
      {
        content: "Wofür steht das Kürzel 'HTML'?",
        explanation: "HyperText Markup Language ist die Auszeichnungssprache für Webseiten.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "HyperText Markup Language", correct: true },
          { text: "High Transfer Mail Language", correct: false },
          { text: "Hybrid Text Machine Logic", correct: false },
          { text: "Hyperlink Transfer Matrix", correct: false }
        ]
      },
      {
        content: "Was beschreibt der Begriff 'Blockchain'?",
        explanation: "Eine Blockchain ist eine dezentral gespeicherte, verkettete Liste von Datensätzen.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 130,
        answers: [
          { text: "Ein zentrales Datenbanksystem großer Unternehmen", correct: false },
          { text: "Eine verkettete, verteilte Datenstruktur", correct: true },
          { text: "Einen speziellen Grafikchip", correct: false },
          { text: "Ein neues Betriebssystem", correct: false }
        ]
      },
      {
        content: "Welches Protokoll sichert den verschlüsselten Datenaustausch im Web?",
        explanation: "HTTPS kombiniert HTTP mit Transport Layer Security (TLS).",
        difficulty: "leicht",
        time_limit_seconds: 25,
        base_points: 95,
        answers: [
          { text: "FTP", correct: false },
          { text: "SSH", correct: false },
          { text: "HTTPS", correct: true },
          { text: "SMTP", correct: false }
        ]
      },
      {
        content: "Was ist ein neuronales Netz?",
        explanation: "Neuronale Netze sind Modelle des maschinellen Lernens, die aus verbundenen Knoten bestehen.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 135,
        answers: [
          { text: "Ein physisches Computernetzwerk", correct: false },
          { text: "Ein Modell des maschinellen Lernens", correct: true },
          { text: "Eine neue CPU-Baureihe", correct: false },
          { text: "Ein Internetprotokoll", correct: false }
        ]
      },
      {
        content: "Welche Programmiersprache ist für den Raspberry Pi besonders beliebt im Bildungsbereich?",
        explanation: "Python wird aufgrund seiner Einfachheit häufig auf dem Raspberry Pi eingesetzt.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Python", correct: true },
          { text: "Swift", correct: false },
          { text: "Kotlin", correct: false },
          { text: "Perl", correct: false }
        ]
      },
      {
        content: "Welches Gerät nutzte Alan Turing zur Entschlüsselung der Enigma?",
        explanation: "Die von Alan Turing maßgeblich entworfene 'Bombe' knackte deutsche Enigma-Funksprüche.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Z3", correct: false },
          { text: "Colossus", correct: false },
          { text: "Bombe", correct: true },
          { text: "Harvard Mark I", correct: false }
        ]
      }
    ]
  },
  {
    name: "Geschichte",
    description: "Historische Ereignisse, Personen und Wendepunkte der Weltgeschichte.",
    featured: false,
    questions: [
      {
        content: "In welchem Jahr fiel die Berliner Mauer?",
        explanation: "Der Mauerfall fand im November 1989 statt und leitete das Ende der DDR ein.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "1987", correct: false },
          { text: "1988", correct: false },
          { text: "1989", correct: true },
          { text: "1990", correct: false }
        ]
      },
      {
        content: "Wer war der erste Bundeskanzler der Bundesrepublik Deutschland?",
        explanation: "Konrad Adenauer war von 1949 bis 1963 Bundeskanzler.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Willy Brandt", correct: false },
          { text: "Konrad Adenauer", correct: true },
          { text: "Helmut Schmidt", correct: false },
          { text: "Ludwig Erhard", correct: false }
        ]
      },
      {
        content: "Welche Stadt war die Hauptstadt des Römischen Reichs zur Zeit des Kaisers Augustus?",
        explanation: "Rom war das Zentrum des Reiches und Regierungssitz des Augustus.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 120,
        answers: [
          { text: "Mailand", correct: false },
          { text: "Byzanz", correct: false },
          { text: "Rom", correct: true },
          { text: "Alexandria", correct: false }
        ]
      },
      {
        content: "Welche Revolution begann 1789?",
        explanation: "Mit dem Sturm auf die Bastille begann die Französische Revolution.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Die Industrielle Revolution", correct: false },
          { text: "Die Französische Revolution", correct: true },
          { text: "Die Russische Revolution", correct: false },
          { text: "Die Amerikanische Revolution", correct: false }
        ]
      },
      {
        content: "Welcher Vertrag beendete den Ersten Weltkrieg?",
        explanation: "Der Versailler Vertrag wurde 1919 unterzeichnet.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Vertrag von Tordesillas", correct: false },
          { text: "Vertrag von Wien", correct: false },
          { text: "Vertrag von Versailles", correct: true },
          { text: "Vertrag von Utrecht", correct: false }
        ]
      },
      {
        content: "Welcher Herrscher ließ die Große Mauer in China ausbauen?",
        explanation: "Der erste Kaiser Qin Shi Huangdi verstärkte und verband bestehende Wallanlagen.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 130,
        answers: [
          { text: "Kublai Khan", correct: false },
          { text: "Qin Shi Huangdi", correct: true },
          { text: "Sun Yat-sen", correct: false },
          { text: "Mao Zedong", correct: false }
        ]
      },
      {
        content: "Welche Revolution leitete den Übergang zur industriellen Gesellschaft in Großbritannien ein?",
        explanation: "Die Industrielle Revolution begann Mitte des 18. Jahrhunderts in England.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Glorious Revolution", correct: false },
          { text: "Industrielle Revolution", correct: true },
          { text: "Französische Revolution", correct: false },
          { text: "Chartistenbewegung", correct: false }
        ]
      },
      {
        content: "Wie hieß das Bündnis der griechischen Stadtstaaten gegen Persien im 5. Jahrhundert v. Chr.?",
        explanation: "Der Delisch-Attische Seebund war ein Verteidigungsbündnis unter Führung Athens.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Peloponnesischer Bund", correct: false },
          { text: "Delisch-Attischer Seebund", correct: true },
          { text: "Achaiischer Bund", correct: false },
          { text: "Korinthischer Bund", correct: false }
        ]
      },
      {
        content: "Welches Jahr markiert den Beginn der Weimarer Republik?",
        explanation: "Nach der Abdankung Kaiser Wilhelms II. wurde am 9. November 1918 die Republik ausgerufen.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 95,
        answers: [
          { text: "1914", correct: false },
          { text: "1918", correct: true },
          { text: "1919", correct: false },
          { text: "1923", correct: false }
        ]
      },
      {
        content: "Wer war die erste Frau, die als Bundeskanzlerin der Bundesrepublik Deutschland amtierte?",
        explanation: "Angela Merkel übernahm 2005 das Amt und blieb bis 2021 Regierungschefin.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Angela Merkel", correct: true },
          { text: "Ursula von der Leyen", correct: false },
          { text: "Hannelore Kraft", correct: false },
          { text: "Annegret Kramp-Karrenbauer", correct: false }
        ]
      }
    ]
  },
  {
    name: "Sport",
    description: "Rekorde, Regeln und historische Ereignisse aus der Sportwelt.",
    featured: false,
    questions: [
      {
        content: "Wie viele Spieler stehen beim Fußball pro Team gleichzeitig auf dem Feld?",
        explanation: "Elf Spieler pro Mannschaft gehören zur Standardaufstellung im Fußball.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "9", correct: false },
          { text: "10", correct: false },
          { text: "11", correct: true },
          { text: "12", correct: false }
        ]
      },
      {
        content: "Welche Stadt richtete die Olympischen Sommerspiele 1972 aus?",
        explanation: "Die Spiele von 1972 fanden in München statt.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Berlin", correct: false },
          { text: "München", correct: true },
          { text: "Hamburg", correct: false },
          { text: "Köln", correct: false }
        ]
      },
      {
        content: "Wie viele Grand-Slam-Turniere gibt es im Tennis pro Jahr?",
        explanation: "Australian Open, French Open, Wimbledon und US Open sind die vier Turniere.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "3", correct: false },
          { text: "4", correct: true },
          { text: "5", correct: false },
          { text: "6", correct: false }
        ]
      },
      {
        content: "Wer hält (Stand 2024) den Rekord für die meisten Weltmeistertitel in der Formel 1?",
        explanation: "Lewis Hamilton teilt sich den Rekord von sieben WM-Titeln mit Michael Schumacher.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Ayrton Senna", correct: false },
          { text: "Sebastian Vettel", correct: false },
          { text: "Lewis Hamilton", correct: true },
          { text: "Niki Lauda", correct: false }
        ]
      },
      {
        content: "Wie viele Punkte gibt ein Korb aus dem Drei-Punkte-Bereich im Basketball?",
        explanation: "Ein Wurf hinter der Drei-Punkte-Linie zählt drei Punkte.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "2", correct: false },
          { text: "3", correct: true },
          { text: "4", correct: false },
          { text: "1", correct: false }
        ]
      },
      {
        content: "Wie viele Etappen hat die Tour de France in der Regel?",
        explanation: "Die Tour umfasst gewöhnlich 21 Etappen, inklusive einzelner Zeitfahren.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 130,
        answers: [
          { text: "15", correct: false },
          { text: "18", correct: false },
          { text: "21", correct: true },
          { text: "25", correct: false }
        ]
      },
      {
        content: "Welches Land gewann die erste Fußball-WM 1930?",
        explanation: "Uruguay setzte sich im Finale gegen Argentinien durch.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Deutschland", correct: false },
          { text: "Uruguay", correct: true },
          { text: "Brasilien", correct: false },
          { text: "Italien", correct: false }
        ]
      },
      {
        content: "Wie lang ist ein olympisches Schwimmbecken?",
        explanation: "Ein olympisches Becken misst 50 Meter pro Bahn.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "25 Meter", correct: false },
          { text: "33 Meter", correct: false },
          { text: "50 Meter", correct: true },
          { text: "100 Meter", correct: false }
        ]
      },
      {
        content: "Welche Disziplin gehört nicht zum modernen Fünfkampf?",
        explanation: "Der moderne Fünfkampf umfasst Fechten, Schwimmen, Reiten, Schießen und Laufen.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 155,
        answers: [
          { text: "Reiten", correct: false },
          { text: "Fechten", correct: false },
          { text: "Schießen", correct: false },
          { text: "Turnen", correct: true }
        ]
      },
      {
        content: "Welches Grand-Slam-Tennisturnier wird auf Sand ausgetragen?",
        explanation: "Die French Open finden jährlich auf Sandplätzen in Paris statt.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Australian Open", correct: false },
          { text: "French Open", correct: true },
          { text: "Wimbledon", correct: false },
          { text: "US Open", correct: false }
        ]
      }
    ]
  },
  {
    name: "Film & Serien",
    description: "Kultfilme, Serienklassiker und ihre Macher:innen.",
    featured: true,
    questions: [
      {
        content: "Wer führte Regie bei 'Der Herr der Ringe'?",
        explanation: "Peter Jackson verantwortete alle drei Teile der Filmtrilogie.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Peter Jackson", correct: true },
          { text: "Steven Spielberg", correct: false },
          { text: "James Cameron", correct: false },
          { text: "Ridley Scott", correct: false }
        ]
      },
      {
        content: "In welcher Stadt spielt die Serie 'Babylon Berlin' überwiegend?",
        explanation: "Die Serie spielt in Berlin während der späten Weimarer Republik.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Hamburg", correct: false },
          { text: "Berlin", correct: true },
          { text: "Leipzig", correct: false },
          { text: "München", correct: false }
        ]
      },
      {
        content: "Wie heißt die fiktive Schule aus der Harry-Potter-Reihe?",
        explanation: "Hogwarts Schule für Hexerei und Zauberei ist das zentrale Setting.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "Hogwarts", correct: true },
          { text: "Durmstrang", correct: false },
          { text: "Beauxbatons", correct: false },
          { text: "Ilvermorny", correct: false }
        ]
      },
      {
        content: "Welcher Film erhielt 2020 den Oscar für den besten Film?",
        explanation: "Der südkoreanische Film 'Parasite' gewann als erster nicht-englischsprachiger Film den Preis.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 125,
        answers: [
          { text: "Joker", correct: false },
          { text: "1917", correct: false },
          { text: "Parasite", correct: true },
          { text: "Once Upon a Time in Hollywood", correct: false }
        ]
      },
      {
        content: "Wie lautet der originale Name der Serie 'Dark'?",
        explanation: "Die Netflix-Produktion heißt auch im Original 'Dark'.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "Dark", correct: true },
          { text: "Dunkel", correct: false },
          { text: "Black", correct: false },
          { text: "Night", correct: false }
        ]
      },
      {
        content: "Welche Serie machte den Spruch 'Winter is coming' berühmt?",
        explanation: "Der Satz stammt aus 'Game of Thrones'.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 85,
        answers: [
          { text: "The Witcher", correct: false },
          { text: "Game of Thrones", correct: true },
          { text: "Vikings", correct: false },
          { text: "The Mandalorian", correct: false }
        ]
      },
      {
        content: "Wer verkörperte die Hauptfigur in 'Indiana Jones'?",
        explanation: "Harrison Ford spielt den Archäologen Dr. Henry 'Indiana' Jones.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Harrison Ford", correct: true },
          { text: "Tom Hanks", correct: false },
          { text: "Bruce Willis", correct: false },
          { text: "Tom Cruise", correct: false }
        ]
      },
      {
        content: "Aus welchem Jahrzehnt stammt der Filmklassiker 'Metropolis'?",
        explanation: "Fritz Langs 'Metropolis' erschien 1927 in der Weimarer Republik.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "1910er", correct: false },
          { text: "1920er", correct: true },
          { text: "1930er", correct: false },
          { text: "1940er", correct: false }
        ]
      },
      {
        content: "Wie heißt das Raumschiff der Serie 'Star Trek: The Next Generation'?",
        explanation: "Die Serie begleitet die Crew der USS Enterprise NCC-1701-D.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 125,
        answers: [
          { text: "USS Voyager", correct: false },
          { text: "USS Discovery", correct: false },
          { text: "USS Enterprise", correct: true },
          { text: "USS Defiant", correct: false }
        ]
      },
      {
        content: "Welche deutsche Schauspielerin spielt die Hauptrolle in 'Charité'?",
        explanation: "In Staffel 1 verkörpert Alicia von Rittberg die Krankenschwester Ida Lenze.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Karoline Herfurth", correct: false },
          { text: "Alicia von Rittberg", correct: true },
          { text: "Heike Makatsch", correct: false },
          { text: "Nora Tschirner", correct: false }
        ]
      }
    ]
  }
]

categories_payload.each do |category_attrs|
  questions = category_attrs.delete(:questions)
  category = Category.find_or_initialize_by(name: category_attrs[:name])
  category.update!(category_attrs)

  questions.each_with_index do |question_attrs, index|
    answers = question_attrs.delete(:answers)
    question = category.questions.find_or_initialize_by(content: question_attrs[:content])
    question.assign_attributes(question_attrs.merge(language: "de"))
    question.save!

    question.answer_options.destroy_all
    answers.each_with_index do |answer_attrs, position|
      question.answer_options.create!(answer_attrs.merge(position: position))
    end
  end
end

puts "   ✔ Kategorien und Fragen angelegt (#{Category.count} Kategorien, #{Question.count} Fragen)"

puts "==> Seeds abgeschlossen"
