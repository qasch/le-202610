# T3-02 – Logauswertung: Was war auf `pinguin-dev` los?

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** WG: Auffällige Aktivität auf Ihrem Server pinguin-dev
>
> Hallo IT,
>
> diese Mail kam heute vom Hoster unseres Testservers für die Entwicklung. Ich verstehe kein Wort. Ist das schlimm?
>
> Grete
>
> > Sehr geehrte Damen und Herren,
> >
> > auf Ihrem Server `pinguin-dev` haben wir in der Woche vom 28.09. bis 04.10.2026 eine ungewöhnlich hohe Zahl von Anmeldeversuchen festgestellt. Im Anhang finden Sie das Protokoll der Anmeldungen (`auth.log`). Bitte prüfen Sie, ob Ihr Server kompromittiert wurde.
> >
> > Mit freundlichen Grüßen
> > Ihr Hosting-Team

Ihr arbeitet **auf dem Server** in eurem Heimatverzeichnis, ohne `sudo`. Ladet zuerst die Logdatei herunter:

```bash
wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/daten/pinguin-dev-auth.log
```

Tipp: Speichert den Dateinamen in einer Variablen, dann müsst ihr ihn nicht jedes Mal tippen: `L=pinguin-dev-auth.log` – danach schreibt ihr `$L`.

Baut jede Pipeline **Schritt für Schritt** auf: erst das erste Kommando, dann `| head`, um das Zwischenergebnis zu sehen, dann das nächste Kommando anhängen.

## ⭐ Pflicht: Die Statistik

### Schritt 1: Überblick

1. Wie viele Zeilen hat die Datei?
2. Lasst euch die erste und die letzte Zeile anzeigen. Welchen Zeitraum umfasst das Protokoll?
3. Blättert mit `less $L` durch die Datei (Leertaste, `b`, `/Suchbegriff`, `q`). Sucht eine Zeile mit `Failed password` und eine mit `Accepted`.
4. Zerlegt die folgende Zeile im Logbuch in ihre Bestandteile: Datum, Uhrzeit, Zeitzone, Rechnername, Programm, Prozess-ID, Meldung.

   ```text
   2026-10-01T03:22:44.596182+02:00 pinguin-dev sshd[7920]: Accepted password for thoffmann from 198.51.100.23 port 46639 ssh2
   ```

### Schritt 2: Welche Programme schreiben ins Protokoll?

1. Schneidet mit `cut` das dritte Feld (Trennzeichen: Leerzeichen) aus allen Zeilen aus und schaut euch das Ergebnis mit `head` an.
2. Entfernt mit einem zweiten `cut` die Prozess-ID in eckigen Klammern (Trennzeichen `[`).
3. Zählt mit `sort | uniq -c`, wie viele Zeilen jedes Programm geschrieben hat, und sortiert das Ergebnis absteigend (`sort -rn`).

### Schritt 3: Fehlgeschlagene Anmeldungen zählen

1. Zählt alle Zeilen mit `Failed password`.
2. Zählt davon die Versuche mit Benutzernamen, die es auf dem Server gar nicht gibt (`Failed password for invalid user`).
3. Zählt die Versuche für `root`. Achtung: `grep root` findet auch viele andere Zeilen – sucht genauer.

### Schritt 4: Wer greift an? Die Top 5

Ihr wollt wissen, von welchen IP-Adressen die meisten Fehlversuche kamen.

1. Versucht es zuerst mit `cut`: Filtert die `Failed password`-Zeilen und schneidet das 9. Feld aus. Schaut euch das Ergebnis mit `head -n 20` an. Was ist das Problem? Vergleicht die Zeilen für `root` und für `invalid user`.
2. Sucht stattdessen mit einem regulären Ausdruck **nur** nach IP-Adressen und gebt mit `grep -o` nur den passenden Teil aus:

   ```bash
   grep 'Failed password' $L | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head
   ```

   Erklärt im Logbuch den Ausdruck Stück für Stück: Was bedeuten `[0-9]`, `{1,3}`, `\.` und `( … ){3}`?
3. Vervollständigt die Pipeline mit `sort`, `uniq -c`, `sort -rn` und `head -n 5`. Tragt das Ergebnis ein:

   | Platz | IP-Adresse | Fehlversuche |
   |---|---|---|
   | 1 | | |
   | 2 | | |
   | 3 | | |
   | 4 | | |
   | 5 | | |

4. Wie viele **verschiedene** IP-Adressen haben es versucht? (Tipp: `sort -u` und `wc -l`)

### Schritt 5: Ein Fallstrick beim Zählen

