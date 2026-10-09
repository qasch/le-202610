# T1-03: Abteilungen vorbereiten

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Abteilungen
>
> Hallo IT,
>
> morgen sollen alle Abteilungen ihre eigenen Ordner auf dem Server bekommen. Dafür braucht ihr doch sicher die Abteilungen als Gruppen, oder? Die Liste findet ihr in der Firmenbeschreibung.
>
> Und: Wäre es nicht schön, wenn alle neuen Kolleginnen und Kollegen beim ersten Login eine kleine Begrüßung vorfinden?
>
> Grete

Alle Schritte führt ihr **auf dem Server** mit `sudo` aus.

## Pflicht

### Schritt 1: Gruppen anlegen

1. Schaut in der [Firmenbeschreibung](../00-pinguin-gmbh.md) nach, welche Gruppen es geben soll. Es sind **fünf** (vier Abteilungen und eine für alle).
2. Legt die fünf Gruppen an. Achtet auf die exakte Schreibweise: klein, ohne Umlaute.

### Schritt 2: Ergebnis prüfen

1. Gebt die letzten fünf Zeilen von `/etc/group` aus.
2. Notiert im Logbuch für jede Gruppe die GID. Nach welchem System wurden die GIDs vergeben?
3. Gebt mit `sudo` die letzten fünf Zeilen von `/etc/gshadow` aus. Was steht dort im zweiten Feld?

### Schritt 3: Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T1-03** sollten alle fünf Gruppen grün sein.

### Abnahmekriterien

Die Gruppen `geschaeftsfuehrung`, `vertrieb`, `entwicklung`, `buchhaltung` und `mitarbeitende` existieren.

## Erweiterung: Begrüßung für neue Konten

> **Wichtig:** Diese Aufgabe muss **vor** T1-04 erledigt werden, sonst wirkt sie bei den Mitarbeitenden nicht.

Neue Heimatverzeichnisse werden als Kopie einer Vorlage angelegt. Diese Vorlage liegt in `/etc/skel` (*Skeleton*).

### Schritt 1: Vorlage untersuchen

1. Lasst euch **alle** Dateien in `/etc/skel` anzeigen, auch die versteckten.
2. Vergleicht mit dem Inhalt eures eigenen Heimatverzeichnisses. Welche Dateien kennt ihr wieder?

### Schritt 2: Willkommensdatei anlegen

1. Legt mit einem Editor die Datei `/etc/skel/WILLKOMMEN.txt` an, zum Beispiel mit diesem Inhalt:

   ```text
   Willkommen bei der Pinguin GmbH!

   Dein Startpasswort musst du bei der ersten Anmeldung ändern.
   Bei Fragen wende dich an die IT-Abteilung.
   ```

### Schritt 3: Alias für alle neuen Konten

1. Hängt an das Ende der Datei `/etc/skel/.bashrc` die Zeile `alias ll='ls -l'` an.
2. Versucht es zuerst mit `sudo echo "alias ll='ls -l'" >> /etc/skel/.bashrc`. Notiert die Fehlermeldung und erklärt, warum das nicht funktioniert.
3. Nutzt stattdessen einen Editor oder das Kommando `tee` (siehe Hilfekarte 2).
4. Prüft mit `tail -n 3 /etc/skel/.bashrc`, ob die Zeile angekommen ist, und zwar **genau einmal**.

### Schritt 4: Testen

1. Legt ein Testkonto an: `sudo useradd -m skeltest`
2. Lasst euch mit `sudo ls -la /home/skeltest` den Inhalt des neuen Heimatverzeichnisses anzeigen. Ist `WILLKOMMEN.txt` da?
3. Prüft mit `sudo grep ll /home/skeltest/.bashrc`, ob der Alias angekommen ist.
4. Löscht das Testkonto wieder: `sudo userdel -r skeltest`
5. Schaut in **euer eigenes** Heimatverzeichnis. Habt ihr die Datei `WILLKOMMEN.txt` auch bekommen? Erklärt im Logbuch, warum (nicht).

