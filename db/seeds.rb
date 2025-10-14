# frozen_string_literal: true

puts "==> Initialisiere BrainBuster-Datenbank"

# 1) Administrator anlegen, falls noch nicht vorhanden.
admin = User.find_or_initialize_by(username: "admin")
admin.email = "admin@brainbuster.local"
admin.display_name = "Administrator"
admin.role = :admin
admin.password = "Passwort123!"
admin.password_confirmation = "Passwort123!"
admin.total_points ||= 0
admin.save!
puts "   ✔ Admin-Konto vorhanden oder aktualisiert (admin@brainbuster.local / Passwort123!)"

# 2) Achievement-Liste mit der Datenbank synchron halten.
Achievement.catalog.each do |attrs|
  achievement = Achievement.find_or_initialize_by(code: attrs[:code])
  achievement.update!(attrs)
end
puts "   ✔ Achievements synchronisiert (#{Achievement.count} gesamt)"

# 3) Beispiel-Kategorien samt Fragen und Antworten importieren.
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
    name: "WISO",
    description: "Wirtschafts- und Sozialkunde rund um Arbeitswelt, Politik und Recht.",
    featured: false,
    questions: [
      {
        content: "Die Infotec GmbH überträgt der IT-Systemkauffrau Sophie Schulz die Beschaffung von Hardware bis zu einem Auftragswert von 10.000 EUR. Mit welcher der folgenden Unterschriften muss Frau Schulz Geschäftsbriefe unterzeichnen?",
        difficulty: "mittel",
        time_limit_seconds: 35,
        base_points: 110,
        answers: [
          { text: "Schulz", correct: false },
          { text: "Sophie Schulz", correct: false },
          { text: "i.H. Schulz", correct: false },
          { text: "i.A. Schulz", correct: true }
        ]
      },
      {
        content: "Die Nachfrage der Kunden der Infotec GmbH hängt von verschiedenen Faktoren ab. Welche Aussage trifft zu?",
        difficulty: "mittel",
        time_limit_seconds: 35,
        base_points: 110,
        answers: [
          { text: "Die Nachfrage der Konsumenten ist immer unabhängig vom Angebot.", correct: false },
          { text: "Die Menge der Bedürfnisse der Konsumenten entspricht dem Bedarf.", correct: false },
          { text: "Der Bedarf der Konsumenten ist abhängig von der Kaufkraft.", correct: true },
          { text: "Die Bedürfnisse der Konsumenten entsprechen dem Angebot.", correct: false }
        ]
      },
      {
        content: "Die Fachinformatikerin Claudia Richter soll zu einem Vorstellungsgespräch eingeladen werden. Welche Frage darf nicht gestellt werden bzw. muss nicht wahrheitsgemäß beantwortet werden?",
        difficulty: "mittel",
        time_limit_seconds: 35,
        base_points: 110,
        answers: [
          { text: "Sind Sie bereit, im Ausland zu arbeiten?", correct: false },
          { text: "Haben Sie Erfahrungen in Teamarbeit?", correct: false },
          { text: "Welcher Religionsgemeinschaft gehören Sie an?", correct: true },
          { text: "Wie gut schätzen Sie Ihre Java-Kenntnisse ein?", correct: false }
        ]
      },
      {
        content: "Die Bundesregierung plant Maßnahmen zur Steigerung der Kaufkraft. Welche Maßnahme wirkt sich positiv auf die Kaufkraft aus?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Erhöhung der Importzölle für Produkte aus den USA.", correct: false },
          { text: "Erhöhung des Beitragssatzes zur gesetzlichen Krankenversicherung.", correct: false },
          { text: "Erhöhung des Wohngeldes.", correct: true },
          { text: "Erhöhung der Beitragsbemessungsgrenze in der Sozialversicherung.", correct: false }
        ]
      },
      {
        content: "Der Betriebsrat der Infotec GmbH lädt zur Betriebsversammlung ein. Wer ist teilnahmeberechtigt?",
        difficulty: "leicht",
        time_limit_seconds: 25,
        base_points: 90,
        answers: [
          { text: "Alle Arbeitnehmer des Unternehmens.", correct: true },
          { text: "Nur Betriebsratsmitglieder und Gewerkschaftsvertreter.", correct: false },
          { text: "Nur gewerkschaftlich organisierte Mitarbeitende.", correct: false },
          { text: "Nur Vollzeitmitarbeitende und Führungskräfte.", correct: false }
        ]
      },
      {
        content: "Solidarität ist ein gesellschaftspolitisches Prinzip in Deutschland. Welcher Sachverhalt entspricht dem Solidaritätsprinzip?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Die Freibeträge bei der Erbschaftsteuer werden gesenkt.", correct: false },
          { text: "Der Erwerb von Immobilien durch Kapitalgesellschaften wird steuerlich gefördert.", correct: false },
          { text: "Der Staat erhöht die Steuersätze für Einkünfte aus Zinsen und Dividenden.", correct: false },
          { text: "Die Leistungen der gesetzlichen Krankenversicherung sind einkommensunabhängig.", correct: true }
        ]
      },
      {
        content: "Welche Maßnahme fördert die Globalisierung und kommt der deutschen Volkswirtschaft zugute?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Die USA erhöhen Zölle auf EU-Produkte.", correct: false },
          { text: "Die Steuern für Transportdienstleistungen werden erhöht.", correct: false },
          { text: "Die EU schließt ein Freihandelsabkommen mit südamerikanischen Staaten.", correct: true },
          { text: "Die Infotec GmbH schließt ihre Niederlassungen in Asien.", correct: false }
        ]
      },
      {
        content: "Mitarbeitende der Infotec GmbH sind gesetzlich krankenversichert. Welche Aussage trifft zu?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Ein Kassenwechsel ist nur mit Zustimmung des Arbeitgebers möglich.", correct: false },
          { text: "Der Beitragssatz wird vom Bundesministerium für Gesundheit festgelegt.", correct: false },
          { text: "Der Beitrag wird vom Nettolohn berechnet.", correct: false },
          { text: "Die Beitragsbemessungsgrenze gibt die Grenze des Jahresbruttoentgelts an, bis zu der Beiträge fällig sind.", correct: true }
        ]
      },
      {
        content: "Für neue Mitarbeitende wird eine Probezeit von sechs Monaten vereinbart. Welche Aussage trifft zu?",
        difficulty: "leicht",
        time_limit_seconds: 25,
        base_points: 90,
        answers: [
          { text: "Der Arbeitnehmer kann während der Probezeit nicht kündigen.", correct: false },
          { text: "Der Arbeitgeber darf nur aus wichtigem Grund kündigen.", correct: false },
          { text: "Während der Probezeit kann mit einer Frist von zwei Wochen gekündigt werden.", correct: true },
          { text: "Nur der Arbeitnehmer darf während der Probezeit kündigen.", correct: false }
        ]
      },
      {
        content: "Die Infotec GmbH plant für ein neues Geschäftsfeld eine tägliche Arbeitszeit von zehn Stunden. Welche Aussage ist richtig?",
        difficulty: "mittel",
        time_limit_seconds: 35,
        base_points: 110,
        answers: [
          { text: "Die Vereinbarung ist zulässig, wenn sie tarifvertraglich geregelt wurde.", correct: false },
          { text: "Die tägliche Arbeitszeit unterliegt keiner gesetzlichen Beschränkung.", correct: false },
          { text: "Die Vereinbarung ist zulässig, weil am Wochenende nicht gearbeitet wird.", correct: false },
          { text: "Die Vereinbarung ist zulässig, wenn im Schnitt von sechs Monaten acht Stunden werktäglich nicht überschritten werden.", correct: true }
        ]
      },
      {
        content: "Die 18-jährige Auszubildende Laura Peters kauft einen Gaming-PC und zahlt in Raten. Welche Aussage trifft zu?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Darlehensgeschäfte mit Auszubildenden sind nichtig.", correct: false },
          { text: "Der Kauf ist schwebend unwirksam, bis die gesetzlichen Vertreter zustimmen.", correct: false },
          { text: "Der Kauf ist gültig, weil Frau Peters unbeschränkt geschäftsfähig ist.", correct: true },
          { text: "Auszubildende sind generell geschäftsunfähig.", correct: false }
        ]
      },
      {
        content: "Die Infotec GmbH ist Mitglied eines Arbeitgeberverbands. In welchem Vertragsbestandteil ist sie an kollektives Arbeitsrecht gebunden?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Das Arbeitsverhältnis beginnt am 1. Juli 2020.", correct: false },
          { text: "Der Mitarbeitende erhält 3.000 EUR Bruttogehalt.", correct: false },
          { text: "Der Mitarbeitende arbeitet im IT-Service.", correct: false },
          { text: "Die wöchentliche Arbeitszeit beträgt nach Tarifvertrag 38,5 Stunden.", correct: true }
        ]
      },
      {
        content: "Zwei Auszubildende diskutieren über Rentenversicherung und private Vorsorge. Welches Argument trifft zu?",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 100,
        answers: [
          { text: "Eine private Altersvorsorge ist notwendig, weil die gesetzliche Rente voraussichtlich nicht ausreichen wird.", correct: true },
          { text: "Eine private Altersvorsorge ist unnötig, weil das Rentenniveau in der gesetzlichen Versicherung steigt.", correct: false },
          { text: "Eine private Altersvorsorge lohnt sich nicht, weil jedem Arbeitnehmer eine Betriebsrente zusteht.", correct: false },
          { text: "Eine private Altersvorsorge ist nur bei steigender Inflation notwendig.", correct: false }
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
  },
  {
    name: "Naturwissenschaften",
    description: "Physik, Chemie und Biologie für wissbegierige Köpfe.",
    featured: true,
    questions: [
      {
        content: "Wie lautet die chemische Formel von Wasser?",
        explanation: "Zwei Wasserstoff- und ein Sauerstoffatom bilden ein Wassermolekül.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "H2O", correct: true },
          { text: "CO2", correct: false },
          { text: "O2H", correct: false },
          { text: "H2O2", correct: false }
        ]
      },
      {
        content: "Welcher Planet unseres Sonnensystems hat die meisten Monde?",
        explanation: "Stand 2024 besitzt der Gasriese Jupiter die meisten bekannten Monde.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Saturn", correct: false },
          { text: "Jupiter", correct: true },
          { text: "Neptun", correct: false },
          { text: "Uranus", correct: false }
        ]
      },
      {
        content: "Wie nennt man den Prozess, bei dem Pflanzen Lichtenergie in chemische Energie umwandeln?",
        explanation: "Die Photosynthese ermöglicht die Produktion von Glukose aus Licht, Wasser und CO₂.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Photosynthese", correct: true },
          { text: "Fermentation", correct: false },
          { text: "Oxidation", correct: false },
          { text: "Respiration", correct: false }
        ]
      },
      {
        content: "Welches Teilchen ist elektrisch negativ geladen?",
        explanation: "Elektronen tragen eine negative Ladung.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 85,
        answers: [
          { text: "Proton", correct: false },
          { text: "Neutron", correct: false },
          { text: "Elektron", correct: true },
          { text: "Photon", correct: false }
        ]
      },
      {
        content: "Welche Blutgruppe gilt als universeller Spender?",
        explanation: "Menschen mit Blutgruppe 0 negativ können den meisten Patienten Blut spenden.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "AB+", correct: false },
          { text: "A-", correct: false },
          { text: "0-", correct: true },
          { text: "B+", correct: false }
        ]
      },
      {
        content: "Welches Element hat das chemische Symbol Na?",
        explanation: "Na steht für Natrium, ein Alkali-Metall.",
        difficulty: "mittel",
        time_limit_seconds: 20,
        base_points: 100,
        answers: [
          { text: "Natrium", correct: true },
          { text: "Stickstoff", correct: false },
          { text: "Neon", correct: false },
          { text: "Nickel", correct: false }
        ]
      },
      {
        content: "Welche Einheit misst elektrische Leistung?",
        explanation: "Elektrische Leistung wird in Watt angegeben.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "Volt", correct: false },
          { text: "Ampere", correct: false },
          { text: "Watt", correct: true },
          { text: "Ohm", correct: false }
        ]
      },
      {
        content: "Was beschreibt das Hooke'sche Gesetz?",
        explanation: "Es stellt eine lineare Beziehung zwischen Kraft und Dehnung einer Feder her.",
        difficulty: "schwer",
        time_limit_seconds: 30,
        base_points: 150,
        answers: [
          { text: "Zusammenhang zwischen Masse und Energie", correct: false },
          { text: "Zusammenhang zwischen Kraft und Beschleunigung", correct: false },
          { text: "Zusammenhang zwischen Kraft und Federdehnung", correct: true },
          { text: "Zusammenhang zwischen Druck und Volumen", correct: false }
        ]
      },
      {
        content: "Welches Organ filtert beim Menschen Blut und produziert Urin?",
        explanation: "Die Nieren reinigen das Blut und bilden Urin zur Ausscheidung von Stoffwechselprodukten.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 85,
        answers: [
          { text: "Herz", correct: false },
          { text: "Leber", correct: false },
          { text: "Nieren", correct: true },
          { text: "Milz", correct: false }
        ]
      },
      {
        content: "Wie nennt man den Wechsel des Aggregatzustands von fest zu gasförmig ohne flüssige Phase?",
        explanation: "Sublimation beschreibt diesen direkten Übergang.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 115,
        answers: [
          { text: "Schmelzen", correct: false },
          { text: "Verdampfen", correct: false },
          { text: "Sublimation", correct: true },
          { text: "Kondensation", correct: false }
        ]
      }
    ]
  },
  {
    name: "Literatur & Sprache",
    description: "Romane, Gedichte und sprachliche Raffinessen aus aller Welt.",
    featured: false,
    questions: [
      {
        content: "Wer schrieb den Roman 'Der Name der Rose'?",
        explanation: "Umberto Eco veröffentlichte das Werk 1980.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Umberto Eco", correct: true },
          { text: "Italo Calvino", correct: false },
          { text: "Paolo Coelho", correct: false },
          { text: "Franz Kafka", correct: false }
        ]
      },
      {
        content: "Welche literarische Epoche prägte Johann Wolfgang von Goethe?",
        explanation: "Goethe gilt als zentrale Figur der Weimarer Klassik.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Expressionismus", correct: false },
          { text: "Weimarer Klassik", correct: true },
          { text: "Romantik", correct: false },
          { text: "Naturalismus", correct: false }
        ]
      },
      {
        content: "Welche Sprache hat die meisten Muttersprachler weltweit?",
        explanation: "Mandarin-Chinesisch führt mit über 900 Millionen Muttersprachlern.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Spanisch", correct: false },
          { text: "Mandarin", correct: true },
          { text: "Englisch", correct: false },
          { text: "Hindi", correct: false }
        ]
      },
      {
        content: "Welches Werk beginnt mit dem Satz 'Im Anfang war das Wort'?",
        explanation: "Der Prolog des Johannesevangeliums startet mit diesem Vers.",
        difficulty: "mittel",
        time_limit_seconds: 20,
        base_points: 105,
        answers: [
          { text: "Die Bibel", correct: true },
          { text: "Faust", correct: false },
          { text: "Odyssee", correct: false },
          { text: "Der Prozess", correct: false }
        ]
      },
      {
        content: "Wie viele Zeichen umfasst das deutsche Alphabet einschließlich Umlaute?",
        explanation: "Mit ä, ö, ü und ß umfasst es 30 Zeichen.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 95,
        answers: [
          { text: "26", correct: false },
          { text: "28", correct: false },
          { text: "30", correct: true },
          { text: "32", correct: false }
        ]
      },
      {
        content: "Welches epische Werk verfasste Homer neben der Odyssee?",
        explanation: "Die Ilias schildert Ereignisse des Trojanischen Kriegs.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Die Ilias", correct: true },
          { text: "Die Äneis", correct: false },
          { text: "Antigone", correct: false },
          { text: "Die Medea", correct: false }
        ]
      },
      {
        content: "Wie nennt man die Stilfigur, bei der Anfangsbuchstaben gleich sind?",
        explanation: "Die Alliteration nutzt gleiche Anlaute in aufeinanderfolgenden Wörtern.",
        difficulty: "mittel",
        time_limit_seconds: 20,
        base_points: 105,
        answers: [
          { text: "Metapher", correct: false },
          { text: "Alliteration", correct: true },
          { text: "Hyperbel", correct: false },
          { text: "Vergleich", correct: false }
        ]
      },
      {
        content: "Wie heißt die Autorin von 'Harry Potter'?",
        explanation: "J.K. Rowling veröffentlichte die Romanreihe zwischen 1997 und 2007.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "J.K. Rowling", correct: true },
          { text: "Suzanne Collins", correct: false },
          { text: "Stephenie Meyer", correct: false },
          { text: "Veronica Roth", correct: false }
        ]
      },
      {
        content: "Welcher Literat erhielt 1999 den Literaturnobelpreis?",
        explanation: "Günter Grass wurde 1999 für sein Lebenswerk ausgezeichnet.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Günter Grass", correct: true },
          { text: "Elfriede Jelinek", correct: false },
          { text: "Peter Handke", correct: false },
          { text: "Herta Müller", correct: false }
        ]
      },
      {
        content: "Welche Gattung umfasst Werke wie Lehrgedichte oder Fabeln?",
        explanation: "Didaktische Literatur verfolgt das Ziel, Wissen oder Moral zu vermitteln.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 115,
        answers: [
          { text: "Epik", correct: false },
          { text: "Didaktik", correct: true },
          { text: "Drama", correct: false },
          { text: "Lyrik", correct: false }
        ]
      }
    ]
  },
  {
    name: "Musik & Popkultur",
    description: "Chart-Hits, Musikgeschichte und popkulturelle Highlights.",
    featured: false,
    questions: [
      {
        content: "Welche Band veröffentlichte das Album 'Abbey Road'?",
        explanation: "Das 1969 erschienene Album stammt von den Beatles.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "The Beatles", correct: true },
          { text: "The Rolling Stones", correct: false },
          { text: "Pink Floyd", correct: false },
          { text: "Led Zeppelin", correct: false }
        ]
      },
      {
        content: "Welcher Künstler steht hinter dem Hit 'Blinding Lights'?",
        explanation: "Der kanadische Sänger The Weeknd landete damit 2020 einen Mega-Erfolg.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "Ed Sheeran", correct: false },
          { text: "The Weeknd", correct: true },
          { text: "Shawn Mendes", correct: false },
          { text: "Bruno Mars", correct: false }
        ]
      },
      {
        content: "Welche Musikerin gewann 2023 den Eurovision Song Contest?",
        explanation: "Loreen siegte für Schweden mit dem Song 'Tattoo'.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Loreen", correct: true },
          { text: "Netta", correct: false },
          { text: "Måneskin", correct: false },
          { text: "Jamala", correct: false }
        ]
      },
      {
        content: "Wie heißt das erfolgreichste deutschsprachige Rap-Album der 2010er laut Chartplatzierungen?",
        explanation: "Capital Bra erreichte zahlreiche Nummer-1-Platzierungen, unter anderem mit 'Berlin lebt'.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Royal Bunker", correct: false },
          { text: "Berlin lebt", correct: true },
          { text: "Aqua", correct: false },
          { text: "Der Holland Job", correct: false }
        ]
      },
      {
        content: "Welche K-Pop-Gruppe brachte 2020 den Song 'Butter' heraus?",
        explanation: "Die südkoreanische Gruppe BTS dominierte weltweit die Charts.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "BTS", correct: true },
          { text: "Blackpink", correct: false },
          { text: "EXO", correct: false },
          { text: "Seventeen", correct: false }
        ]
      },
      {
        content: "Welcher Film gewann 2023 den Oscar für den besten Film?",
        explanation: "'Everything Everywhere All at Once' wurde mehrfach ausgezeichnet.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 115,
        answers: [
          { text: "Everything Everywhere All at Once", correct: true },
          { text: "Top Gun: Maverick", correct: false },
          { text: "Avatar: The Way of Water", correct: false },
          { text: "The Banshees of Inisherin", correct: false }
        ]
      },
      {
        content: "Wer hostete die Late-Night-Show 'TV total'?",
        explanation: "Stefan Raab moderierte die Show von 1999 bis 2015.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Stefan Raab", correct: true },
          { text: "Harald Schmidt", correct: false },
          { text: "Jan Böhmermann", correct: false },
          { text: "Klaas Heufer-Umlauf", correct: false }
        ]
      },
      {
        content: "Welche Comicfigur feierte 1939 ihr Debüt in 'Detective Comics'?",
        explanation: "Batman erschien erstmals in Detective Comics #27.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Superman", correct: false },
          { text: "Batman", correct: true },
          { text: "Wonder Woman", correct: false },
          { text: "The Flash", correct: false }
        ]
      },
      {
        content: "Welche US-Serie machte Bryan Cranston als Walter White weltbekannt?",
        explanation: "'Breaking Bad' war zwischen 2008 und 2013 ein internationaler Erfolg.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "Breaking Bad", correct: true },
          { text: "Mad Men", correct: false },
          { text: "Lost", correct: false },
          { text: "The Wire", correct: false }
        ]
      },
      {
        content: "Welcher Künstler ist unter dem Spitznamen 'King of Pop' bekannt?",
        explanation: "Michael Jackson wird seit den 1980ern so genannt.",
        difficulty: "leicht",
        time_limit_seconds: 15,
        base_points: 80,
        answers: [
          { text: "Michael Jackson", correct: true },
          { text: "Prince", correct: false },
          { text: "Justin Timberlake", correct: false },
          { text: "Usher", correct: false }
        ]
      }
    ]
  },
  {
    name: "Gaming & eSports",
    description: "Videospiel-Klassiker, moderne Hits und eSports-Wissen.",
    featured: false,
    questions: [
      {
        content: "Welches Unternehmen entwickelte 'The Legend of Zelda'?",
        explanation: "Nintendo veröffentlichte das erste Zelda-Spiel 1986.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Nintendo", correct: true },
          { text: "Sony", correct: false },
          { text: "Sega", correct: false },
          { text: "Ubisoft", correct: false }
        ]
      },
      {
        content: "Welcher Battle-Royale-Titel wurde 2017 von Epic Games veröffentlicht?",
        explanation: "Fortnite etablierte das Genre mit seinem Free-to-Play-Modell.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 85,
        answers: [
          { text: "Fortnite", correct: true },
          { text: "PUBG", correct: false },
          { text: "Apex Legends", correct: false },
          { text: "Warzone", correct: false }
        ]
      },
      {
        content: "Wie heißt die Entwicklerfirma hinter 'League of Legends'?",
        explanation: "Riot Games entwickelte das populäre MOBA, das 2009 erschien.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "Riot Games", correct: true },
          { text: "Valve", correct: false },
          { text: "Blizzard", correct: false },
          { text: "Hi-Rez Studios", correct: false }
        ]
      },
      {
        content: "Welches Team gewann 2021 die League-of-Legends-Weltmeisterschaft?",
        explanation: "Edward Gaming besiegte DWG KIA im Finale.",
        difficulty: "mittel",
        time_limit_seconds: 30,
        base_points: 125,
        answers: [
          { text: "DWG KIA", correct: false },
          { text: "Edward Gaming", correct: true },
          { text: "T1", correct: false },
          { text: "Gen.G", correct: false }
        ]
      },
      {
        content: "Wie viele einzigartige Figuren (Champions) gab es in League of Legends Anfang 2024?",
        explanation: "Zu diesem Zeitpunkt waren über 160 Champions spielbar.",
        difficulty: "schwer",
        time_limit_seconds: 35,
        base_points: 150,
        answers: [
          { text: "Über 160", correct: true },
          { text: "Rund 120", correct: false },
          { text: "Rund 80", correct: false },
          { text: "Unter 60", correct: false }
        ]
      },
      {
        content: "Wie heißt das ikonische Item, das in Minecraft zum Craften nötig ist, um den Nether zu betreten?",
        explanation: "Ein Nether-Portal wird aus Obsidian-Blöcken aufgebaut.",
        difficulty: "leicht",
        time_limit_seconds: 20,
        base_points: 90,
        answers: [
          { text: "Obsidian", correct: true },
          { text: "Basalt", correct: false },
          { text: "Endstein", correct: false },
          { text: "Netherrack", correct: false }
        ]
      },
      {
        content: "Welches Entwicklerstudio steht hinter der 'The Witcher'-Spielereihe?",
        explanation: "CD Projekt Red entwickelte die Rollenspielserie basierend auf Sapkowskis Romanen.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 115,
        answers: [
          { text: "CD Projekt Red", correct: true },
          { text: "BioWare", correct: false },
          { text: "Bethesda", correct: false },
          { text: "Square Enix", correct: false }
        ]
      },
      {
        content: "In welchem Jahr erschien die erste PlayStation-Konsole in Europa?",
        explanation: "Sony veröffentlichte die PlayStation 1995 in Europa.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 110,
        answers: [
          { text: "1992", correct: false },
          { text: "1995", correct: true },
          { text: "1998", correct: false },
          { text: "2000", correct: false }
        ]
      },
      {
        content: "Welches Videospiel gilt als erstes kommerziell erfolgreiches Arcade-Spiel?",
        explanation: "'Pong' von Atari wurde 1972 ein weltweiter Erfolg.",
        difficulty: "mittel",
        time_limit_seconds: 20,
        base_points: 105,
        answers: [
          { text: "Pong", correct: true },
          { text: "Space Invaders", correct: false },
          { text: "Pac-Man", correct: false },
          { text: "Donkey Kong", correct: false }
        ]
      },
      {
        content: "Welches Spiel entwickelte FromSoftware vor 'Elden Ring'?",
        explanation: "2019 veröffentlichte das Studio 'Sekiro: Shadows Die Twice'.",
        difficulty: "mittel",
        time_limit_seconds: 25,
        base_points: 120,
        answers: [
          { text: "Sekiro: Shadows Die Twice", correct: true },
          { text: "Bloodborne", correct: false },
          { text: "Dark Souls III", correct: false },
          { text: "Armored Core VI", correct: false }
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

    kept_ids = []
    answers.each_with_index do |answer_attrs, position|
      option = question.answer_options.find_or_initialize_by(position: position)
      option.update!(answer_attrs.merge(position: position))
      kept_ids << option.id
    end

    question.answer_options.where.not(id: kept_ids).find_each do |option|
      if QuestionAttempt.where(answer_option_id: option.id).exists?
        puts "   WARN: Antwortoption '#{option.text}' blieb erhalten (bereits beantwortet)"
      else
        option.destroy!
      end
    end
  end
end

puts "   ✔ Kategorien und Fragen angelegt (#{Category.count} Kategorien, #{Question.count} Fragen)"

puts "==> Seeds abgeschlossen"
