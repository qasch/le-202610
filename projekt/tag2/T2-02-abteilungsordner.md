# T2-02: Abteilungsordner

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Endlich gemeinsame Ordner
>
> Hallo IT,
>
> bisher schicken wir uns Dateien per Mail hin und her. Das soll aufhören: Jede Abteilung bekommt auf dem Server einen gemeinsamen Ordner unter `/srv/firma`.
>
> - In einen Abteilungsordner kommt nur, wer zur Abteilung gehört. Gerade die Buchhaltung ist da sehr empfindlich.
> - Innerhalb der Abteilung sollen alle die Dateien der anderen lesen **und bearbeiten** können. Wenn Lena krank ist, muss Sofia an ihren Angeboten weiterarbeiten können.
>
> Grete

Alle Schritte führt ihr **auf dem Server** aus. Die Ordner gehören `root`, die Abteilungen arbeiten darin über ihre **Gruppe**.

## Pflicht

### Schritt 1: Ordner anlegen

1. Legt mit **einem** Kommando die Ordner `/srv/firma/geschaeftsfuehrung`, `/srv/firma/vertrieb`, `/srv/firma/entwicklung` und `/srv/firma/buchhaltung` an. Tipp: Klammererweiterung (*Brace Expansion*) mit `{…,…}` und die Option von `mkdir`, die fehlende übergeordnete Verzeichnisse mit anlegt.
2. Prüft mit `ls -ld /srv/firma /srv/firma/*`. Notiert Besitzer, Gruppe und Rechte.

### Schritt 2: Gruppen zuweisen

1. Weist jedem Abteilungsordner die passende Gruppe zu, z. B. `/srv/firma/vertrieb` die Gruppe `vertrieb`. Der Besitzer bleibt `root`.
2. Prüft mit `ls -ld /srv/firma/*`: In der Spalte für die Gruppe muss jetzt jeweils die Abteilung stehen.

### Schritt 3: Rechte setzen

1. Überlegt: Besitzer und Gruppe sollen alles dürfen, alle anderen nichts. Welche Oktalzahl ist das?
2. Setzt diese Rechte für alle vier Abteilungsordner.
3. Prüft mit `ls -ld /srv/firma/*`. Erwartet wird `drwxrwx---`.

### Schritt 4: Erster Test

1. Öffnet eine Shell als `lwagner` und legt eine Datei im Vertriebsordner an:

   ```bash
   echo "Angebot für Kunde Eisbär AG" > /srv/firma/vertrieb/angebot-1.txt
   ls -l /srv/firma/vertrieb
   ```

2. Notiert Besitzer, **Gruppe** und Rechte der neuen Datei.
3. Notiert außerdem die Ausgabe von `umask`. Ihr braucht sie in Erweiterung. Kehrt mit `exit` zurück.
4. Öffnet eine Shell als `mkaya` und versucht, an die Datei eine Zeile anzuhängen:

   ```bash
   echo "Rabatt: 10 %" >> /srv/firma/vertrieb/angebot-1.txt
   ```

5. Notiert das Ergebnis. Erklärt mithilfe der Gruppe der Datei, warum Murat sie nicht bearbeiten darf, obwohl er im Vertrieb ist. Kehrt mit `exit` zurück.

### Schritt 5: Das SGID-Bit

Neue Dateien sollen automatisch der **Gruppe des Ordners** gehören, nicht der privaten Gruppe der Person. Dafür gibt es das **SGID-Bit** (*Set Group ID*) an einem Verzeichnis.

1. Setzt das SGID-Bit an allen vier Abteilungsordnern. Ihr könnt es symbolisch (`g+s`) oder oktal (eine `2` vor den drei Ziffern) setzen.
2. Prüft mit `ls -ld /srv/firma/*`. Erwartet wird `drwxrws---`. Wo genau erkennt ihr das SGID-Bit?

### Schritt 6: Zweiter Test

1. Lena legt eine zweite Datei an: `echo "Angebot für Kunde Robbe KG" > /srv/firma/vertrieb/angebot-2.txt`
2. Prüft mit `ls -l /srv/firma/vertrieb`: Welcher Gruppe gehört `angebot-2.txt`, welcher `angebot-1.txt`?
3. Schaut euch die Rechte von `angebot-2.txt` an. Erwartet wird `-rw-rw-r--`: Die **Gruppe** darf schreiben.
4. Murat hängt wie in Schritt 4 eine Zeile an `angebot-2.txt` an. Klappt es jetzt? Prüft mit `cat`.

### Schritt 7: Die alte Datei reparieren

`angebot-1.txt` gehört noch Lenas privater Gruppe. Das SGID-Bit wirkt nur auf **neue** Dateien.

1. Lena ändert die Gruppe ihrer Datei auf `vertrieb`, **ohne** `sudo`. Sucht das passende Kommando und probiert es aus. Warum darf sie das?
2. Murat hängt seine Zeile an. Prüft mit `ls -l` und `cat`.

### Schritt 8: Wer kommt wohin?