1. Zählt alle Zeilen, in denen die IP von Platz 1 vorkommt: `grep -c <ip> $L`
2. Vergleicht mit der Zahl aus der Tabelle. Warum ist sie so viel größer? Schaut euch mit `grep <ip> $L | head -n 12` an, welche Zeilen zu **einem** Anmeldeversuch gehören.

### Schritt 6: Welche Benutzernamen probieren die Angreifer?

1. Filtert die Zeilen mit `Invalid user` und schneidet den Benutzernamen aus (welches Feld?).
2. Ermittelt die zehn häufigsten Namen. Warum probieren Angreifer gerade diese?

### Schritt 7: Wann wird angegriffen?

1. Schneidet aus den `Failed password`-Zeilen das Datum aus (Zeichen 1 bis 10, `cut -c`) und zählt pro Tag.
2. An welchem Tag gab es die meisten Fehlversuche? Welcher Wochentag war das? (`date -d 2026-10-03 +%A`)
3. Wiederholt das für die **Stunde** (Zeichen 12 und 13). Zu welcher Tageszeit greifen die Bots am liebsten an? Warum wohl?

### Schritt 8: Zwischenbericht

Schreibt Grete im Logbuch drei Sätze: Wie viele Angriffe gab es, woher kamen sie, und was bedeutet das für einen Server im Internet?

## ⭐⭐ Erweiterung: Wurde eingebrochen?

Fehlversuche sind lästig, aber harmlos. Gefährlich wird es, wenn ein Versuch **klappt**.

### Schritt 1: Alle erfolgreichen Anmeldungen

1. Zählt die Zeilen mit `Accepted`.
2. Ermittelt, von welchen IP-Adressen erfolgreiche Anmeldungen kamen und wie oft (`grep -oE 'from [0-9.]+'`). Welche IP gehört vermutlich dem Büro?
3. Lasst euch alle erfolgreichen Anmeldungen anzeigen, die **nicht** aus dem Büro kommen (`grep -v`). Warum ist es sinnvoll, im Suchmuster ein Leerzeichen hinter die IP zu setzen?

### Schritt 2: Verdächtig oder harmlos?

Ihr findet drei Anmeldungen von außerhalb. Bewertet jede einzeln:

| Zeitpunkt | Benutzer | IP | Art (`password`/`publickey`) | Fehlversuche vorher? | Bewertung |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |
| | | | | | |

Tipp: Grete erzählt auf Nachfrage, dass Nina Schulz freitags im Homeoffice arbeitet.

### Schritt 3: Alles über den Angreifer

1. Zählt alle Zeilen mit der IP des Angreifers: `grep -c 198.51.100.23 $L`
2. Zählt noch einmal mit `grep -wc 198.51.100.23 $L`. Die Zahlen sind verschieden! Findet heraus, welche Zeilen der erste Aufruf zusätzlich gefunden hat. Tipp: `grep 198.51.100.23 $L | grep -vw 198.51.100.23 | head -n 3`
3. Erklärt im Logbuch, was `-w` bewirkt – und warum der Punkt in `198.51.100.23` eigentlich auch ein Problem ist.
4. Ermittelt, welche Benutzernamen der Angreifer probiert hat und wie oft:

   ```bash
   grep -w '198\.51\.100\.23' $L | grep 'Failed password' | grep -oE 'for (invalid user )?[a-z.]+' | sort | uniq -c | sort -rn
   ```

   Was fällt an den Namen auf? Woher könnte der Angreifer sie kennen?

### Schritt 4: Die Zeitleiste

1. Lasst euch alle Zeilen des Angreifers **ohne** die Fehlversuche anzeigen:

   ```bash
   grep -w '198\.51\.100\.23' $L | grep -v -e Failed -e pam_unix -e Invalid -e 'Connection closed'
   ```

2. Was hat der Angreifer nach der Anmeldung versucht? Sucht nach `sudo` und `NOT in sudoers`.
3. Rekonstruiert die Zeitleiste im Logbuch:

   | Zeitpunkt | Ereignis |
   |---|---|
   | | erster Fehlversuch |
   | | letzter Fehlversuch |
   | | erfolgreiche Anmeldung als … |
   | | Versuch, Root-Rechte zu bekommen |
   | | Abmeldung |
   | | zweite Anmeldung – diesmal mit … |

## ⭐⭐⭐ Profi: Bewertung und Maßnahmen

