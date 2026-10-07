# Tag 1 – Server in Betrieb nehmen, Benutzer und Gruppen anlegen

Heute richtet ihr den Server der Pinguin GmbH ein und legt die Firma an: Admin-Konten für euch, Abteilungen, Mitarbeitende und ein paar Sonderfälle, die es in jeder Firma gibt.

| Ticket | Thema | Stufen |
|---|---|---|
| [T1-01](./T1-01-server-in-betrieb-nehmen.md) | Server in Betrieb nehmen, SSH, `sudo` | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T1-02](./T1-02-bestandsaufnahme.md) | Bestandsaufnahme: Wer ist schon da? | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T1-03](./T1-03-abteilungen-vorbereiten.md) | Abteilungen vorbereiten | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T1-04](./T1-04-onboarding.md) | Onboarding der Mitarbeitenden | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T1-05](./T1-05-sonderfaelle.md) | Sonderfälle | ⭐ ⭐⭐ ⭐⭐⭐ |
| [T1-06](./T1-06-erster-arbeitstag.md) | Erster Arbeitstag | ⭐ ⭐⭐ ⭐⭐⭐ |

Bearbeitet die Tickets in dieser Reihenfolge. T1-01 ist die Voraussetzung für alle anderen.

## Selbstkontrolle

Ladet das Check-Skript von GitHub auf euren Server und führt es aus:

```bash
wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/check/check-tag1.sh
sudo bash check-tag1.sh
```

Wenn der Trainer das Skript im Laufe des Tages aktualisiert, ladet es mit `wget -O check-tag1.sh …` neu herunter – ohne `-O` legt `wget` sonst eine zweite Datei `check-tag1.sh.1` an.

Das Skript prüft die Tickets T1-01, T1-03, T1-04 und T1-05. Ihr könnt es beliebig oft ausführen – es verändert nichts.
