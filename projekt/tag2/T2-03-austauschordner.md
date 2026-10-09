# T2-03: Austauschordner für alle

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Ein Ordner für alle
>
> Hallo IT,
>
> die Abteilungsordner sind super! Jetzt fehlt noch ein Ordner, in dem **alle** Mitarbeitenden etwas für die anderen ablegen können: den Speiseplan der Kantine, Fotos von der Weihnachtsfeier, Präsentationen für die ganze Firma.
>
> Eine Bitte: Es soll niemand die Dateien der anderen löschen können. Wir hatten das schon einmal auf dem alten Rechner. Plötzlich war der Speiseplan weg, und keiner wollte es gewesen sein.
>
> Grete

Alle Schritte führt ihr **auf dem Server** aus.

## Pflicht

### Schritt 1: Ordner anlegen, wie gelernt

1. Legt den Ordner `/srv/firma/austausch` an.
2. Richtet ihn genauso ein wie die Abteilungsordner aus T2-02, aber für die Gruppe `mitarbeitende`: Besitzer `root`, Rechte `2770`.
3. Prüft mit `ls -ld /srv/firma/austausch`. Erwartet wird `drwxrws--- … root mitarbeitende`.

### Schritt 2: Der Speiseplan verschwindet

1. Lena legt den Speiseplan an:

   ```bash
   echo "Montag: Fischstäbchen" > /srv/firma/austausch/speiseplan.txt
   ```

2. Jonas versucht, den Speiseplan zu löschen: `rm /srv/firma/austausch/speiseplan.txt`.
3. Prüft mit `ls -l /srv/firma/austausch`: Ist der Speiseplan weg?
4. Erklärt im Logbuch: Warum durfte Jonas die Datei löschen, selbst dann, wenn er an Lenas Datei kein Schreibrecht hat? Tipp: Wo steht der Name einer Datei: in der Datei selbst oder im Verzeichnis? Erinnert euch an T2-01 Erweiterung.

### Schritt 3: Das Sticky Bit

Das **Sticky Bit** an einem Verzeichnis sorgt dafür, dass dort nur noch die **Besitzerin oder der Besitzer einer Datei** sie löschen oder umbenennen darf.

1. Setzt zusätzlich zum SGID-Bit das Sticky Bit an `/srv/firma/austausch`. Symbolisch heißt es `+t`, oktal ist es die `1` an der vordersten Stelle. Rechnet aus: Welche Ziffer steht vorne, wenn SGID (`2`) **und** Sticky (`1`) gesetzt sind?
2. Prüft mit `ls -ld /srv/firma/austausch`. Erwartet wird `drwxrws--T`. Wo erkennt ihr das Sticky Bit?

### Schritt 4: Zweiter Versuch

1. Lena legt den Speiseplan neu an (wie in Schritt 2).
2. Jonas versucht erneut, ihn zu löschen. Notiert die Fehlermeldung (`Operation not permitted`, auf deutschsprachigen Systemen „Vorgang nicht zulässig“).
3. Jonas versucht, den Speiseplan umzubenennen: `mv /srv/firma/austausch/speiseplan.txt /srv/firma/austausch/weg.txt`. Klappt das?
4. Jonas liest den Speiseplan mit `cat`. Klappt das?
5. Jonas legt eine eigene Datei `/srv/firma/austausch/jonas.txt` an und löscht sie wieder. Klappt das?

### Schritt 5: Vergleich mit `/tmp`

1. Lasst euch mit `ls -ld /tmp` die Rechte von `/tmp` anzeigen.
2. Notiert die Rechte symbolisch und oktal.
3. Erklärt im Logbuch, warum `/tmp` das Sticky Bit braucht. Wer darf dort Dateien anlegen?

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T2-03** sollten alle Punkte grün sein.

### Abnahmekriterien

- `/srv/firma/austausch` gehört `root:mitarbeitende`.
- Der Ordner hat die Rechte `3770` (`drwxrws--T`).
- Der Speiseplan von Lena liegt im Ordner.

## Erweiterung: Was schützt das Sticky Bit und was nicht?