1. Die zweite Anmeldung des Angreifers erfolgte mit `publickey`, ohne einen einzigen Fehlversuch. Was muss der Angreifer bei seinem ersten Besuch getan haben? In welcher Datei im Heimatverzeichnis von `thoffmann` speichert SSH die erlaubten Schlüssel? (Sucht in `man sshd` nach `AUTHORIZED_KEYS`.)
2. Reicht es, Tims Passwort zu ändern? Und reicht es, sein Konto mit `usermod -L` zu sperren? (Erinnert euch an T1-05 ⭐⭐⭐.)
3. Der `sudo`-Versuch ist gescheitert. Auf welche Dateien konnte der Angreifer trotzdem zugreifen? Denkt an Tag 2: Tim ist Mitglied der Gruppe `entwicklung`.
4. Schreibt im Logbuch eine Antwortmail an Grete mit einer Maßnahmenliste, aufgeteilt in **sofort** und **dauerhaft**. Denkt u. a. an: Konto, Passwort, SSH-Schlüssel, Anmeldung mit Passwort per SSH, Root-Anmeldung, wiederholte Fehlversuche automatisch sperren, Erreichbarkeit aus dem Internet.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- Felder ausschneiden: `man cut` (`-d`, `-f`, `-c`)
- Zählen: `sort | uniq -c | sort -rn` ist das Standardrezept für „Wie oft kommt was vor?“
- Reguläre Ausdrücke: `man grep` (`-E`, `-o`, `-w`, `-v`, `-c`, `-e`), `man 7 regex`
- Im regulären Ausdruck steht `.` für **ein beliebiges Zeichen**. Ein echter Punkt wird mit `\.` geschrieben.
- Erlaubte SSH-Schlüssel: `man sshd`, Abschnitt `AUTHORIZED_KEYS FILE FORMAT`

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
wc -l $L
head -n 1 $L ; tail -n 1 $L
cut -d' ' -f3 $L | cut -d'[' -f1 | sort | uniq -c | sort -rn
grep -c 'Failed password' $L
grep -c 'Failed password for invalid user' $L
grep -c 'Failed password for root ' $L
grep 'Failed password' $L | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -rn | head -n 5
grep 'Invalid user' $L | cut -d' ' -f6 | sort | uniq -c | sort -rn | head
grep 'Failed password' $L | cut -c1-10 | sort | uniq -c
grep Accepted $L | grep -oE 'from [0-9.]+' | sort | uniq -c
grep Accepted $L | grep -v 'from 192.0.2.10 '
grep -w '198\.51\.100\.23' $L
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

**Schritt 1:** 6358 Zeilen, vom Mo 28.09.2026 00:17 bis So 04.10.2026 23:17. Bestandteile: `2026-10-01` Datum, `03:22:44.596182` Uhrzeit mit Mikrosekunden, `+02:00` Zeitzone (Sommerzeit), `pinguin-dev` Rechnername, `sshd` Programm, `7920` Prozess-ID, ab `Accepted` die Meldung.

**Schritt 2:** `sshd` 5675, `CRON` 504, `systemd-logind` 153, `sudo` 26.

**Schritt 3:** 1427 Fehlversuche, davon 1065 für ungültige Benutzer und 288 für `root`. Gesucht mit `'Failed password for root '` (mit Leerzeichen).

**Schritt 4:** Feld 9 enthält bei `Failed password for root from …` die IP, bei `Failed password for invalid user admin from …` aber den Benutzernamen – durch die zwei zusätzlichen Wörter verschieben sich die Felder. Der reguläre Ausdruck: `[0-9]` eine Ziffer, `{1,3}` ein- bis dreimal, `\.` ein echter Punkt, `( … ){3}` die Gruppe dreimal – also drei Zahlen mit Punkt und dann eine vierte Zahl.

| Platz | IP-Adresse | Fehlversuche |
|---|---|---|
| 1 | `203.0.113.45` | 412 |
| 2 | `192.0.2.201` | 287 |
| 3 | `203.0.113.9` | 156 |
| 4 | `198.51.100.23` | 93 |
| 5 | `198.51.100.140` | 64 |

Insgesamt 40 verschiedene IP-Adressen.

**Schritt 5:** `grep -c 203.0.113.45` ergibt 1261. Zu einem Versuch gehören mehrere Zeilen: `Invalid user …`, zwei `pam_unix`-Zeilen, `Failed password …` und am Ende der Verbindung `Connection closed …`. Wer zählen will, muss erst die richtigen Zeilen auswählen.

**Schritt 6:** Feld 6. Die häufigsten Namen: `admin` 117, `test` 76, `user` 65, `ubuntu` 57, `postgres` 56, `oracle` 55, `git` 31, `pi` 29, `guest` 24, `hadoop` 21. Das sind Standardkonten von Distributionen, Datenbanken und Geräten (z. B. `pi` beim Raspberry Pi), die oft schwache Passwörter haben.

**Schritt 7:**

