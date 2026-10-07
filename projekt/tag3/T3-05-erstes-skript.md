# T3-05 – Das erste Skript

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Jeden Tag dasselbe?
>
> Hallo IT,
>
> super, dass die Sicherung funktioniert! Aber ehrlich: Muss jeden Abend jemand von euch dieses lange Kommando abtippen? Und was, wenn ihr euch vertippt? Geht das nicht einfacher – auf Knopfdruck?
>
> Grete

Ein **Shell-Skript** ist eine Textdatei mit Kommandos, die die Shell nacheinander ausführt – genau die Kommandos, die ihr sonst von Hand eintippen würdet. Ihr macht aus der Sicherung von T3-04 ein Skript.

Alle Schritte führt ihr **auf dem Server** aus.

## ⭐ Pflicht

### Schritt 1: Das Kommando wiederfinden

1. Sucht in eurer History das `tar`-Kommando aus T3-04: `history | grep tar`
2. Hat es jemand anderes aus dem Team getippt? Dann steht es in **dessen** History. Warum hat jedes Konto eine eigene History? (Tipp: `ls -la ~`)

### Schritt 2: Das Skript schreiben

1. Legt mit `nano ~/firma-backup` eine neue Datei an und schreibt hinein:

   ```bash
   #!/bin/bash
   # firma-backup – sichert die Firmenordner nach /srv/backup
   # Aufruf: sudo firma-backup

   echo "Sicherung von /srv/firma startet ..."
   tar -czf /srv/backup/firma-$(date +%F).tar.gz /srv/firma
   echo "Sicherung fertig."
   ls -lh /srv/backup
   ```

2. Was bedeutet die erste Zeile (`#!/bin/bash`, gesprochen *Shebang*)? Was bedeuten die Zeilen, die mit `#` beginnen?
3. Warum steht im Skript **kein** `sudo` vor `tar`?

### Schritt 3: Das Skript ausführen

1. Versucht, das Skript zu starten: `./firma-backup`. Notiert die Fehlermeldung.
2. Schaut euch mit `ls -l ~/firma-backup` die Rechte an. Was fehlt? (Tag 2!)
3. Gebt **euch selbst** das Recht, das Skript auszuführen.
4. Startet es erneut mit `./firma-backup`. Was passiert jetzt? Notiert die Fehlermeldungen von `tar`.
5. Startet es mit `sudo ./firma-backup`. Klappt es jetzt?
6. Erklärt im Logbuch: Welche zwei Arten von Rechten braucht es, damit das Skript erfolgreich läuft?

### Schritt 4: Was passiert beim zweiten Aufruf?

1. Startet das Skript ein zweites Mal. Wie viele Sicherungen von heute liegen danach in `/srv/backup`?
2. Was ist mit der ersten Sicherung von heute passiert? Ist das ein Problem?

### Schritt 5: Für alle Admins verfügbar machen

Das Skript liegt in **eurem** Heimatverzeichnis – die anderen Admins kommen nicht dran, und man muss den Pfad mit `./` angeben.

1. Lasst euch mit `echo $PATH` anzeigen, in welchen Verzeichnissen die Shell nach Programmen sucht. Notiert sie.
2. Lasst euch anzeigen, welchen Suchpfad `sudo` verwendet: `sudo sh -c 'echo $PATH'`. Welches Verzeichnis ist für eigene Admin-Programme gedacht? (Tipp: `local` und `sbin`)
3. Kopiert das Skript nach `/usr/local/sbin/firma-backup`.
4. Sorgt dafür, dass es `root` gehört und **nur** `root` es ändern darf: Rechte `755` (`rwxr-xr-x`).
5. Startet es von einem beliebigen Verzeichnis aus mit `sudo firma-backup` – ohne Pfad.
6. Prüft mit `which firma-backup`, wo die Shell das Programm findet. Klappt das auch als normales Konto? Warum?

### Schritt 6: Warum darf nur `root` das Skript ändern?

Diskutiert im Team und notiert im Logbuch: Was könnte passieren, wenn `/usr/local/sbin/firma-backup` für die Gruppe oder für alle **beschreibbar** wäre? Denkt daran, mit welchen Rechten das Skript läuft. (Tipp: T3-03 Prüfung 5)

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T3-05** sollten alle Punkte grün sein.

### Abnahmekriterien

- `/usr/local/sbin/firma-backup` existiert, gehört `root:root` und hat die Rechte `755`.
- Die erste Zeile des Skripts ist `#!/bin/bash`.
- Das Skript erzeugt eine Sicherung in `/srv/backup` (siehe T3-04).

## ⭐⭐ Erweiterung: Variablen und Rückgabewerte

### Variablen

Pfade, die mehrfach vorkommen, schreibt man einmal oben ins Skript.

