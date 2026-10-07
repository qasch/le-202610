# T3-04 – Datensicherung

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Datensicherung – jetzt aber wirklich
>
> Hallo IT,
>
> vor ein paar Tagen habt ihr ein Konto für die Datensicherung angelegt. Gesichert wird aber noch nichts! Nach der Geschichte mit `pinguin-dev` möchte ich, dass ab heute die **Firmenordner** gesichert werden.
>
> Und bitte probiert auch aus, ob man aus der Sicherung wirklich etwas zurückholen kann. Mein Schwager sagt, das vergisst jeder.
>
> Grete

Alle Schritte führt ihr **auf dem Server** aus. Gesichert wird mit `sudo`, weil nur `root` alle Abteilungsordner lesen darf.

## ⭐ Pflicht

### Schritt 1: Ein sicherer Ort für die Sicherungen

1. Legt das Verzeichnis `/srv/backup` an.
2. Es darf nur `root` hinein: Besitzer `root:root`, Rechte `700`. Warum ist das wichtig? Denkt an die Buchhaltung.

### Schritt 2: Die erste Sicherung

1. Erstellt ein mit `gzip` komprimiertes `tar`-Archiv von `/srv/firma`. Der Dateiname soll das heutige Datum enthalten:

   ```bash
   sudo tar -czf /srv/backup/firma-$(date +%F).tar.gz /srv/firma
   ```

2. Welches Datumsformat erzeugt `date +%F`? Warum ist dieses Format für Dateinamen besonders praktisch? (Tipp: `ls` sortiert alphabetisch.)
3. Erklärt im Logbuch jede Option: `-c`, `-z`, `-f`. Was bedeutet die Meldung `Removing leading '/' from member names`?
4. Prüft mit `sudo ls -lh /srv/backup`: Wie groß ist das Archiv?

### Schritt 3: Die Sicherung prüfen

1. Lasst euch den Inhalt des Archivs anzeigen, **ohne** es auszupacken. Steht `srv/firma/vertrieb/angebot-1.txt` darin?
2. Zählt die Einträge im Archiv (`| wc -l`) und vergleicht mit der Anzahl der Dateien und Verzeichnisse in `/srv/firma` (`sudo find /srv/firma | wc -l`). Stimmen die Zahlen überein?
3. Mit der Option `-v` zeigt `tar -t` mehr. Was zusätzlich? Werden Besitzer, Gruppe und Rechte mitgesichert?

### Schritt 4: Der Ernstfall – eine Datei ist weg

1. Lena löscht „aus Versehen“ ihr Angebot. Öffnet eine Shell als `lwagner` und führt aus:

   ```bash
   rm /srv/firma/vertrieb/angebot-1.txt
   ```

2. Holt **nur diese eine Datei** aus der Sicherung an ihren ursprünglichen Ort zurück. Ihr braucht dafür:
   - die Option zum Auspacken (`-x`),
   - die Option `-C /`, damit `tar` relativ zum Wurzelverzeichnis auspackt,
   - den Pfad der Datei **so, wie er im Archiv steht** (ohne führenden `/`).
3. Prüft mit `ls -l /srv/firma/vertrieb`: Ist die Datei wieder da? Stimmen Besitzer, Gruppe und Rechte?
4. Lena prüft als `lwagner` mit `cat`, ob der Inhalt stimmt.

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T3-04** sollten alle Punkte grün sein.

### Abnahmekriterien

- `/srv/backup` gehört `root:root` und hat die Rechte `700`.
- In `/srv/backup` liegt mindestens ein Archiv `firma-<datum>.tar.gz`, das `srv/firma/vertrieb/angebot-1.txt` enthält.
- `/srv/firma/vertrieb/angebot-1.txt` existiert wieder und gehört `lwagner:vertrieb`.

## ⭐⭐ Erweiterung: Kompression vergleichen und auslagern

### Kompressionsverfahren

