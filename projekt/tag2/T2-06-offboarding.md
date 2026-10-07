# T2-06 – Offboarding

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Abschied von Oskar
>
> Hallo IT,
>
> leider verlässt uns Oskar Weber aus der Buchhaltung zum Monatsende. Bitte kümmert euch um sein Konto:
>
> - Peter Krause übernimmt seine Aufgaben und braucht dafür seine Dateien aus dem Buchhaltungsordner.
> - Sein Heimatverzeichnis bitte **archivieren** – wer weiß, ob wir noch etwas daraus brauchen.
> - Danach kann das Konto weg.
>
> Grete

Alle Schritte führt ihr **auf dem Server** aus.

> **Hinweis:** Nach diesem Ticket meldet das Check-Skript von **Tag 1** das Konto `oweber` als fehlend. Das ist richtig so.

## ⭐ Pflicht

### Schritt 1: Oskar hinterlässt Spuren

Damit es etwas zu finden gibt, arbeitet Oskar noch ein letztes Mal. Öffnet eine Shell als `oweber` und führt aus:

```bash
echo "Passwort fürs Bankportal: steht im Tresor" > ~/notizen.txt
mkdir ~/belege
echo "Beleg 001: Büromaterial" > ~/belege/beleg-001.txt
echo "Jahresabschluss 2026 – Entwurf" > /srv/firma/buchhaltung/jahresabschluss-2026.txt
echo "Danke für alles! Kuchen am Freitag. Oskar" > /srv/firma/austausch/abschied.txt
exit
```

### Schritt 2: Alle Dateien von Oskar finden

1. Sucht mit `find` im **gesamten** Dateisystem alle Dateien und Verzeichnisse, die `oweber` gehören. Ihr braucht `sudo`. Leitet die Fehlermeldungen nach `/dev/null` um.
2. Notiert im Logbuch, in welchen Verzeichnissen ihr Dateien von Oskar gefunden habt. Es sollten **drei** Orte sein.
3. Sucht mit `find` nur nach den Dateien, die Oskar **außerhalb** seines Heimatverzeichnisses gehören. Tipp: Sucht nur unter `/srv`.

### Schritt 3: Dateien an Peter übergeben

1. Übergebt `/srv/firma/buchhaltung/jahresabschluss-2026.txt` an `pkrause`. Die Gruppe bleibt `buchhaltung`.
2. Prüft mit `ls -l /srv/firma/buchhaltung`.
3. Peter testet: Er öffnet eine Shell als `pkrause` und hängt eine Zeile an die Datei an.

### Schritt 4: Heimatverzeichnis archivieren

1. Legt das Verzeichnis `/srv/archiv` an. Es darf nur `root` hinein: Besitzer `root:root`, Rechte `700`.
2. Packt das komplette Heimatverzeichnis von Oskar mit `tar` in das komprimierte Archiv `/srv/archiv/oweber-home.tar.gz`.
3. Lasst euch den Inhalt des Archivs mit `tar` anzeigen, **ohne** es auszupacken. Sind `notizen.txt` und `belege/beleg-001.txt` enthalten?
4. Notiert die Meldung, die `tar` beim Packen ausgibt (falls es eine gibt), und erklärt sie.

### Schritt 5: Konto löschen

1. Notiert mit `id oweber` Oskars **UID**. Ihr braucht sie gleich.
2. Löscht das Konto **mit** Heimatverzeichnis. Sucht in `man userdel` die passende Option.
3. Prüft:
   - `id oweber` – Was meldet das System?
   - `ls /home` – Ist das Heimatverzeichnis weg?
   - `grep oweber /etc/group` – Ist Oskar aus allen Gruppen verschwunden? Gibt es seine private Gruppe noch?

### Schritt 6: Was übrig bleibt

1. Lasst euch mit `ls -l /srv/firma/austausch` den Ordner anzeigen. Wer steht bei `abschied.txt` als Besitzer? Erklärt die Anzeige.
2. Sucht mit `find` im gesamten Dateisystem alle Dateien, die **keinem existierenden Konto** gehören (Suchbegriff in `man find`: `nouser`).
3. Gebt die Abschiedsnachricht an Peter Krause weiter (`chown`), damit sie nicht herrenlos bleibt.
4. Führt die Suche aus Punkt 2 erneut aus. Erwartet wird keine Ausgabe.

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T2-06** sollten alle Punkte grün sein.