| Mo 28.09. | Di 29.09. | Mi 30.09. | Do 01.10. | Fr 02.10. | Sa 03.10. | So 04.10. |
|---|---|---|---|---|---|---|
| 182 | 284 | 59 | 281 | 63 | **421** | 137 |

Die meisten Fehlversuche gab es am Samstag. Nach Stunden liegt die Spitze nachts (02 Uhr: 210, 01 Uhr: 168, 03 Uhr: 144) – dann ist niemand da, der es bemerkt.

**⭐⭐ Schritt 1:** 51 erfolgreiche Anmeldungen: 48 aus dem Büro (`192.0.2.10`), 2 von `198.51.100.23`, 1 von `192.0.2.77`. Ohne Leerzeichen würde `grep -v 'from 192.0.2.10'` auch z. B. `192.0.2.100` oder `192.0.2.105` ausblenden.

**⭐⭐ Schritt 2:**

| Zeitpunkt | Benutzer | IP | Art | Fehlversuche vorher? | Bewertung |
|---|---|---|---|---|---|
| Do 01.10. 03:22 | `thoffmann` | `198.51.100.23` | `password` | 93 von dieser IP | **Einbruch** |
| Fr 02.10. 02:58 | `thoffmann` | `198.51.100.23` | `publickey` | keine | **Einbruch**, Angreifer kommt zurück |
| Fr 02.10. 08:44 | `nschulz` | `192.0.2.77` | `password` | keine | harmlos: Homeoffice, normale Arbeitszeit |

**⭐⭐ Schritt 3:** `grep -c` ergibt 359, `grep -wc` 301. Die zusätzlichen Zeilen stammen von `198.51.100.234` – einer anderen IP, die mit `198.51.100.23` **beginnt**. `-w` findet das Muster nur als ganzes Wort. Außerdem passt der Punkt auf jedes Zeichen, `198.51.100.23` würde also auch `198x51y100z23` finden. Sauber ist `grep -w '198\.51\.100\.23'`.

Der Angreifer hat 25-mal `thoffmann`, 18-mal `jbecker`, 14-mal `ademir`, 11-mal `nschulz`, 9-mal `root`, 5-mal `admin`, je 4-mal `tim` und `tim.hoffmann` und 3-mal `jonas` probiert. Das sind die Namen der Entwicklung – vermutlich von der Website der Firma („Unser Team“). Ein gezielter Angriff, kein zufälliger Bot.

**⭐⭐ Schritt 4:**

| Zeitpunkt | Ereignis |
|---|---|
| Do 01.10. 01:48:23 | erster Fehlversuch |
| Do 01.10. 03:21:58 | letzter Fehlversuch |
| Do 01.10. 03:22:44 | erfolgreiche Anmeldung als `thoffmann` mit Passwort |
| Do 01.10. 03:24:43 und 03:25:20 | `sudo /bin/bash` und `sudo su -` – `user NOT in sudoers` |
| Do 01.10. 03:29:47 | Abmeldung |
| Fr 02.10. 02:58:41 | zweite Anmeldung als `thoffmann` – mit einem SSH-Schlüssel (RSA), Abmeldung 03:21:59 |

**⭐⭐⭐:**

1. Der Angreifer hat beim ersten Besuch seinen eigenen öffentlichen Schlüssel in `/home/thoffmann/.ssh/authorized_keys` eingetragen. Ab dann braucht er kein Passwort mehr.
2. Ein neues Passwort hilft nicht gegen den Schlüssel. Auch `usermod -L` sperrt nur das Passwort – die Anmeldung per Schlüssel funktioniert weiter. Wirksam: Ablaufdatum setzen (`usermod -e 1`) oder Login-Shell `nologin`, dann `authorized_keys` prüfen und bereinigen.
3. Auf alles, was Tim lesen darf: sein Heimatverzeichnis, alles, was für `others` lesbar ist, und – weil er in der Gruppe `entwicklung` ist – den gemeinsamen Ordner der Entwicklung.
4. Beispiel für die Maßnahmenliste:
   - **Sofort:** Konto `thoffmann` sperren (Ablaufdatum), `authorized_keys` aller Konten prüfen, Tims Passwort neu setzen, prüfen, ob Dateien verändert wurden, Tim informieren.
   - **Dauerhaft:** SSH-Anmeldung nur noch mit Schlüssel (`PasswordAuthentication no`), keine Root-Anmeldung (`PermitRootLogin no`), wiederholte Fehlversuche automatisch sperren (z. B. `fail2ban`), SSH nur aus dem Büro oder über VPN erreichbar machen (Firewall), starke Passwörter, Namen der Konten nicht öffentlich machen, Logs regelmäßig auswerten.

</details>