1. Ändert `~/firma-backup` so, dass es oben drei Variablen gibt:

   ```bash
   QUELLE=/srv/firma
   ZIEL=/srv/backup
   DATEI="$ZIEL/firma-$(date +%F_%H%M).tar.gz"
   ```

2. Ersetzt im restlichen Skript alle Pfade durch `$QUELLE`, `$ZIEL` und `$DATEI`. Gebt am Ende den Namen und die Größe der neuen Sicherung aus (`ls -lh "$DATEI"`).
3. Achtung: Rund um das `=` darf **kein** Leerzeichen stehen. Probiert in der Shell aus, was bei `QUELLE = /srv/firma` passiert.
4. Welches Problem aus Schritt 4 der Pflicht löst das neue Datumsformat?

### Rückgabewerte

Jedes Kommando liefert beim Beenden einen **Rückgabewert** (*Exit Status*): `0` bedeutet Erfolg, alles andere einen Fehler. Er steht direkt danach in der Variablen `$?`.

1. Probiert es aus: `ls /srv` und danach `echo $?`. Dann `ls /gibtsnicht` und `echo $?`.
2. Startet euer Skript **ohne** `sudo` und lasst euch direkt danach `$?` anzeigen. Liefert das Skript einen Fehler?
3. Hängt testweise als **letzte** Zeile `echo "Ende."` an das Skript an. Startet es wieder ohne `sudo` und prüft `$?`. Was hat sich geändert – obwohl `tar` genauso scheitert wie vorher?
4. Ein Skript liefert den Rückgabewert seines **letzten** Kommandos. Erklärt damit das Ergebnis von Punkt 2 und 3. Entfernt die Zeile `echo "Ende."` wieder.

Kopiert die neue Fassung nach `/usr/local/sbin/firma-backup` und prüft die Rechte erneut.

## ⭐⭐⭐ Profi: Bedingungen, Schleifen und Argumente

1. Baut nach dem `tar`-Aufruf eine Prüfung ein, die eine verständliche Meldung ausgibt und das Skript mit einem Fehler beendet, wenn `tar` gescheitert ist:

   ```bash
   if [ $? -ne 0 ]; then
       echo "FEHLER: Sicherung fehlgeschlagen!" >&2
       exit 1
   fi
   ```

   Was bedeutet `>&2`? Testet das Skript mit und ohne `sudo` und prüft jeweils `$?`.
2. Grete möchte die Abteilungen **einzeln** wiederherstellen können. Ersetzt das eine `tar` durch eine `for`-Schleife, die für jede Abteilung ein eigenes Archiv anlegt:

   ```bash
   for ABTEILUNG in geschaeftsfuehrung vertrieb entwicklung buchhaltung austausch; do
       tar -czf "$ZIEL/$ABTEILUNG-$(date +%F_%H%M).tar.gz" "$QUELLE/$ABTEILUNG"
   done
   ```

3. Schreibt ein zweites Skript `~/log-bericht`, das die Logdatei aus T3-02 auswertet. Der Dateiname wird beim Aufruf übergeben (`./log-bericht pinguin-dev-auth.log`) und steht im Skript in `$1`. Das Skript gibt aus:
   - die Anzahl der Fehlversuche,
   - die Top 5 der angreifenden IP-Adressen,
   - alle erfolgreichen Anmeldungen.
4. Was passiert, wenn man `./log-bericht` ohne Dateinamen aufruft? Fangt den Fall mit `if [ -z "$1" ]` ab und gebt eine Gebrauchsanweisung aus.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- Ein Skript braucht das `x`-Recht, um mit `./name` gestartet zu werden. Alternativ: `bash name` (dann reicht `r`).
- Die erste Zeile `#!/bin/bash` sagt dem System, welches Programm das Skript ausführen soll.
- Suchpfad: Die Variable `PATH`, `man bash` (Suchbegriff `PATH`), `which`
- `sudo` verwendet einen eigenen, sicheren Suchpfad (`secure_path` in `/etc/sudoers`).
- Variablen: `NAME=wert` (ohne Leerzeichen), Zugriff mit `$NAME`, am besten in doppelten Anführungszeichen
- Rückgabewert: `$?`, Bedingungen: `help if`, `help test`, Schleifen: `help for`
- Argumente beim Aufruf: `$1`, `$2`, …

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
history | grep tar
nano ~/firma-backup
chmod u+x ~/firma-backup
./firma-backup
sudo ./firma-backup
echo $PATH
sudo sh -c 'echo $PATH'
sudo cp ~/firma-backup /usr/local/sbin/firma-backup
sudo chown root:root /usr/local/sbin/firma-backup
sudo chmod 755 /usr/local/sbin/firma-backup
which firma-backup
echo $?
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