### Abnahmekriterien

- Das Konto `oweber` und sein Heimatverzeichnis existieren nicht mehr.
- Das Archiv `/srv/archiv/oweber-home.tar.gz` existiert und enthält das Heimatverzeichnis.
- `/srv/archiv` gehört `root:root` und hat die Rechte `700`.
- `jahresabschluss-2026.txt` gehört `pkrause:buchhaltung`.
- Unter `/srv` gibt es keine Dateien ohne existierenden Besitzer.

## ⭐⭐ Erweiterung: Das Archiv prüfen

Eine Datensicherung ist erst etwas wert, wenn man sie wiederherstellen kann.

1. Legt das Verzeichnis `/root/wiederherstellung` an und packt das Archiv dorthin aus. Sucht in `man tar` die Option, mit der man das Zielverzeichnis angibt.
2. Lasst euch mit `sudo ls -lR /root/wiederherstellung` die ausgepackten Dateien anzeigen. Wer steht dort als Besitzer und Gruppe?
3. Lasst euch dieselben Dateien mit `sudo ls -lnR /root/wiederherstellung` anzeigen. Was zeigt die Option `-n`? Vergleicht mit der UID, die ihr in Schritt 5 notiert habt.
4. Erklärt im Logbuch: Was speichert `tar` im Archiv – den **Namen** oder die **Nummer** des Besitzers? (Erinnert euch an T1-03 ⭐⭐⭐.)

Lasst das Verzeichnis `/root/wiederherstellung` für ⭐⭐⭐ stehen.

## ⭐⭐⭐ Profi: Wenn eine UID wiederverwendet wird

1. Legt ein Testkonto an, das **dieselbe UID** bekommt, die Oskar hatte:

   ```bash
   sudo useradd -u <oskars-uid> -m utest
   ```

2. Lasst euch erneut `sudo ls -lR /root/wiederherstellung` anzeigen. Wem gehören Oskars Dateien jetzt?
3. Überlegt: Was wäre passiert, wenn ihr in Schritt 6 der Pflicht `abschied.txt` nicht an Peter übergeben hättet? Was, wenn dort vertrauliche Unterlagen gelegen hätten?
4. Lest in `man useradd` den Abschnitt zur Option `-u`. Vergibt `useradd` freigewordene UIDs automatisch wieder? Testet es: Löscht `utest` und legt ein Konto `vtest` **ohne** `-u` an. Welche UID bekommt es?
5. Notiert im Logbuch zwei Regeln für das Offboarding, die solche Probleme verhindern.
6. Räumt auf: Löscht die Testkonten mit ihren Heimatverzeichnissen und das Verzeichnis `/root/wiederherstellung`.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- Dateien nach Besitzer suchen: `man find`, Suchbegriffe `-user` und `-nouser`
- Besitzer ändern: `man chown`
- Archive: `man tar` – Optionen zum Erstellen (`-c`), Auflisten (`-t`), Auspacken (`-x`), für `gzip` (`-z`), für den Archivnamen (`-f`) und für das Zielverzeichnis (`-C`)
- Konten löschen: `man userdel`
- Rechte von Ordnern: siehe T2-01 und T2-02

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
sudo find / -user oweber 2>/dev/null
sudo find /srv -user oweber
sudo chown pkrause <datei>
sudo mkdir /srv/archiv
sudo chmod 700 /srv/archiv
sudo tar -czf /srv/archiv/oweber-home.tar.gz /home/oweber
sudo tar -tzf /srv/archiv/oweber-home.tar.gz
id oweber
sudo userdel -r oweber
sudo find / -nouser 2>/dev/null
sudo tar -xzf <archiv> -C <zielverzeichnis>
ls -ln
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