1. Jonas legt die Datei `/srv/firma/austausch/termine.txt` an. Prüft mit `ls -l`: Darf die Gruppe `mitarbeitende` in die Datei schreiben?
2. Lena versucht, die Datei zu **löschen**. Klappt das?
3. Lena versucht, den **Inhalt** der Datei zu überschreiben: `echo "Alle Termine abgesagt!" > /srv/firma/austausch/termine.txt`. Klappt das? Notiert die Meldung.
4. Vergleicht mit T2-02 Schritt 6: Dort durfte Murat an Lenas Datei eine Zeile anhängen. Was ist hier anders, an der Datei und am Ordner?
5. Die Ursache ist eine **Schutzfunktion des Linux-Kernels**, die nicht zu den klassischen Rechten gehört und in `ls -l` nicht zu sehen ist. Lasst euch ihren Wert anzeigen:

   ```bash
   cat /proc/sys/fs/protected_regular
   ```

   Lest in `man 5 proc_sys_fs` (Suchbegriff `protected_regular`) nach, was die Werte `0`, `1` und `2` bedeuten.
6. Erklärt im Logbuch: Was schützt das Sticky Bit, was schützt der Kernel zusätzlich, und gegen welchen Angriff in `/tmp` ist dieser Schutz gedacht?
7. Wer außer der Besitzerin oder dem Besitzer einer Datei darf trotz Sticky Bit löschen? Sucht in `man chmod` im Abschnitt zum *restricted deletion flag* nach der Antwort.
8. `/tmp` zeigt ein kleines `t`, euer Austauschordner ein großes `T`. Was bedeutet der Unterschied? (Vergleicht mit dem großen `S` aus T2-02.)
9. Räumt die Datei `termine.txt` auf (als Jonas).

## Profi: Das dritte Spezialbit, SUID

Es gibt drei Spezialbits: SUID (`4`), SGID (`2`) und Sticky (`1`). Zwei davon habt ihr heute an Verzeichnissen eingesetzt. Das dritte wirkt an **Programmen**.

1. Lasst euch mit `ls -l /usr/bin/passwd` die Rechte des Programms `passwd` anzeigen. Wo steht das `s`?
2. Lasst euch mit `ls -l /etc/shadow` die Rechte von `/etc/shadow` anzeigen. Lena darf diese Datei nicht einmal lesen (T1-06 Erweiterung). Trotzdem konnte sie gestern ihr Passwort ändern und damit `/etc/shadow` verändern. Erklärt das mithilfe des SUID-Bits.
3. Sucht mit `find` alle Programme auf dem Server, die das SUID-Bit haben:

   ```bash
   find / -type f -perm -4000 2>/dev/null
   ```

   Wie viele sind es (`| wc -l`)? Welche kennt ihr? Warum braucht `sudo` das SUID-Bit?
4. Sucht genauso alle Dateien mit dem SGID-Bit (`-perm -2000`).
5. Erklärt im Logbuch, warum Angreifer gern nach SUID-Programmen suchen, die `root` gehören.
6. Füllt die Übersicht aus:

   | Spezialbit | Oktal | symbolisch | Anzeige in `ls -l` | Wirkung an einer Datei | Wirkung an einem Verzeichnis | Beispiel |
   |---|---|---|---|---|---|---|
   | SUID | | | | | - | |
   | SGID | | | | | | |
   | Sticky | | | | - | | |

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Spezialbits: `man chmod`, Abschnitt `SETUID AND SETGID BITS` und `RESTRICTED DELETION FLAG OR STICKY BIT`
- Löschen ist eine Änderung des **Verzeichnisses**, nicht der Datei.
- Dateien nach Rechten suchen: `man find`, Suchbegriff `-perm`
- Zusätzlicher Schutz des Kernels: `man 5 proc_sys_fs`, Suchbegriff `protected_regular` (auf älteren Systemen in `man 5 proc`)

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
sudo mkdir /srv/firma/austausch
sudo chgrp mitarbeitende /srv/firma/austausch
sudo chmod 2770 /srv/firma/austausch
sudo chmod +t /srv/firma/austausch     oder   sudo chmod 3770 /srv/firma/austausch
ls -ld /srv/firma/austausch /tmp
cat /proc/sys/fs/protected_regular
sudo -iu <benutzer>
ls -l /usr/bin/passwd /etc/shadow
find / -type f -perm -4000 2>/dev/null
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

```bash
# Schritt 1
sudo mkdir /srv/firma/austausch
sudo chgrp mitarbeitende /srv/firma/austausch
sudo chmod 2770 /srv/firma/austausch

# Schritt 2 (als lwagner bzw. jbecker)
echo "Montag: Fischstäbchen" > /srv/firma/austausch/speiseplan.txt
rm /srv/firma/austausch/speiseplan.txt          # klappt!

# Schritt 3
sudo chmod 3770 /srv/firma/austausch            # oder: sudo chmod +t …
ls -ld /srv/firma/austausch                     # drwxrws--T

# Schritt 4 (als jbecker)
rm /srv/firma/austausch/speiseplan.txt          # Operation not permitted
```