**Schritt 1:** Die History liegt in `~/.bash_history` – jedes Konto hat seine eigene. Kommandos, die jemand anderes eingegeben hat, stehen nur in dessen History.

**Schritt 2:** Der Shebang `#!/bin/bash` legt fest, dass `/bin/bash` das Skript ausführt. Zeilen mit `#` sind Kommentare. Im Skript steht kein `sudo`, weil das ganze Skript mit `sudo` gestartet wird – alle Kommandos darin laufen dann als `root`.

**Schritt 3:**

```bash
./firma-backup               # Permission denied – kein x-Recht
ls -l ~/firma-backup         # -rw-rw-r--
chmod u+x ~/firma-backup
./firma-backup               # läuft, aber tar: … Permission denied
sudo ./firma-backup          # klappt
```

Das Skript braucht zwei Arten von Rechten: das `x`-Recht an der **Skriptdatei**, um es zu starten, und die Rechte für alles, was die **Kommandos darin** tun – hier Lesen in allen Abteilungsordnern und Schreiben in `/srv/backup`. Das hat nur `root`.

**Schritt 4:** Es gibt nur **eine** Sicherung von heute – der zweite Aufruf hat sie unter demselben Namen überschrieben. Ein Problem, wenn zwischen den Aufrufen etwas kaputtgegangen ist: Dann ist die gute Sicherung weg.

**Schritt 5:**

```bash
echo $PATH
sudo sh -c 'echo $PATH'      # u. a. /usr/local/sbin
sudo cp ~/firma-backup /usr/local/sbin/firma-backup
sudo chown root:root /usr/local/sbin/firma-backup
sudo chmod 755 /usr/local/sbin/firma-backup
cd /tmp && sudo firma-backup
which firma-backup
```

`/usr/local/sbin` ist für Admin-Programme gedacht, die nicht aus einem Paket stammen. `sudo` sucht dort immer (`secure_path`). Ob `which firma-backup` als normales Konto etwas findet, hängt davon ab, ob `/usr/local/sbin` im `PATH` des Kontos steht – auf Debian ist das bei normalen Konten meist **nicht** der Fall, bei `root` schon.

**Schritt 6:** Das Skript läuft mit `sudo`, also als `root`. Wer es ändern kann, kann beliebige Kommandos hineinschreiben, die beim nächsten Aufruf mit Root-Rechten laufen – zum Beispiel sich selbst in die Gruppe `sudo` aufnehmen. Ein für andere beschreibbares Skript, das `root` ausführt, ist eine Hintertür.

**⭐⭐:**

```bash
#!/bin/bash
# firma-backup – sichert die Firmenordner nach /srv/backup
# Aufruf: sudo firma-backup

QUELLE=/srv/firma
ZIEL=/srv/backup
DATEI="$ZIEL/firma-$(date +%F_%H%M).tar.gz"

echo "Sicherung von $QUELLE startet ..."
tar -czf "$DATEI" "$QUELLE"
echo "Sicherung fertig:"
ls -lh "$DATEI"
```

`QUELLE = /srv/firma` versucht, ein Kommando namens `QUELLE` mit den Argumenten `=` und `/srv/firma` zu starten: `QUELLE: command not found`. Mit Stunde und Minute im Namen überschreibt ein zweiter Aufruf am selben Tag die erste Sicherung nicht mehr.

`ls /srv` → `$?` ist `0`, `ls /gibtsnicht` → `2`. Ohne `sudo` scheitert `tar` – und zufällig scheitert auch das letzte Kommando `ls -lh "$DATEI"` (kein Zugriff auf `/srv/backup`), deshalb ist `$?` nicht `0`. Mit `echo "Ende."` am Schluss ist `$?` dagegen `0`, weil `echo` immer klappt: Das Skript meldet Erfolg, obwohl die Sicherung fehlt. Deshalb prüft man den Rückgabewert direkt nach dem wichtigen Kommando (⭐⭐⭐).

**⭐⭐⭐:** `>&2` leitet die Meldung auf die Standardfehlerausgabe um, wo Fehlermeldungen hingehören. Mit `exit 1` liefert das Skript einen Fehler, den z. B. ein anderes Skript prüfen kann.

```bash
#!/bin/bash
# log-bericht – wertet ein SSH-Anmeldeprotokoll aus
# Aufruf: ./log-bericht <logdatei>

if [ -z "$1" ]; then
    echo "Aufruf: $0 <logdatei>" >&2
    exit 1
fi

echo "Fehlversuche: $(grep -c 'Failed password' "$1")"
echo
echo "Top 5 der angreifenden IP-Adressen:"
grep 'Failed password' "$1" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -rn | head -n 5
echo
echo "Erfolgreiche Anmeldungen:"
grep Accepted "$1"
```

</details>