```bash
# Schritt 2
sudo find / -user oweber 2>/dev/null
sudo find /srv -user oweber

# Schritt 3
sudo chown pkrause /srv/firma/buchhaltung/jahresabschluss-2026.txt
ls -l /srv/firma/buchhaltung

# Schritt 4
sudo mkdir /srv/archiv
sudo chmod 700 /srv/archiv
sudo tar -czf /srv/archiv/oweber-home.tar.gz /home/oweber
sudo tar -tzf /srv/archiv/oweber-home.tar.gz

# Schritt 5
id oweber
sudo userdel -r oweber
id oweber
ls /home
grep oweber /etc/group

# Schritt 6
ls -l /srv/firma/austausch
sudo find / -nouser 2>/dev/null
sudo chown pkrause /srv/firma/austausch/abschied.txt
sudo find / -nouser 2>/dev/null
```

**Schritt 2:** Oskars Dateien liegen in `/home/oweber` (samt Unterverzeichnis `belege` und den Dateien aus `/etc/skel`), in `/srv/firma/buchhaltung` und in `/srv/firma/austausch`. Beim Suchen in `/` durchsucht `find` auch `/proc` – die Fehlermeldungen von dort verschwinden mit `2>/dev/null`.

**Schritt 3:** `chown` mit nur einem Benutzernamen ändert nur den Besitzer, die Gruppe bleibt `buchhaltung`. Besitzer ändern darf nur `root` – deshalb braucht ihr hier `sudo`, auch wenn die Datei im Ordner von Peters Abteilung liegt.

**Schritt 4:** `tar` meldet `Removing leading '/' from member names` (sinngemäß auf Deutsch). Die Pfade werden im Archiv **relativ** gespeichert (`home/oweber/…`), damit beim Auspacken nicht versehentlich das echte `/home/oweber` überschrieben wird.

**Schritt 5:** `id` meldet `no such user`. `userdel -r` löscht das Heimatverzeichnis und den Mail-Spool. Die Meldung, dass kein Mail-Spool gefunden wurde, ist harmlos. Oskar wird aus allen Gruppen ausgetragen, seine private Gruppe `oweber` wird gelöscht.

**Schritt 6:** `ls -l` zeigt bei `abschied.txt` statt eines Namens eine **Zahl** – Oskars alte UID. Das Dateisystem speichert nur die Nummer. `ls` findet zu dieser Nummer keinen Eintrag mehr in `/etc/passwd` und zeigt deshalb die Zahl an. `find / -nouser` findet genau solche Dateien.

**⭐⭐:**

```bash
sudo mkdir /root/wiederherstellung
sudo tar -xzf /srv/archiv/oweber-home.tar.gz -C /root/wiederherstellung
sudo ls -lR /root/wiederherstellung
sudo ls -lnR /root/wiederherstellung
```

`root` stellt beim Auspacken die ursprünglichen Besitzer wieder her. Da es `oweber` nicht mehr gibt, erscheinen Zahlen. `-n` zeigt UID und GID immer als Zahlen. `tar` speichert zwar zusätzlich den Namen, beim Auspacken wird aber die passende Nummer auf **diesem** System verwendet – und gibt es den Namen nicht, die gespeicherte Nummer.

**⭐⭐⭐:** Mit `useradd -u <uid>` gehören `utest` plötzlich alle Dateien, die noch Oskars UID tragen – im ausgepackten Archiv und überall, wo `find -nouser` vorher etwas gefunden hätte. `useradd` vergibt standardmäßig die nächste UID **über** der höchsten bereits vergebenen. Oskars UID liegt in der Mitte – nach ihm wurde u. a. noch `mneumann` angelegt –, deshalb bekommt `vtest` eine neue, höhere UID. Wird aber das Konto mit der **höchsten** UID gelöscht, vergibt das nächste `useradd` genau diese Nummer sofort wieder.

Regeln für das Offboarding:

1. **Vor** dem Löschen eines Kontos alle Dateien mit `find -user` suchen und übergeben oder archivieren.
2. **Nach** dem Löschen mit `find -nouser` prüfen, dass nichts herrenlos zurückbleibt – bevor ein neues Konto angelegt wird.

```bash
sudo userdel -r utest      # falls noch vorhanden
sudo userdel -r vtest
sudo rm -r /root/wiederherstellung
```

</details>