**Schritt 2:** Der Name einer Datei steht im **Verzeichnis**. Wer eine Datei löscht, entfernt diesen Eintrag. Dafür braucht man `w` (und `x`) am **Verzeichnis**, nicht an der Datei. Jonas ist in der Gruppe `mitarbeitende` und hat deshalb Schreibrecht am Ordner. Dass Jonas wegen der umask `0002` auch Schreibrecht an der Datei hat (`rw-rw-r--`), spielt für das Löschen keine Rolle.

**Schritt 3:** SGID (`2`) + Sticky (`1`) = `3`, also `3770`. Das Sticky Bit erscheint als `t` bzw. `T` an der Stelle des `x` für `others`.

**Schritt 4:** Löschen und Umbenennen fremder Dateien sind verboten, Lesen ist weiterhin erlaubt (die Datei hat `r` für die Gruppe bzw. für andere). Eigene Dateien darf Jonas anlegen und löschen.

**Schritt 5:** `/tmp` hat `drwxrwxrwt` (`1777`): Alle Personen und alle Programme dürfen dort Dateien anlegen. Ohne Sticky Bit könnte jede Person die temporären Dateien aller anderen löschen oder austauschen.

**Erweiterung:** Lena kann `termine.txt` weder löschen noch überschreiben, obwohl die Datei für die Gruppe beschreibbar ist (`rw-rw-r--`).

- Das **Löschen** verhindert das Sticky Bit. Es schützt nur den **Verzeichniseintrag** (Löschen, Umbenennen), nicht den Inhalt.
- Das **Überschreiben** verhindert der Kernel mit `fs.protected_regular`. Beim Wert `2` darf in einem Ordner mit Sticky Bit, der für alle **oder für eine Gruppe** beschreibbar ist, niemand eine fremde Datei mit `>` oder `>>` öffnen (Ausnahme: Die Datei gehört dem Besitzer des Ordners). Beim Wert `1` gilt das nur für Ordner, die für alle beschreibbar sind, wie `/tmp`. Im Vertriebsordner (T2-02) gibt es kein Sticky Bit, deshalb durfte Murat dort anhängen.
- Gedacht ist der Schutz für `/tmp`: Ein Angreifer legt dort vorab eine Datei mit einem vorhersehbaren Namen an, und ein Programm eines anderen Benutzers schreibt dann ahnungslos hinein.

Für die Prüfung gilt die klassische Regel: Das Sticky Bit schützt vor dem Löschen und Umbenennen fremder Dateien. `protected_regular` ist eine Zusatzfunktion des Linux-Kernels.

Löschen dürfen außerdem die Besitzerin oder der Besitzer des **Verzeichnisses** (hier `root`) und `root`. Kleines `t`: Sticky Bit und `x` für `others` gesetzt. Großes `T`: Sticky Bit gesetzt, aber kein `x` für `others`.

**Profi:** `passwd` gehört `root` und hat `-rwsr-xr-x`. Das SUID-Bit sorgt dafür, dass das Programm mit den Rechten seines **Besitzers** (`root`) läuft, egal wer es startet. Deshalb kann `passwd` `/etc/shadow` schreiben. Das Programm selbst achtet darauf, dass normale Benutzer nur ihr **eigenes** Passwort ändern. `sudo` braucht das SUID-Bit aus demselben Grund. Jedes SUID-Programm von `root` ist eine mögliche Hintertür: Hat es einen Fehler, bekommt ein Angreifer Root-Rechte.

| Spezialbit | Oktal | symbolisch | Anzeige | Datei | Verzeichnis | Beispiel |
|---|---|---|---|---|---|---|
| SUID | `4` | `u+s` | `s` beim Besitzer | läuft mit den Rechten des Besitzers | - | `/usr/bin/passwd` |
| SGID | `2` | `g+s` | `s` bei der Gruppe | läuft mit den Rechten der Gruppe | neue Dateien erben die Gruppe | `/srv/firma/vertrieb` |
| Sticky | `1` | `+t` | `t` bei `others` | - | nur Besitzer dürfen löschen | `/tmp` |

</details>
