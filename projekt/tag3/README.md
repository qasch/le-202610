# Tag 3: Systemanalyse, Logauswertung, Datensicherung, erstes Skript

Heute zeigt sich, was ihr in den ersten beiden Kurswochen gelernt habt: Ihr erstellt einen Steckbrief eures Servers, findet in einer Logdatei einen echten Einbruch, prüft euren eigenen Server auf Schwachstellen und richtet die Datensicherung ein. Am Nachmittag wird aus euren Kommandos euer erstes Skript, und zum Abschluss beratet ihr die Geschäftsführung zu freier Software.

| Ticket | Thema |
|---|---|
| [T3-01](./T3-01-server-steckbrief.md) | Server-Steckbrief |
| [T3-02](./T3-02-logauswertung.md) | Logauswertung: Was war auf `pinguin-dev` los? |
| [T3-03](./T3-03-sicherheitsaudit.md) | Sicherheitsaudit des eigenen Servers |
| [T3-04](./T3-04-datensicherung.md) | Datensicherung |
| [T3-05](./T3-05-erstes-skript.md) | Das erste Skript |
| [T3-06](./T3-06-software-empfehlung.md) | Software-Empfehlung für die Geschäftsführung |

T3-05 baut auf T3-04 auf. Die übrigen Tickets sind unabhängig voneinander. T3-06 endet mit einer kurzen Präsentation am Nachmittag. Der Trainer sagt euch, wann.

## Material

Die Logdatei für T3-02 ladet ihr in euer Heimatverzeichnis auf dem Server:

```bash
wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/daten/pinguin-dev-auth.log
```

## Selbstkontrolle

```bash
wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/check/check-tag3.sh
sudo bash check-tag3.sh
```

Das Skript prüft die Abnahmekriterien von T3-01, T3-04 und T3-05. Die Ergebnisse von T3-02, T3-03 und T3-06 stehen in eurem Logbuch. Das Skript verändert nichts am System.
