# T2-01 – Heimatverzeichnisse

> **Von:** Jonas Becker (Entwicklung)
> **Betreff:** Aylin kommt nicht an meine Notizen
>
> Hallo IT,
>
> ich wollte Aylin meine Notizen zum neuen Login-Modul zeigen. Ich habe ihr gesagt, dass sie unter `/home/jbecker/notizen/login-modul.txt` liegen – aber sie bekommt nur „Keine Berechtigung“.
>
> Könnt ihr das freischalten? Aber bitte so, dass **nur Aylin** drankommt. Lena aus dem Vertrieb hat gestern schon versucht, in mein Heimatverzeichnis zu schauen. Das muss nicht sein.
>
> Jonas

Alle Schritte führt ihr **auf dem Server** aus. Wie ihr als eine andere Person testet, steht in der [Übersicht von Tag 2](./README.md#neu-heute-als-eine-andere-person-testen).

## ⭐ Pflicht

### Schritt 1: Bestandsaufnahme

1. Lasst euch mit `ls -ld /home/*` die Rechte aller Heimatverzeichnisse anzeigen. Warum braucht ihr hier die Option `-d`? Probiert zum Vergleich `sudo ls -l /home/jbecker`.
2. Füllt im Logbuch diese Tabelle aus:

   | Verzeichnis | Rechte (symbolisch) | Rechte (oktal) | Besitzer | Gruppe | Darf `others` hinein? |
   |---|---|---|---|---|---|
   | `/home/jbecker` | | | | | |
   | `/home/lwagner` | | | | | |
   | `/home/<euer-konto>` | | | | | |

3. Beantwortet damit die Frage aus T1-06 ⭐⭐: Warum kam Lena nicht in das Heimatverzeichnis von Jonas?

### Schritt 2: Jonas legt seine Notizen an

1. Öffnet eine Shell als `jbecker` und legt die Notizen an:

   ```bash
   mkdir ~/notizen
   echo "Login-Modul: Passwort-Hashes mit yescrypt" > ~/notizen/login-modul.txt
   ls -ld ~ ~/notizen ~/notizen/login-modul.txt
   ```

2. Notiert die Rechte der drei Einträge. Sind der Ordner `notizen` und die Datei für `others` lesbar?
3. Bleibt in der Shell von Jonas – ihr braucht sie gleich wieder. Öffnet für die Tests eine **zweite** SSH-Verbindung zum Server.

### Schritt 3: Aylin versucht es

1. Öffnet in der zweiten Verbindung eine Shell als `ademir` und versucht:
   - `cat /home/jbecker/notizen/login-modul.txt`
   - `ls /home/jbecker`
2. Notiert die Meldungen (`Permission denied`, auf deutschsprachigen Systemen „Keine Berechtigung“).
3. Erklärt im Logbuch: Die Datei selbst ist für `others` lesbar. Woran scheitert Aylin trotzdem?

### Schritt 4: Versuch 1 – weit öffnen (symbolisch)

Jonas ist Besitzer seines Heimatverzeichnisses und darf dessen Rechte **selbst** ändern – ohne `sudo`.

1. Jonas gibt `others` an seinem Heimatverzeichnis die Rechte `r` und `x`. Verwendet die **symbolische** Schreibweise von `chmod` (mit `u`, `g`, `o`, `+`, `-`, `=`).
2. Prüft mit `ls -ld ~`. Welche Rechte hat das Verzeichnis jetzt (symbolisch und oktal)?
3. Testet als Aylin: `cat /home/jbecker/notizen/login-modul.txt` und `ls /home/jbecker`
4. Testet dasselbe als Lena (`lwagner`).
5. Jonas nimmt die Rechte mit `chmod` (symbolisch) wieder weg.

### Schritt 5: Versuch 2 – nur betreten (oktal)

1. Rechnet aus, welcher Oktalzahl `rwx--x--x` entspricht. Notiert den Rechenweg im Logbuch (`r` = 4, `w` = 2, `x` = 1).
2. Jonas setzt diese Rechte an seinem Heimatverzeichnis in **oktaler** Schreibweise.
3. Testet als Aylin und als Lena und füllt die Tabelle aus:

   | Person | `ls /home/jbecker` | `cat /home/jbecker/notizen/login-modul.txt` | `ls /home/jbecker/notizen` |
   |---|---|---|---|
   | `ademir` | | | |
   | `lwagner` | | | |

4. Ist Jonas' Wunsch „nur Aylin“ damit erfüllt? Was müsste Lena wissen, um an die Datei zu kommen?

### Schritt 6: Rückbau und Fazit

1. Jonas setzt sein Heimatverzeichnis wieder auf `700` (oktal) und beendet seine Shell mit `exit`.
2. Prüft mit `ls -ld /home/*`: Alle Zeilen müssen wieder mit `drwx------` beginnen.
3. Diskutiert im Team und notiert im Logbuch:
   - Mit den Rechten für `others` erreicht ihr immer **alle** Personen auf dem Server. Was haben Jonas und Aylin gemeinsam, was Lena nicht hat? (Tipp: `id jbecker`, `id ademir`, `id lwagner`)
   - Ist das Heimatverzeichnis der richtige Ort, um Dateien mit Kolleginnen und Kollegen zu teilen?

### Schritt 7: Wer darf trotzdem hinein?

1. Führt **ohne** `sudo` `ls /home/jbecker` mit eurem Admin-Konto aus.
2. Führt dasselbe **mit** `sudo` aus.
3. Notiert im Logbuch:
   - Wer kommt in das Heimatverzeichnis von Jonas, obwohl es `700` hat? (Erinnert euch an T1-06 ⭐⭐⭐.)
   - Wer kann die Rechte an `/home/jbecker` jederzeit wieder ändern – auch ohne die IT zu fragen?

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T2-01** sollten alle Punkte grün sein.

### Abnahmekriterien

Die Heimatverzeichnisse aller zwölf Mitarbeitenden (einschließlich `mneumann`) haben die Rechte `700` und gehören der jeweiligen Person.

> Jonas' Wunsch erfüllt ihr in **T2-02** – mit einem gemeinsamen Ordner für die Entwicklung.

## ⭐⭐ Erweiterung: Was bedeuten `r`, `w` und `x` bei einem Verzeichnis?

Bei Dateien ist es einfach: lesen, schreiben, ausführen. Aber was heißt „ein Verzeichnis ausführen“? Das findet ihr jetzt systematisch heraus.

Arbeitet mit eurem **eigenen** Admin-Konto in eurem Heimatverzeichnis und **ohne** `sudo` – sonst greifen die Rechte nicht.

1. Legt ein Versuchsverzeichnis mit einer Datei an:

   ```bash
   mkdir ~/versuch
   echo "geheim" > ~/versuch/datei.txt
   ```

2. Setzt nacheinander die folgenden Rechte für `~/versuch` und probiert jedes Mal diese drei Kommandos aus:
   - `ls ~/versuch`
   - `cat ~/versuch/datei.txt`
   - `cd ~/versuch` (danach mit `cd` zurück)

   | Rechte von `~/versuch` | `ls` | `cat` | `cd` |
   |---|---|---|---|
   | `700` (`rwx`) | | | |
   | `600` (`rw-`) | | | |
   | `500` (`r-x`) | | | |
   | `400` (`r--`) | | | |
   | `100` (`--x`) | | | |

3. Ergänzt die Tabelle für `500` um einen vierten Versuch: `touch ~/versuch/neu.txt`.
4. Formuliert im Logbuch in je einem Satz, was `r`, `w` und `x` bei einem **Verzeichnis** erlauben.
5. Erklärt mit eurer Tabelle die Ergebnisse von Aylin und Lena in Schritt 5 der Pflicht.
6. Räumt auf: `chmod 700 ~/versuch` und `rm -r ~/versuch`.

## ⭐⭐⭐ Profi: Woher kommt die `700`?

Niemand von euch hat die Heimatverzeichnisse auf `700` gesetzt – trotzdem haben alle diese Rechte.

1. Eure Admin-Konten habt ihr mit `adduser` angelegt, die Mitarbeitenden mit `useradd`. Beide Programme haben eigene Einstellungen:
   - Sucht in `/etc/login.defs` die Einstellung `HOME_MODE` (Erklärung in `man login.defs`).
   - Sucht in `/etc/adduser.conf` die Einstellung `DIR_MODE` (Erklärung in `man adduser.conf`).

   Notiert beide Werte.
2. Lest in `man login.defs` nach: Welcher Wert gilt für `useradd`, wenn `HOME_MODE` **nicht** gesetzt ist?
3. Mit der Option `-K` von `useradd` könnt ihr eine Einstellung aus `/etc/login.defs` für einen einzigen Aufruf überschreiben, ohne die Datei zu ändern. Legt so ein Testkonto an:

   ```bash
   sudo useradd -m -K HOME_MODE=0755 htest
   ls -ld /home/htest
   ```

4. Was hätte Lena in T1-06 gesehen, wenn alle Konten so angelegt worden wären?
5. Überlegt: Wenn ihr `HOME_MODE` in `/etc/login.defs` ändert – ändern sich dann die Rechte der bestehenden Heimatverzeichnisse?
6. Löscht das Testkonto wieder: `sudo userdel -r htest`

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- Rechte ändern: `man chmod` – die symbolische Schreibweise steht im Abschnitt `DESCRIPTION`.
- Rechte anzeigen: `ls -l`, für ein Verzeichnis selbst `ls -ld` (Option `-d` in `man ls`).
- Oktal rechnen: Jede Stelle ist die Summe aus `r` = 4, `w` = 2, `x` = 1 – für Besitzer, Gruppe und andere.
- Um eine Datei zu öffnen, muss man **jedes** Verzeichnis auf dem Weg dorthin betreten dürfen.
- Die Rechte einer Datei oder eines Verzeichnisses darf die Besitzerin oder der Besitzer selbst ändern.
- Rechte neuer Heimatverzeichnisse: `man login.defs` (`HOME_MODE`), `man adduser.conf` (`DIR_MODE`), Option `-K` in `man useradd`

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
ls -ld /home/*
sudo -iu jbecker
sudo -iu ademir
chmod o+rx ~        /   chmod o-rx ~
chmod 711 ~
chmod 700 ~
id <benutzer>
grep -n HOME_MODE /etc/login.defs
grep -n DIR_MODE /etc/adduser.conf
sudo useradd -m -K HOME_MODE=0755 htest
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

```bash
# Schritt 1
ls -ld /home/*

# Schritt 2 (als jbecker)
mkdir ~/notizen
echo "Login-Modul: Passwort-Hashes mit yescrypt" > ~/notizen/login-modul.txt
ls -ld ~ ~/notizen ~/notizen/login-modul.txt

# Schritt 4 (als jbecker)
chmod o+rx ~          # drwx---r-x = 705
chmod o-rx ~

# Schritt 5 (als jbecker)
chmod 711 ~           # drwx--x--x

# Schritt 6 (als jbecker)
chmod 700 ~

# Schritt 7 (eigenes Konto)
ls /home/jbecker           # Permission denied
sudo ls /home/jbecker      # klappt
```

**Schritt 1:** Ohne `-d` zeigt `ls -l` den **Inhalt** des Verzeichnisses, mit `-d` das Verzeichnis selbst. Auf aktuellen Debian-Versionen haben alle Heimatverzeichnisse `drwx------` (`700`) – egal ob mit `useradd` oder `adduser` angelegt. Nur die Besitzerin oder der Besitzer darf hinein. Deshalb kam Lena gestern nicht in `/home/jbecker`.

**Schritt 2:** Wegen der umask `0002` hat `notizen` die Rechte `drwxrwxr-x` und `login-modul.txt` die Rechte `-rw-rw-r--` – beide für `others` lesbar.

**Schritt 3:** Um eine Datei zu öffnen, muss man **jedes** Verzeichnis auf dem Weg betreten dürfen (`x`). An `/home/jbecker` haben `others` gar keine Rechte – dahinter kommt Aylin nicht, egal wie offen die Datei selbst ist.

**Schritt 4:** `chmod o+rx ~` ergibt `drwx---r-x` (`705`). Jetzt kommen Aylin **und** Lena an die Notizen und können sich zusätzlich den gesamten Inhalt des Heimatverzeichnisses anzeigen lassen.

**Schritt 5:** `rwx--x--x` = `(4+2+1)(1)(1)` = `711`.

| Person | `ls /home/jbecker` | `cat …/login-modul.txt` | `ls /home/jbecker/notizen` |
|---|---|---|---|
| `ademir` | ✘ | ✔ | ✔ |
| `lwagner` | ✘ | ✔ | ✔ |

Niemand kann das Heimatverzeichnis auflisten, aber wer den Pfad kennt, kommt an die Datei – und kann sich dann auch den Inhalt von `notizen` anzeigen lassen. Lena muss nur den Pfad kennen. „Nur Aylin“ ist nicht erfüllt.

**Schritt 6:** Jonas und Aylin sind beide in der Gruppe `entwicklung`, Lena nicht. Teilen funktioniert sauber über eine **gemeinsame Gruppe** – nicht über `others`. Das Heimatverzeichnis hat aber die private Gruppe `jbecker`. Der richtige Ort ist ein gemeinsamer Ordner der Abteilung (T2-02).

**Schritt 7:** Euer Admin-Konto kommt ohne `sudo` nicht hinein – ihr seid für Jonas' Verzeichnis „andere“. Mit `sudo` arbeitet ihr als `root`, und für `root` gelten die Rechte nicht. Ändern darf die Rechte jederzeit Jonas selbst (als Besitzer) – und `root`.

**⭐⭐:**

| Rechte | `ls` | `cat` | `cd` |
|---|---|---|---|
| `700` | ✔ | ✔ | ✔ |
| `600` | Namen ja, aber Fehlermeldungen | ✘ | ✘ |
| `500` | ✔ | ✔ | ✔ (aber `touch` ✘) |
| `400` | Namen ja, aber Fehlermeldungen | ✘ | ✘ |
| `100` | ✘ | ✔ | ✔ |

- `r` erlaubt, die **Namen** im Verzeichnis aufzulisten.
- `w` erlaubt, Einträge **anzulegen, umzubenennen und zu löschen** – aber nur zusammen mit `x`.
- `x` erlaubt, das Verzeichnis zu **betreten** und auf Einträge darin zuzugreifen, deren Namen man kennt.

Bei `400` und `600` zeigt `ls` die Namen, kann aber keine Details abrufen – je nach Alias erscheinen deshalb Fehlermeldungen oder Fragezeichen. Bei `711` haben Aylin und Lena an `/home/jbecker` nur `x`: kein Auflisten, aber Durchgehen zu bekannten Namen.

**⭐⭐⭐:** Auf aktuellen Debian-Versionen steht in `/etc/login.defs` `HOME_MODE 0700` und in `/etc/adduser.conf` `DIR_MODE=0700` (bzw. ist das dort der Standardwert). Ohne `HOME_MODE` würde `useradd` die Rechte aus der `UMASK` in `/etc/login.defs` berechnen, z. B. `022` → `755`. Mit `-K HOME_MODE=0755` entsteht genau so ein Verzeichnis: Lena hätte in T1-06 alle Dateien von Jonas lesen können, die für `others` lesbar sind. Ältere Debian-Versionen haben Heimatverzeichnisse tatsächlich mit `755` angelegt. Eine Änderung in `/etc/login.defs` wirkt nur auf **neue** Konten, bestehende Verzeichnisse bleiben unverändert.

</details>