Testet die folgenden Fälle. Versucht jeweils, den Ordner aufzulisten (`ls`) und eine Datei anzulegen (`touch <ordner>/test-<benutzer>.txt`). Füllt die Tabelle im Logbuch aus:

| Person | Ordner | `ls` | `touch` | Warum? |
|---|---|---|---|---|
| `lwagner` | `/srv/firma/entwicklung` | | | |
| `mkaya` | `/srv/firma/entwicklung` | | | |
| `jbecker` | `/srv/firma/buchhaltung` | | | |
| `pkrause` | `/srv/firma/buchhaltung` | | | |
| `gfrost` | `/srv/firma/vertrieb` | | | |

Löscht die angelegten Testdateien anschließend wieder (als die jeweilige Person).

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T2-02** sollten alle Punkte grün sein.

### Abnahmekriterien

- `/srv/firma` gehört `root:root` und hat die Rechte `755`.
- Die vier Abteilungsordner gehören dem Besitzer `root` und der jeweiligen Abteilungsgruppe.
- Die Abteilungsordner haben die Rechte `2770` (`drwxrws---`).

> Grete Frost kommt jetzt nicht in die Abteilungsordner. Darum geht es im Bonus-Ticket **T2-04**.

## Erweiterung: Die `umask`

Warum hat eine neue Datei `rw-rw-r--` und nicht `rwxrwxrwx`? Das bestimmt die **umask**.

1. Lest in `help umask` nach, was das Kommando tut.
2. Führt `umask` und `umask -S` in eurem **eigenen** Admin-Konto aus und vergleicht mit dem Wert, den ihr in Schritt 4 bei Lena notiert habt.
3. Probiert in eurem Heimatverzeichnis aus, wie die umask die Rechte neuer Dateien und Verzeichnisse beeinflusst. Die runden Klammern starten eine Subshell, damit die geänderte umask danach nicht weiter gilt:

   ```bash
   (umask 022; touch datei-022; mkdir ordner-022)
   (umask 002; touch datei-002; mkdir ordner-002)
   (umask 077; touch datei-077; mkdir ordner-077)
   ls -ld datei-* ordner-*
   ```

4. Füllt die Tabelle aus:

   | umask | neue Datei | neues Verzeichnis |
   |---|---|---|
   | `022` | | |
   | `002` | | |
   | `077` | | |

5. Erklärt im Logbuch: Von welchen Ausgangsrechten (für Dateien und für Verzeichnisse) zieht die umask etwas ab? Warum bekommt eine neue Datei nie das `x`-Recht?
6. Welche umask wäre für die Arbeit in den Abteilungsordnern sinnvoll, und warum ist `000` keine gute Idee?
7. Räumt auf: `rm -r datei-* ordner-*`

## Profi: Verschieben, Kopieren, Unterordner

