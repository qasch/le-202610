# T1-04: Onboarding der Mitarbeitenden

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Alle sollen ab morgen auf den Server!
>
> Hallo IT,
>
> bitte legt für alle Mitarbeitenden ein Konto an. Die Liste habt ihr ja. Bitte haltet euch an die Richtlinien der IT. Ich möchte nicht, dass am Ende alle dasselbe Passwort behalten.
>
> Grete

Alle Schritte führt ihr **auf dem Server** mit `sudo` aus. Verwendet für die Mitarbeitenden **`useradd`**, nicht `adduser`.

## Pflicht

### Schritt 1: Richtlinien in Optionen übersetzen

1. Lest die [Richtlinien der IT](../00-pinguin-gmbh.md#richtlinien-der-it).
2. Sucht in `man useradd` für jede Anforderung die passende Option und füllt im Logbuch diese Tabelle aus:

   | Anforderung | Option von `useradd` |
   |---|---|
   | Heimatverzeichnis mit Standarddateien anlegen | |
   | Vollständiger Name im Kommentarfeld | |
   | `bash` als Login-Shell | |
   | Mitglied in Abteilungsgruppe und `mitarbeitende` | |

3. Die beiden Anforderungen zum Passwort erledigt nicht `useradd`. Notiert, welche Kommandos ihr dafür braucht (siehe Hilfekarte 1).

### Schritt 2: Das erste Konto vollständig anlegen

Ihr beginnt mit **Lena Wagner** (`lwagner`, Vertrieb).

1. Legt das Konto mit `useradd` und allen Optionen aus eurer Tabelle an.
2. Setzt das Startpasswort `Pinguin-Start-2026`.
3. Sorgt dafür, dass Lena das Passwort bei der ersten Anmeldung ändern muss.

### Schritt 3: Das erste Konto prüfen

Kontrolliert jeden Punkt und hakt ihn im Logbuch ab:

1. `id lwagner`: Es müssen die Gruppen `lwagner`, `vertrieb` und `mitarbeitende` erscheinen.
2. `grep lwagner /etc/passwd`: Stehen im Kommentarfeld `Lena Wagner`, als Heimatverzeichnis `/home/lwagner` und als Shell `/bin/bash`?
3. `sudo ls -la /home/lwagner`: Gibt es das Verzeichnis, gehört es `lwagner` und enthält es die Dateien aus `/etc/skel` (z. B. `.bashrc`)?
4. `sudo chage -l lwagner`: In der ersten Zeile (`Last password change`) muss `password must be changed` stehen, bzw. auf einem deutschsprachigen System sinngemäß „Passwort muss geändert werden“.
5. Führt das Check-Skript aus. Im Abschnitt **T1-04** muss `lwagner` grün sein.

Ist etwas rot? Korrigiert es mit `usermod` oder löscht das Konto mit `sudo userdel -r lwagner` und legt es neu an.

### Schritt 4: Die übrigen Konten anlegen

1. Teilt die restlichen zehn Mitarbeitenden auf: Jede Person im Team übernimmt eine Abteilung und sitzt dafür an der Tastatur. Die Geschäftsführung (eine Person) übernimmt, wer am schnellsten fertig ist.
2. Legt die Konten genauso an wie das von Lena Wagner, mit Passwort und erzwungener Passwortänderung.

### Schritt 5: Selbstkontrolle

1. Führt das Check-Skript aus. Im Abschnitt **T1-04** müssen alle elf Konten grün sein.
2. Beantwortet im Logbuch: Warum lernen wir `useradd`, obwohl `adduser` viel bequemer ist?

### Abnahmekriterien

Für jedes der elf Konten gilt:

- Das Konto existiert.
- Es gibt ein Heimatverzeichnis unter `/home/<benutzer>`, das dem Benutzer gehört und die Standarddateien enthält.
- Die Login-Shell ist `/bin/bash`.
- Im Kommentarfeld steht der vollständige Name.
- Das Konto ist Mitglied seiner Abteilungsgruppe **und** der Gruppe `mitarbeitende`.
- Ein Passwort ist gesetzt, das bei der ersten Anmeldung geändert werden muss.

## Erweiterung: Viele Passwörter auf einmal

Elf Mal `passwd` und jedes Mal das Passwort zweimal eintippen? Das geht schneller.

1. Schaut in `man passwd` im Abschnitt `SEE ALSO` nach einem Kommando, das Passwörter für **mehrere** Konten auf einmal setzt.
2. Lest in dessen Manpage nach, in welchem Format es die Eingabe erwartet.
3. Setzt damit für die drei Konten des Vertriebs (`lwagner`, `mkaya`, `sromano`) in **einem einzigen** Aufruf das Startpasswort neu. Tipp: Ein Here-Document (`<<EOF`) aus dem Kapitel zu Redirects ist hier praktisch.
4. Achtung: Das Kommando setzt das Datum der letzten Passwortänderung neu. Erzwingt die Passwortänderung für die drei Konten deshalb erneut und prüft eines davon mit `sudo chage -l`.
5. Überlegt und notiert im Logbuch: An welchen Stellen könnte das Startpasswort jetzt noch zu finden sein? Schaut euch dazu `history | tail` an.

## Profi: Euer erstes Skript

Die Pinguin GmbH wächst und es kommen ständig neue Leute. Ihr schreibt ein Skript `onboarding.sh`, das Konten aus einer CSV-Datei anlegt.

1. Ladet die Mitarbeitendenliste auf den Server und schaut sie euch an:

   ```bash
   wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/daten/mitarbeitende.csv
   cat mitarbeitende.csv
   ```

2. Die Konten aus dieser Liste existieren schon. Legt deshalb eine Testdatei `neue.csv` mit diesem Inhalt an:

   ```text
   benutzername;vorname;nachname;abteilung
   ptest;Paula;Test;vertrieb
   ttest;Theo;Test;entwicklung
   ```

3. Legt die Datei `onboarding.sh` an und übernehmt das Grundgerüst aus Hilfekarte 2.
4. Startet das Skript zunächst so, wie es ist: `bash onboarding.sh`. Es soll nur die Meldungen `Lege ptest an ...` und `Lege ttest an ...` ausgeben.
5. Ergänzt in der Schleife die Kommandos zum Anlegen, zum Setzen des Passworts und zum Erzwingen der Passwortänderung. Verwendet dabei die Variablen `$benutzer`, `$vorname`, `$nachname` und `$abteilung`.
6. Macht das Skript ausführbar und startet es mit `sudo ./onboarding.sh`.
7. Prüft beide Testkonten wie in Schritt 3 der Pflichtaufgabe.
8. Löscht die Testkonten wieder: `sudo userdel -r ptest` und `sudo userdel -r ttest`

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- `man useradd`: Ihr braucht Optionen für Heimatverzeichnis (*home*), Kommentar (*comment*), Shell (*shell*) und zusätzliche Gruppen (*groups*).
- Passwort setzen: `man passwd`
- Passwortänderung bei der nächsten Anmeldung erzwingen: `man chage` (Option für *lastday*) oder `man passwd` (Option für *expire*)
- Erweiterung: Schaut in den `SEE ALSO`-Abschnitt von `man passwd`.

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
useradd -m -c "..." -s ... -G ...,... <benutzer>
passwd <benutzer>
chage -d 0 <benutzer>      # oder: passwd -e <benutzer>
id <benutzer>
chage -l <benutzer>
usermod ...                # zum Korrigieren
userdel -r <benutzer>      # zum Löschen inklusive Heimatverzeichnis
```

Erweiterung: `chpasswd` liest Zeilen der Form `benutzer:passwort` von der Standardeingabe.

Profi: Grundgerüst für das Skript:

```bash
#!/bin/bash
# Legt Konten aus einer CSV-Datei an (Trennzeichen: Semikolon)

startpasswort='Pinguin-Start-2026'

# Kopfzeile überspringen (tail -n +2) und Zeile für Zeile lesen
tail -n +2 neue.csv | while IFS=';' read -r benutzer vorname nachname abteilung; do
	echo "Lege $benutzer an ..."
	# hier useradd, chpasswd und chage einsetzen
done
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

**Schritt 1:**

| Anforderung | Option von `useradd` |
|---|---|
| Heimatverzeichnis mit Standarddateien anlegen | `-m` |
| Vollständiger Name im Kommentarfeld | `-c "Vorname Nachname"` |
| `bash` als Login-Shell | `-s /bin/bash` |
| Mitglied in Abteilungsgruppe und `mitarbeitende` | `-G abteilung,mitarbeitende` |

Passwort: `passwd <benutzer>`; Änderung erzwingen: `chage -d 0 <benutzer>`.

**Schritt 2 und 3:**

```bash
sudo useradd -m -c "Lena Wagner" -s /bin/bash -G vertrieb,mitarbeitende lwagner
sudo passwd lwagner
sudo chage -d 0 lwagner

id lwagner
grep lwagner /etc/passwd
sudo ls -la /home/lwagner
sudo chage -l lwagner
```

- `-m` legt das Heimatverzeichnis an und kopiert den Inhalt von `/etc/skel` hinein.
- `-G` setzt die **zusätzlichen** Gruppen. Die primäre Gruppe ist eine eigene Gruppe mit dem Namen des Benutzers.
- `chage -d 0` setzt das Datum der letzten Passwortänderung auf den 01.01.1970. Das Passwort gilt damit als abgelaufen und muss bei der nächsten Anmeldung geändert werden.

**Schritt 5:** `useradd` gibt es auf jeder Distribution, es ist nicht interaktiv und lässt sich deshalb in Skripten verwenden. `adduser` ist ein Debian-spezifisches Komfortprogramm, das im Hintergrund selbst `useradd` aufruft.

**Erweiterung:**

```bash
sudo chpasswd <<EOF
lwagner:Pinguin-Start-2026
mkaya:Pinguin-Start-2026
sromano:Pinguin-Start-2026
EOF

sudo chage -d 0 lwagner
sudo chage -d 0 mkaya
sudo chage -d 0 sromano
sudo chage -l lwagner
```

Ein Passwort, das ihr auf der Kommandozeile oder in einem Here-Document eintippt, landet in der History (`~/.bash_history`). Wenn ihr die Passwörter in einer Datei sammelt, löscht sie danach.

**Profi `onboarding.sh`:**

```bash
#!/bin/bash
# Legt Konten aus einer CSV-Datei an (Trennzeichen: Semikolon)

startpasswort='Pinguin-Start-2026'

tail -n +2 neue.csv | while IFS=';' read -r benutzer vorname nachname abteilung; do
	echo "Lege $benutzer an ..."
	useradd -m -c "$vorname $nachname" -s /bin/bash -G "$abteilung,mitarbeitende" "$benutzer"
	echo "$benutzer:$startpasswort" | chpasswd
	chage -d 0 "$benutzer"
done
```

```bash
chmod +x onboarding.sh
sudo ./onboarding.sh
```

</details>