1. Erstellt zum Vergleich zwei weitere Archive von `/srv/firma`: eins mit `bzip2` (`-j`, Endung `.tar.bz2`) und eins mit `xz` (`-J`, Endung `.tar.xz`). Legt sie in `/tmp` ab. Meldet `tar`, dass `bzip2` fehlt, installiert das gleichnamige Paket und löscht die leere Archivdatei, die `tar` trotzdem angelegt hat.
2. Erstellt außerdem ein **unkomprimiertes** Archiv (`/tmp/firma.tar`).
3. Vergleicht die Größen mit `ls -l` und füllt die Tabelle aus:

   | Verfahren | Option | Endung | Größe in Byte |
   |---|---|---|---|
   | ohne | – | `.tar` | |
   | gzip | `-z` | `.tar.gz` | |
   | bzip2 | `-j` | `.tar.bz2` | |
   | xz | `-J` | `.tar.xz` | |

4. Das unkomprimierte Archiv ist genau 20480 Byte groß oder ein Vielfaches von 10240 Byte – obwohl die Dateien zusammen nur wenige hundert Byte haben. Warum? (Tipp: Sucht in `man tar` nach `record` und `blocking-factor`.)
5. Räumt die Archive in `/tmp` wieder auf.

### Eine Sicherung auf demselben Server?

1. Überlegt: Was passiert mit der Sicherung, wenn die Festplatte des Servers kaputtgeht – oder ein Angreifer `root` wird?
2. Recherchiert die **3-2-1-Regel** für Datensicherungen und notiert sie im Logbuch.
3. Kopiert die Sicherung auf euren Arbeitsplatz. Weil nur `root` sie lesen darf, legt ihr auf dem Server zuerst eine Kopie für euer Konto an und holt sie dann mit `scp` ab:

   ```bash
   # auf dem Server
   sudo cp /srv/backup/firma-$(date +%F).tar.gz ~/
   sudo chown $USER: ~/firma-$(date +%F).tar.gz
   # auf dem Arbeitsplatz
   scp <euer-konto>@<server>:firma-*.tar.gz .
   ```

4. Löscht die Kopie im Heimatverzeichnis auf dem Server danach wieder. Warum?

## ⭐⭐⭐ Profi: Und das Konto `pinguin-backup`?

In T1-05 habt ihr das Dienstkonto `pinguin-backup` angelegt. Eigentlich soll die Sicherung nicht als `root` laufen.

1. Versucht, die Sicherung als `pinguin-backup` zu erstellen. Mit `sudo -u` startet ihr ein einzelnes Kommando als dieses Konto – dafür braucht es keine Login-Shell:

   ```bash
   sudo -u pinguin-backup tar -czf /tmp/test-backup.tar.gz /srv/firma
   ```

2. Notiert die Fehlermeldungen. Welche Ordner kann `pinguin-backup` nicht lesen und warum?
3. Diskutiert im Team und notiert im Logbuch: Wie könnte man `pinguin-backup` alles **lesen** lassen, ohne dass es **schreiben** darf? Erinnert euch an Gretes Wunsch in T2-04 – es ist dasselbe Problem.
4. Warum ist es trotzdem eine schlechte Idee, `pinguin-backup` einfach in alle Abteilungsgruppen aufzunehmen?
5. Räumt `/tmp/test-backup.tar.gz` auf.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- `man tar`: `-c` erstellen, `-t` auflisten, `-x` auspacken, `-f` Archivdatei, `-z`/`-j`/`-J` Kompression, `-v` ausführlich, `-C` Zielverzeichnis
- Datumsformate: `man date`, `%F` = `%Y-%m-%d`
- Beim Auspacken einzelner Dateien gebt ihr den Pfad genau so an, wie `tar -t` ihn zeigt.
- `root` stellt beim Auspacken Besitzer, Gruppe und Rechte aus dem Archiv wieder her.

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
sudo mkdir /srv/backup
sudo chmod 700 /srv/backup
sudo tar -czf /srv/backup/firma-$(date +%F).tar.gz /srv/firma
sudo tar -tzf /srv/backup/firma-<datum>.tar.gz
sudo tar -tvzf /srv/backup/firma-<datum>.tar.gz
sudo tar -xzf /srv/backup/firma-<datum>.tar.gz -C / srv/firma/vertrieb/angebot-1.txt
sudo apt install bzip2
sudo tar -cjf /tmp/firma.tar.bz2 /srv/firma
sudo tar -cJf /tmp/firma.tar.xz /srv/firma
sudo -u pinguin-backup tar -czf /tmp/test-backup.tar.gz /srv/firma
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