1. Lena legt in ihrem **Heimatverzeichnis** die Datei `entwurf.txt` an und **verschiebt** sie mit `mv` in den Vertriebsordner.
2. Lena legt eine zweite Datei `entwurf2.txt` im Heimatverzeichnis an und **kopiert** sie mit `cp` in den Vertriebsordner.
3. Vergleicht mit `ls -l /srv/firma/vertrieb` die Gruppen der beiden Dateien. Erklärt den Unterschied: Wann wird eine Datei **neu angelegt**, wann bleibt sie dieselbe Datei?
4. Lena legt den Unterordner `/srv/firma/vertrieb/kunden` an. Prüft mit `ls -ld`: Welche Gruppe hat er, und hat er ebenfalls das SGID-Bit? Warum ist das praktisch?
5. Notiert im Logbuch eine Regel für die Mitarbeitenden, die Dateien in einen Abteilungsordner bringen wollen.
6. Räumt die Dateien `entwurf*.txt` und den Ordner `kunden` wieder auf.

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Übergeordnete Verzeichnisse anlegen: `man mkdir` (Suchbegriff `parents`)
- Gruppe ändern: `man chgrp`, oder `man chown` (Schreibweise `:gruppe`)
- SGID-Bit: `man chmod`, Abschnitt zu den speziellen Bits (Suchbegriff `set-group-ID`)
- Ein Besitzer darf die Gruppe seiner Datei auf jede Gruppe ändern, in der er selbst Mitglied ist.
- umask: `help umask` (die umask ist ein Shell-Builtin, deshalb `help` statt `man`)

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
sudo mkdir -p /srv/firma/{geschaeftsfuehrung,vertrieb,entwicklung,buchhaltung}
sudo chgrp <gruppe> <ordner>
sudo chmod 770 <ordner> ...
sudo chmod g+s <ordner> ...        oder   sudo chmod 2770 <ordner> ...
ls -ld /srv/firma/*
sudo -iu <benutzer>
chgrp vertrieb <datei>
umask
umask -S
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

```bash
# Schritt 1 bis 3
sudo mkdir -p /srv/firma/{geschaeftsfuehrung,vertrieb,entwicklung,buchhaltung}
for abteilung in geschaeftsfuehrung vertrieb entwicklung buchhaltung; do
	sudo chgrp "$abteilung" "/srv/firma/$abteilung"
done
sudo chmod 770 /srv/firma/{geschaeftsfuehrung,vertrieb,entwicklung,buchhaltung}
ls -ld /srv/firma /srv/firma/*

# Schritt 4
sudo -iu lwagner
echo "Angebot für Kunde Eisbär AG" > /srv/firma/vertrieb/angebot-1.txt
ls -l /srv/firma/vertrieb
umask
exit

sudo -iu mkaya
echo "Rabatt: 10 %" >> /srv/firma/vertrieb/angebot-1.txt   # Permission denied
exit

# Schritt 5
sudo chmod 2770 /srv/firma/{geschaeftsfuehrung,vertrieb,entwicklung,buchhaltung}
ls -ld /srv/firma/*

# Schritt 6 und 7 (als lwagner bzw. mkaya)
echo "Angebot für Kunde Robbe KG" > /srv/firma/vertrieb/angebot-2.txt
chgrp vertrieb /srv/firma/vertrieb/angebot-1.txt
```

Die vier `chgrp`-Aufrufe könnt ihr natürlich auch einzeln eintippen.

**Schritt 4:** Die neue Datei gehört `lwagner` und der **privaten Gruppe** `lwagner`. Für Murat ist sie deshalb eine Datei von „anderen“, und die dürfen höchstens lesen. Dass Murat in den **Ordner** darf, hilft ihm nicht: Das Recht, eine Datei zu ändern, hängt an der Datei selbst.

**Schritt 5:** `drwxrws---`. Das `s` an der Stelle des `x` der Gruppe zeigt das SGID-Bit. Steht dort ein großes `S`, ist das SGID-Bit gesetzt, aber das `x` für die Gruppe fehlt.

**Schritt 6:** `angebot-2.txt` gehört jetzt der Gruppe `vertrieb`. Wegen Lenas umask `0002` hat sie `rw-rw-r--`. Die Gruppe darf schreiben, also auch Murat.

**Schritt 7:** `chgrp vertrieb angebot-1.txt`. Als Besitzerin darf Lena die Gruppe auf jede Gruppe ändern, in der sie Mitglied ist. Auf eine fremde Gruppe (z. B. `buchhaltung`) dürfte sie das nicht.

**Schritt 8:**

| Person | Ordner | `ls` | `touch` | Warum? |
|---|---|---|---|---|
| `lwagner` | `entwicklung` | nein | nein | nicht in der Gruppe, also gilt `others` mit `---` |
| `mkaya` | `entwicklung` | ja | ja | Mitglied von `entwicklung` (T1-05) |
| `jbecker` | `buchhaltung` | nein | nein | nicht in der Gruppe |
| `pkrause` | `buchhaltung` | ja | ja | Mitglied von `buchhaltung` |
| `gfrost` | `vertrieb` | nein | nein | nur in `geschaeftsfuehrung` |

**Erweiterung:** Die umask gibt an, welche Rechte **weggenommen** werden. Ausgangspunkt ist `666` für Dateien und `777` für Verzeichnisse. Neue Dateien bekommen nie `x`, weil eine frisch angelegte Datei fast nie ein Programm ist. Das `x` setzt man bewusst mit `chmod +x`.

| umask | neue Datei | neues Verzeichnis |
|---|---|---|
| `022` | `644` (`rw-r--r--`) | `755` (`rwxr-xr-x`) |
| `002` | `664` (`rw-rw-r--`) | `775` (`rwxrwxr-x`) |
| `077` | `600` (`rw-------`) | `700` (`rwx------`) |

Für gemeinsame Ordner ist `002` sinnvoll: Die Gruppe darf mitschreiben. `000` würde jeder Person auf dem System Schreibrecht an allen neuen Dateien geben.

Die umask `0002` kommt aus `/etc/login.defs`: Dort steht meist `UMASK 022`, aber wegen `USERGROUPS_ENAB yes` wird für Konten mit eigener privater Gruppe die Gruppenstelle an die Besitzerstelle angeglichen, aus `022` wird `002`. Das ist ungefährlich: In der privaten Gruppe ist nur die Person selbst. Erst in einem Ordner mit SGID-Bit wird daraus ein Schreibrecht für die ganze Abteilung, genau das, was Grete wollte.

**Profi:** `mv` innerhalb desselben Dateisystems verschiebt nur den Verzeichniseintrag. Die Datei bleibt dieselbe und behält Besitzer, Gruppe (`lwagner`) und Rechte. `cp` legt eine **neue** Datei an, die das SGID-Bit des Ordners berücksichtigt und deshalb der Gruppe `vertrieb` gehört. Neue Unterordner erben das SGID-Bit, sodass die Regel im ganzen Baum gilt. Regel für die Mitarbeitenden: „Dateien in den Abteilungsordner **kopieren**, nicht verschieben, oder danach mit `chgrp` die Gruppe anpassen.“

</details>
