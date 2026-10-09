# T2-05: Verknüpfungen: Symlinks und Hardlinks

> **Von:** Nina Schulz (Entwicklung)
> **Betreff:** Abkürzung gesucht
>
> Hallo IT,
>
> der neue Abteilungsordner ist toll, aber ich tippe jedes Mal `cd /srv/firma/entwicklung`. Unter Windows hatte ich eine Verknüpfung auf dem Desktop. Gibt es so etwas auch bei Linux?
>
> Und Tim behauptet, man könne bei Linux eine Datei an zwei Orten **gleichzeitig** haben, ohne sie zu kopieren. Stimmt das?
>
> Nina

Alle Schritte führt ihr **auf dem Server** aus.

## Pflicht: Eine Abkürzung für Nina

### Schritt 1: Symlink anlegen

1. Öffnet eine Shell als `nschulz`.
2. Legt in Ninas Heimatverzeichnis einen **symbolischen Link** mit dem Namen `abteilung` an, der auf `/srv/firma/entwicklung` zeigt. Achtet auf die Reihenfolge der Argumente bei `ln`: zuerst das **Ziel**, dann der **Name** des Links.
3. Prüft mit `ls -l ~`. Notiert die Zeile des Links im Logbuch. Woran erkennt ihr, dass es ein Link ist (zwei Merkmale)?

### Schritt 2: Den Link benutzen

1. Wechselt mit `cd ~/abteilung` in den Link.
2. Führt `pwd` und `pwd -P` aus. Notiert beide Ausgaben. Was ist der Unterschied?
3. Legt über den Link eine Datei an: `echo "Sprint-Planung" > ~/abteilung/sprint.txt`
4. Prüft mit `ls -l /srv/firma/entwicklung`: Wo ist die Datei tatsächlich gelandet?
5. Kehrt mit `cd` ins Heimatverzeichnis zurück und mit `exit` zu eurem Konto.

### Schritt 3: Die Rechte eines Symlinks

Der Link hat die Rechte `rwxrwxrwx`. Darf jetzt jede Person über einen solchen Link in die Entwicklung?

1. Öffnet eine Shell als `lwagner`. Lena legt sich selbst einen Link auf den Ordner der Entwicklung an:

   ```bash
   ln -s /srv/firma/entwicklung ~/spion
   ls -l ~/spion
   ```

   Klappt das Anlegen?
2. Lena versucht, über den Link hineinzuschauen: `ls ~/spion/` (mit Schrägstrich am Ende).
3. Notiert im Logbuch: Welche Rechte entscheiden über den Zugriff: die des Links oder die des Ziels?
4. Lena löscht ihren Link wieder: `rm ~/spion` (**ohne** Schrägstrich am Ende).

### Schritt 4: Ein kaputter Link

1. Öffnet eine Shell als `nschulz` und legt einen zweiten Link an, der auf ein Ziel zeigt, das es **nicht** gibt:

   ```bash
   ln -s /srv/firma/entwicklungg ~/tippfehler
   ls -l ~
   ```

2. Klappt das Anlegen? Wie stellt `ls` den Link dar? Was passiert bei `cd ~/tippfehler`?
3. Löscht den kaputten Link wieder.

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T2-05** sollten alle Punkte grün sein.

### Abnahmekriterien

- In `/home/nschulz` gibt es den symbolischen Link `abteilung`, der auf `/srv/firma/entwicklung` zeigt.
- Der Link gehört `nschulz`.
- Lenas Link `spion` und Ninas Link `tippfehler` sind wieder gelöscht.

## Erweiterung: Hardlinks, eine Datei mit zwei Namen

Tim hat recht. Das findet ihr jetzt heraus. Arbeitet mit eurem **eigenen** Admin-Konto in eurem Heimatverzeichnis.

### Schritt 1: Drei Namen anlegen

```bash
echo "Version 1" > original.txt
ln original.txt hardlink.txt
ln -s original.txt symlink.txt
ls -li original.txt hardlink.txt symlink.txt
```

1. Füllt die Tabelle im Logbuch aus. Die Inode-Nummer steht ganz vorne, der Linkzähler ist die Zahl direkt nach den Rechten.

   | Name | Inode-Nummer | Dateityp (erstes Zeichen) | Linkzähler | Größe |
   |---|---|---|---|---|
   | `original.txt` | | | | |
   | `hardlink.txt` | | | | |
   | `symlink.txt` | | | | |