```bash
# Schritt 1
sudo mkdir /srv/backup
sudo chmod 700 /srv/backup
ls -ld /srv/backup                    # drwx------ root root

# Schritt 2
sudo tar -czf /srv/backup/firma-$(date +%F).tar.gz /srv/firma
sudo ls -lh /srv/backup

# Schritt 3
sudo tar -tzf /srv/backup/firma-$(date +%F).tar.gz
sudo tar -tzf /srv/backup/firma-$(date +%F).tar.gz | wc -l
sudo find /srv/firma | wc -l
sudo tar -tvzf /srv/backup/firma-$(date +%F).tar.gz

# Schritt 4
sudo -iu lwagner rm /srv/firma/vertrieb/angebot-1.txt
sudo tar -xzf /srv/backup/firma-$(date +%F).tar.gz -C / srv/firma/vertrieb/angebot-1.txt
ls -l /srv/firma/vertrieb
```

**Schritt 1:** Die Sicherung enthält die Dateien **aller** Abteilungen, auch der Buchhaltung. Wer die Sicherung lesen kann, umgeht alle Rechte aus Tag 2.

**Schritt 2:** `date +%F` erzeugt `JJJJ-MM-TT`, z. B. `2026-10-08`. In diesem Format sortiert `ls` die Sicherungen automatisch in zeitlicher Reihenfolge. `-c` = erstellen (*create*), `-z` = mit `gzip` komprimieren, `-f` = Name der Archivdatei (muss direkt danach folgen). `tar` entfernt den führenden `/`, damit beim Auspacken nicht versehentlich die Originale überschrieben werden.

**Schritt 3:** Die Zahlen stimmen überein: Beide zählen `/srv/firma` selbst, alle Unterverzeichnisse und alle Dateien. `tar -tv` zeigt zusätzlich Rechte, Besitzer, Gruppe, Größe und Datum – all das wird mitgesichert.

**Schritt 4:** Mit `-C /` packt `tar` relativ zu `/` aus, aus `srv/firma/vertrieb/angebot-1.txt` wird also wieder `/srv/firma/vertrieb/angebot-1.txt`. Weil `root` auspackt, stimmen Besitzer (`lwagner`), Gruppe (`vertrieb`) und Rechte wieder. Alle anderen Dateien im Archiv bleiben unberührt, weil nur dieser eine Pfad angegeben ist.

**⭐⭐:** Bei wenigen kleinen Textdateien ist `xz` meist am kleinsten, `gzip` am schnellsten – die Unterschiede sind hier gering. Das unkomprimierte Archiv ist groß, weil `tar` für jede Datei und jedes Verzeichnis einen Kopfblock von 512 Byte schreibt, jede Datei auf volle 512 Byte auffüllt und am Ende zwei leere Blöcke anhängt. Geschrieben wird außerdem in *Records* von 20 Blöcken (10240 Byte), deshalb ist die Größe immer ein Vielfaches davon – bei `/srv/firma` mit seinen wenigen Dateien 20480 Byte. **3-2-1-Regel:** **3** Kopien der Daten, auf **2** verschiedenen Speichermedien, davon **1** an einem anderen Ort. Die Kopie im Heimatverzeichnis muss weg, weil sie sonst die Rechte von `/srv/backup` umgeht.

**⭐⭐⭐:** `pinguin-backup` darf weder in die Abteilungsordner (`2770`, keine Rechte für `others`) noch in die privaten Heimatverzeichnisse. Es bekommt `Permission denied` für fast alles – außer dem, was für alle lesbar ist. „Alles lesen, nichts schreiben“ ist mit den klassischen Rechten dasselbe ungelöste Problem wie bei Grete (T2-04). In allen Abteilungsgruppen hätte `pinguin-backup` auch überall **Schreibrecht** – ein Angreifer, der dieses Konto übernimmt, könnte alle Daten verändern oder löschen. In der Praxis läuft die Sicherung deshalb meist als `root`, oder man verwendet ACLs bzw. spezielle Fähigkeiten (*Capabilities*) für das Backup-Programm.

</details>
