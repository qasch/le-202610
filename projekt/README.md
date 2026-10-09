# Projekt: Die Pinguin GmbH zieht auf Linux um

In den letzten vier Kurstagen seid ihr die neue IT-Abteilung der **Pinguin GmbH**. Statt Übungsblättern bekommt ihr **Tickets**, so wie sie auch im Arbeitsalltag einer Administratorin oder eines Administrators auf dem Tisch landen.

Ihr arbeitet im Team auf einem gemeinsamen Server, legt die Firma an, sorgt für saubere Berechtigungen, analysiert das System und behebt am Ende echte Störungen.

Alle Infos zur Firma findet ihr in [`00-pinguin-gmbh.md`](./00-pinguin-gmbh.md).

Lest die Tickets im Browser auf GitHub: <https://github.com/qasch/le-202610/tree/main/projekt>. Nur dort sind die Hilfekarten eingeklappt.

## Ablauf

| Tag | Thema | Tickets |
|---|---|---|
| 1 | Server in Betrieb nehmen, Benutzer und Gruppen anlegen | [Tag 1](./tag1/) |
| 2 | Abteilungsordner und Berechtigungen | [Tag 2](./tag2/) |
| 3 | Systemanalyse, Logauswertung, Sicherheitsaudit, Datensicherung, erstes Skript, Software-Empfehlung | [Tag 3](./tag3/) |
| 4 | Störfälle beheben, Präsentation, Rückblick | folgt |

## Spielregeln

### Teams

- Ihr arbeitet in Teams zu dritt.
- **Eine** VM pro Team wird zum Firmenserver. Die anderen VMs sind eure Arbeitsplätze, von denen ihr euch per SSH auf den Server verbindet.
- Vor dem Start legt ihr einen **Snapshot** der Server-VM an. Wenn etwas kaputtgeht, ist das kein Drama sondern Teil des Lernens.

### Rollen

Bei jedem Ticket wechseln die Rollen:

- **Tastatur:** tippt, und zwar nur das, was das Team gemeinsam beschlossen hat.
- **Navigation:** sagt, was zu tun ist, und erklärt, warum.
- **Logbuch:** dokumentiert Kommandos, Erkenntnisse und Stolpersteine im [Admin-Logbuch](./vorlagen/admin-logbuch.md).

Wer sich schon sicher fühlt, übernimmt bevorzugt die Navigation: Erklären ist schwieriger als Tippen.

### Schwierigkeitsstufen

Jedes Ticket hat bis zu drei Stufen:

- **Pflicht:** schafft jedes Team.
- **Erweiterung:** für alle, die noch Zeit haben.
- **Profi:** für alle, die es genau wissen wollen.

Es ist völlig in Ordnung, nur die Pflicht zu schaffen. Lieber verstanden als abgehakt.

### Hilfekarten

Zu jedem Ticket gibt es Hilfekarten, die ihr selbst aufklappt:

1. **Wo steht's?** Ein Hinweis auf Manpage oder Thema
2. **Welches Kommando?** Die benötigten Kommandos
3. **Lösung:** Eine Musterlösung mit Erklärung

Versucht es zuerst ohne. Wenn ihr länger als 10 Minuten feststeckt, deckt die nächste Karte auf.

### Selbstkontrolle

Mit dem Check-Skript prüft ihr auf dem Server selbst, ob die Abnahmekriterien erfüllt sind:

```bash
sudo bash check-tag1.sh
```

Ihr bekommt für jedes Kriterium einen grünen Haken oder ein rotes Kreuz mit Hinweis. Das Skript verändert nichts am System.

### Standups

Morgens und nach der Mittagspause gibt es ein kurzes Standup (max. 2 Minuten pro Team):

- Was haben wir geschafft?
- Woran hängen wir?
- Was war die überraschendste Erkenntnis?