2. Welche beiden Namen haben dieselbe Inode-Nummer? Was bedeutet das?
3. Die Größe von `symlink.txt` ist 12 Byte. Zählt die Zeichen von `original.txt`. Was speichert ein Symlink also?

### Schritt 2: Ändern

1. Ändert den Inhalt über den Hardlink: `echo "Version 2" > hardlink.txt`
2. Lest `original.txt` und `symlink.txt` mit `cat`. Was steht drin?
3. Ändert mit `chmod 600 hardlink.txt` die Rechte. Prüft mit `ls -li`: Bei welchen Namen haben sich die Rechte geändert?

### Schritt 3: Das Original löschen

1. Löscht `original.txt`.
2. Führt `ls -li hardlink.txt symlink.txt` aus. Wie hat sich der Linkzähler von `hardlink.txt` verändert? Wie wird `symlink.txt` jetzt dargestellt?
3. Versucht `cat hardlink.txt` und `cat symlink.txt`.
4. Füllt im Logbuch aus:

   | | Symlink | Hardlink |
   |---|---|---|
   | Was ist es? | | |
   | Eigene Inode? | | |
   | Was passiert, wenn das Original gelöscht wird? | | |
   | Wann wird die Datei wirklich gelöscht? | | |

5. Räumt auf: `rm hardlink.txt symlink.txt`

### Schritt 4: Der Linkzähler von Verzeichnissen

1. Führt `ls -ld /srv/firma` aus und notiert den Linkzähler.
2. Zählt die Unterverzeichnisse von `/srv/firma`.
3. Findet eine Regel: Wie hängt der Linkzähler eines Verzeichnisses mit der Zahl seiner Unterverzeichnisse zusammen? Tipp: `ls -la /srv/firma/vertrieb`. Was bedeuten die Einträge `.` und `..`?

## Profi: Grenzen von Hardlinks

Arbeitet weiter mit eurem eigenen Admin-Konto.

1. Versucht, einen Hardlink auf ein **Verzeichnis** anzulegen: `ln /srv/firma ~/firma-hardlink`. Notiert die Meldung.
2. Lasst euch mit `df ~ /dev/shm` anzeigen, auf welchen Dateisystemen euer Heimatverzeichnis und `/dev/shm` liegen.
3. Legt eine Datei an und versucht einen Hardlink nach `/dev/shm`:

   ```bash
   echo "Test" > ~/grenze.txt
   ln ~/grenze.txt /dev/shm/grenze.txt
   ```

   Notiert die Meldung. Erklärt mithilfe der Inode-Nummer, warum ein Hardlink nicht über Dateisystemgrenzen hinweg funktionieren **kann**.
4. Probiert dasselbe mit einem Symlink (`ln -s`). Klappt es? Räumt danach auf (`/dev/shm/grenze.txt` und `~/grenze.txt`).
5. Auf aktuellen Debian-Systemen sind manche Verzeichnisse im Wurzelverzeichnis selbst Symlinks. Findet sie mit `ls -l /` und notiert, worauf sie zeigen.
6. Zählt mit `find /usr/bin -type l | wc -l`, wie viele Programme in `/usr/bin` eigentlich Symlinks sind. Lasst euch mit `ls -l /usr/bin/vi` und `readlink -f /usr/bin/vi` zeigen, wohin `vi` führt.

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Links anlegen: `man ln`. Ohne Option entsteht ein Hardlink, mit `-s` ein symbolischer Link.
- Inode-Nummern anzeigen: `man ls`, Option `-i`
- Den echten Pfad anzeigen: `help pwd` (Option `-P`), `man readlink`
- Ein **Hardlink** ist ein zusätzlicher Name für dieselbe Inode. Ein **Symlink** ist eine eigene kleine Datei, in der ein Pfad steht.

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
ln -s <ziel> <linkname>
ln <ziel> <linkname>
ls -l
ls -li
pwd -P
rm <linkname>
df
readlink -f <link>
find /usr/bin -type l
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