## Profi: Feste GIDs

Die Pinguin GmbH plant einen zweiten Server. Dort sollen die Gruppen dieselben GIDs haben.

1. Ändert die GIDs der fünf Gruppen auf diese Werte:

   | Gruppe | GID |
   |---|---|
   | `mitarbeitende` | 2000 |
   | `geschaeftsfuehrung` | 2001 |
   | `vertrieb` | 2002 |
   | `entwicklung` | 2003 |
   | `buchhaltung` | 2004 |

2. Prüft das Ergebnis in `/etc/group`.
3. Erklärt im Logbuch, warum feste GIDs über mehrere Server hinweg wichtig sind. Denkt dabei an `ls -l`, an `tar`-Archive und an Netzlaufwerke: Speichern diese den Gruppen**namen** oder die Gruppen**nummer**?

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Gruppen anlegen und ändern: `man groupadd`, `man groupmod`
- Gruppen werden in `/etc/group` und `/etc/gshadow` gespeichert.
- Das Skeleton-Verzeichnis: Sucht in `man useradd` nach `skel`.
- Warum `sudo echo … >> datei` scheitert: Überlegt, **wer** den Redirect `>>` ausführt.

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
groupadd <gruppe>
groupmod -g <gid> <gruppe>
tail -n 5 /etc/group
sudo tail -n 5 /etc/gshadow
ls -la /etc/skel
sudo nano /etc/skel/WILLKOMMEN.txt
echo "alias ll='ls -l'" | sudo tee -a /etc/skel/.bashrc
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

```bash
# Pflicht Gruppen anlegen
sudo groupadd geschaeftsfuehrung
sudo groupadd vertrieb
sudo groupadd entwicklung
sudo groupadd buchhaltung
sudo groupadd mitarbeitende

tail -n 5 /etc/group
sudo tail -n 5 /etc/gshadow
```

Die GIDs werden fortlaufend ab der nächsten freien Nummer vergeben. In `/etc/gshadow` steht im zweiten Feld ein `!`: Die Gruppe hat kein Gruppenpasswort (Gruppenpasswörter werden praktisch nicht genutzt).

```bash
# Erweiterung Skeleton-Verzeichnis
ls -la /etc/skel
sudo nano /etc/skel/WILLKOMMEN.txt
echo "alias ll='ls -l'" | sudo tee -a /etc/skel/.bashrc
tail -n 3 /etc/skel/.bashrc

sudo useradd -m skeltest
sudo ls -la /home/skeltest
sudo grep ll /home/skeltest/.bashrc
sudo userdel -r skeltest
```

**Warum scheitert `sudo echo … >> datei`?** Der Redirect `>>` wird von **eurer** Shell ausgeführt, bevor `sudo` überhaupt startet, und eure Shell läuft ohne Root-Rechte. `sudo` gilt nur für `echo`. `tee -a` dagegen läuft selbst mit `sudo` und schreibt die Datei mit Root-Rechten.

**Warum habt ihr die Datei nicht bekommen?** Der Inhalt von `/etc/skel` wird nur beim **Anlegen** eines Kontos kopiert. Bestehende Konten bekommen ihn nicht automatisch; man müsste die Datei von Hand kopieren und mit `chown` dem jeweiligen Benutzer übergeben.

```bash
# Profi Feste GIDs
sudo groupmod -g 2000 mitarbeitende
sudo groupmod -g 2001 geschaeftsfuehrung
sudo groupmod -g 2002 vertrieb
sudo groupmod -g 2003 entwicklung
sudo groupmod -g 2004 buchhaltung
tail -n 5 /etc/group
```

Dateisysteme, Archive und Netzlaufwerke speichern nicht den Gruppennamen, sondern die **GID**. `ls -l` übersetzt die Nummer nur für die Anzeige in einen Namen. Hat die Gruppe `vertrieb` auf dem zweiten Server eine andere GID, gehören die Dateien dort plötzlich einer anderen Gruppe oder gar keiner.

</details>
