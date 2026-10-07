# Tag 2 – Abteilungsordner und Berechtigungen

Gestern habt ihr die Firma angelegt. Heute sorgt ihr dafür, dass jede Person genau das sehen und ändern darf, was sie braucht – nicht mehr und nicht weniger: private Heimatverzeichnisse, gemeinsame Abteilungsordner, ein Austauschordner für alle, ein kniffliger Wunsch der Geschäftsführung, Verknüpfungen und ein Abschied.

| Ticket | Thema | Stufen |
|---|---|---|
| [T2-01](./T2-01-heimatverzeichnisse.md) | Heimatverzeichnisse absichern | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T2-02](./T2-02-abteilungsordner.md) | Abteilungsordner | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T2-03](./T2-03-austauschordner.md) | Austauschordner für alle | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T2-04](./T2-04-lesezugriff-geschaeftsfuehrung.md) | Lesezugriff für die Geschäftsführung | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T2-05](./T2-05-verknuepfungen.md) | Verknüpfungen: Symlinks und Hardlinks | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T2-06](./T2-06-offboarding.md) | Offboarding | ⭐ ⭐⭐ ⭐⭐⭐ |

Bearbeitet die Tickets in dieser Reihenfolge. T2-02 ist die Voraussetzung für T2-03 bis T2-06.

## Neu heute: Als eine andere Person testen

Ob Berechtigungen stimmen, seht ihr nur, wenn ihr es **als die betroffene Person** ausprobiert. Dafür öffnet ihr auf dem Server eine Shell als diese Person:

```bash
sudo -iu lwagner     # Login-Shell als Lena Wagner
whoami               # zur Kontrolle
exit                 # zurück zum eigenen Konto
```

Ihr braucht dafür nicht das Passwort der Person. Anders als `sudo su - lwagner` verlangt `sudo -iu` auch dann keine Passwortänderung, wenn sich die Person noch nie angemeldet hat.

**Wichtig:** Testet nie mit `sudo` vor dem eigentlichen Kommando – `root` darf (fast) alles, und ihr würdet nichts über die Rechte lernen.

## Selbstkontrolle

Ladet das Check-Skript von Tag 2 auf euren Server und führt es aus:

```bash
wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/check/check-tag2.sh
sudo bash check-tag2.sh
```

Das Skript prüft die Abnahmekriterien aller sechs Tickets. Es verändert nichts am System.