```bash
# Pflicht (als nschulz)
ln -s /srv/firma/entwicklung ~/abteilung
ls -l ~                  # lrwxrwxrwx … abteilung -> /srv/firma/entwicklung
cd ~/abteilung
pwd                      # /home/nschulz/abteilung
pwd -P                   # /srv/firma/entwicklung
echo "Sprint-Planung" > ~/abteilung/sprint.txt

# Schritt 3 (als lwagner)
ln -s /srv/firma/entwicklung ~/spion     # klappt
ls ~/spion/                              # Permission denied
rm ~/spion

# Schritt 4 (als nschulz)
ln -s /srv/firma/entwicklungg ~/tippfehler
rm ~/tippfehler
```

**Schritt 1:** Ein Symlink beginnt in `ls -l` mit einem `l`, und hinter dem Namen steht `-> ziel`.

**Schritt 2:** `pwd` zeigt den Weg, über den ihr gekommen seid, `pwd -P` das tatsächliche (*physische*) Verzeichnis. Die Datei landet in `/srv/firma/entwicklung` und gehört wegen des SGID-Bits der Gruppe `entwicklung`.

**Schritt 3:** Einen Link darf jede Person anlegen, auf jedes Ziel. Die Rechte eines Symlinks (`rwxrwxrwx`) spielen keine Rolle, entscheidend sind immer die Rechte des **Ziels**. Lena bleibt draußen. `rm ~/spion/` mit Schrägstrich würde sich auf das Ziel beziehen, deshalb ohne.

**Schritt 4:** `ln -s` prüft nicht, ob das Ziel existiert. `ls` zeigt den kaputten Link (je nach Farbschema rot) an, `cd` meldet `No such file or directory`.

**Erweiterung:**

| Name | Inode | Typ | Linkzähler | Größe |
|---|---|---|---|---|
| `original.txt` | z. B. 131090 | `-` | 2 | 10 |
| `hardlink.txt` | dieselbe | `-` | 2 | 10 |
| `symlink.txt` | eine andere | `l` | 1 | 12 |

`original.txt` und `hardlink.txt` sind **zwei Namen für dieselbe Datei** (dieselbe Inode). Deshalb sieht man jede Änderung des Inhalts und der Rechte unter beiden Namen. Es gibt kein „Original“ mehr, beide Namen sind gleichberechtigt. `symlink.txt` speichert nur den Pfad `original.txt` (12 Zeichen).

Nach dem Löschen von `original.txt` sinkt der Linkzähler von `hardlink.txt` auf 1, der Inhalt ist weiterhin da. `symlink.txt` zeigt ins Leere.

| | Symlink | Hardlink |
|---|---|---|
| Was ist es? | eigene Datei, die einen Pfad enthält | zusätzlicher Name für dieselbe Inode |
| Eigene Inode? | ja | nein |
| Original gelöscht | Link zeigt ins Leere | Inhalt bleibt erreichbar |
| Wirklich gelöscht | - | wenn der Linkzähler 0 ist und kein Programm die Datei mehr geöffnet hat |

**Linkzähler von Verzeichnissen:** 2 + Anzahl der Unterverzeichnisse. Jedes Verzeichnis wird über seinen Namen im übergeordneten Verzeichnis und über den eigenen Eintrag `.` gezählt, dazu kommt der Eintrag `..` jedes Unterverzeichnisses. `/srv/firma` mit fünf Unterverzeichnissen hat also den Linkzähler 7.

**Profi:** Hardlinks auf Verzeichnisse sind verboten (`hard link not allowed for directory`), weil sonst Schleifen im Verzeichnisbaum entstehen könnten. `/dev/shm` ist ein eigenes Dateisystem im Arbeitsspeicher (`tmpfs`). Eine Inode-Nummer gilt nur innerhalb **eines** Dateisystems, deshalb meldet `ln` `Invalid cross-device link`. Symlinks speichern nur einen Pfad und funktionieren daher auch über Dateisystemgrenzen hinweg. Auf aktuellen Debian-Versionen sind `/bin`, `/sbin` und `/lib` Symlinks in das Verzeichnis `/usr` (*usrmerge*). `vi` führt über mehrere Symlinks (u. a. `/etc/alternatives/vi`) zum tatsächlich installierten Editor.

</details>
