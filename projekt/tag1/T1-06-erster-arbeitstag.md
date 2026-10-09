# T1-06: Erster Arbeitstag

> **Von:** Lena Wagner (Vertrieb)
> **Betreff:** Mein Login
>
> Hallo IT,
>
> ich habe heute meine Zugangsdaten bekommen. Was muss ich tun? Und darf ich eigentlich auch mal `sudo` benutzen, das klingt so praktisch?
>
> Lena

Jetzt testet ihr euer Werk aus Sicht der Mitarbeitenden. Verteilt dafür die Rollen:

| Rolle | Wo? | Aufgabe |
|---|---|---|
| **Lena** | am eigenen Arbeitsplatz, angemeldet als `lwagner` | spielt die neue Mitarbeiterin |
| **Admin** | am eigenen Arbeitsplatz, per SSH mit dem persönlichen Konto am Server | beobachtet, was Lena tut |
| **Logbuch** | neben dem Admin | notiert alle Beobachtungen |

## Pflicht

### Schritt 1: Erste Anmeldung (Lena)

1. Meldet euch mit `ssh lwagner@<server>` und dem Startpasswort `Pinguin-Start-2026` an.
2. Lest genau, was das System nach der Anmeldung verlangt, und folgt der Aufforderung: zuerst das **aktuelle** Passwort (das Startpasswort), dann zweimal ein neues Passwort.
3. Was passiert danach mit der Verbindung? Notiert es.
4. Meldet euch mit dem **neuen** Passwort erneut an.

### Schritt 2: Umschauen (Lena)

1. Wo seid ihr nach der Anmeldung? Prüft mit `pwd`.
2. Lasst euch mit `ls -la` den Inhalt des Heimatverzeichnisses anzeigen. Gibt es die Datei `WILLKOMMEN.txt` (falls ihr T1-03 Erweiterung gemacht habt)? Lest sie mit `cat`.
3. Führt `id` aus. Notiert alle Gruppen und vergleicht sie mit der Firmenbeschreibung: Ist Lena in den richtigen Abteilungen?

### Schritt 3: `sudo` ausprobieren (Lena)

1. Führt `sudo whoami` aus und gebt euer (neues) Passwort ein.
2. Notiert die Meldung **wörtlich** im Logbuch.
3. Startet anschließend den Editor `nano notizen.txt` und lasst ihn **geöffnet**.

### Schritt 4: Lena beobachten (Admin)

1. Führt `who` aus. Sucht die Zeile von `lwagner` und notiert:
   - auf welchem Terminal sie angemeldet ist (z. B. `pts/2`)
   - seit wann
   - von welcher IP-Adresse (in Klammern)
2. Führt `w` aus. In welcher Spalte seht ihr, dass Lena gerade `nano` benutzt?
3. Notiert im Logbuch: Was könnt ihr als Admin über angemeldete Personen herausfinden, ohne sie zu fragen?

### Schritt 5: Den `sudo`-Versuch finden (Admin)

Jeder Aufruf von `sudo` wird im Journal des Systems protokolliert, auch verweigerte.

1. Lasst euch mit `journalctl` die Einträge des Programms `sudo` anzeigen (siehe Hilfekarte 2). Ihr braucht dafür selbst `sudo`.
2. Sucht den Eintrag zu Lenas Versuch und notiert Uhrzeit, Benutzername und die Meldung.
3. Findet ihr in derselben Ausgabe auch eure **eigenen** `sudo`-Aufrufe von heute?

### Schritt 6: Feierabend (Lena und Admin)

1. Lena schließt `nano` (`Strg+X`) und meldet sich mit `exit` ab.
2. Der Admin führt `who` erneut aus. Ist Lena noch zu sehen?
3. Der Admin führt `last lwagner` aus. Wie viele Anmeldungen von Lena seht ihr heute, und wie lange dauerten sie?

## Erweiterung: Was darf Lena sehen?

Lena meldet sich erneut an.

1. Lena versucht `cat /etc/shadow`. Notiert die Meldung und erklärt sie mithilfe von `ls -l /etc/shadow`.
2. Lena führt `ls -ld /home/*` aus. Notiert die Berechtigungen der Heimatverzeichnisse.
3. Lena versucht, in das Heimatverzeichnis von Jonas Becker aus der Entwicklung zu schauen:
   - `ls -la /home/jbecker`
   - `cat /home/jbecker/.bashrc`
4. Notiert, was klappt und was nicht.
5. Diskutiert im Team und haltet eure Meinung im Logbuch fest: Sollte eine Mitarbeiterin aus dem Vertrieb die Dateien eines Entwicklers sehen können? **Morgen schauen wir uns an, warum Lena nicht hineinkommt und wie man trotzdem Dateien teilt.**

## Profi

### Login-Shell selbst ändern (Lena)

1. Lasst euch mit `cat /etc/shells` anzeigen, welche Shells auf dem System erlaubt sind.
2. Ändert eure eigene Login-Shell mit `chsh` auf `/bin/sh`. Welches Passwort wird abgefragt?
3. Prüft mit `grep lwagner /etc/passwd`, ob die Änderung angekommen ist.
4. Meldet euch ab und wieder an. Woran erkennt ihr, dass jetzt eine andere Shell läuft? (Tipp: Prompt, Pfeiltasten, `echo $0`)
5. Stellt die Shell wieder auf `/bin/bash` zurück.
6. Versucht, eine Shell einzutragen, die **nicht** in `/etc/shells` steht, z. B. `/bin/ls`. Was passiert?

### Admin-Rechte und Vertraulichkeit (Admin)

1. Wechselt mit `sudo su - lwagner` in Lenas Konto. Müsst ihr dafür Lenas Passwort kennen?
2. Lest Lenas Datei `notizen.txt`.
3. Diskutiert und notiert: Was bedeutet das für die Vertraulichkeit von Daten auf einem Server? Wodurch ist ein Missbrauch zumindest nachvollziehbar?

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Angemeldete Benutzer: `man who`, `man w`, `man last`
- Das Journal: `man journalctl`. Sucht nach einer Möglichkeit, nach einem Programm (*command*) zu filtern.
- Login-Shell ändern: `man chsh`, erlaubte Shells in `man shells`

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
ssh lwagner@pinguin-team<N>
pwd, ls -la, id
sudo whoami
who
w
sudo journalctl _COMM=sudo
last lwagner
chsh -s /bin/sh
cat /etc/shells
sudo su - lwagner
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

**Schritt 1:** Nach der Anmeldung mit dem Startpasswort meldet das System `You are required to change your password immediately (administrator enforced)`. Nach der Änderung wird die Verbindung getrennt (`Connection to … closed`), und Lena meldet sich mit dem neuen Passwort erneut an.

**Schritt 2:** Lena landet in `/home/lwagner`. `id` zeigt die primäre Gruppe `lwagner` sowie `vertrieb` und `mitarbeitende`.

**Schritt 3:** `lwagner is not in the sudoers file.` (je nach Version auch `lwagner is not allowed to run sudo on pinguin-team<N>.`). Lena ist nicht Mitglied der Gruppe `sudo` und darf keine Kommandos mit Root-Rechten ausführen. Genau so soll es sein.

**Schritt 4:**

```bash
who
w
```

`who` zeigt Benutzer, Terminal, Anmeldezeit und Herkunfts-IP. `w` zeigt zusätzlich in der Spalte `WHAT`, welches Programm gerade läuft, hier `nano notizen.txt`.

**Schritt 5:**

```bash
sudo journalctl _COMM=sudo
sudo journalctl _COMM=sudo | grep lwagner
```

Dort steht u. a. `lwagner : user NOT in sudoers ; … COMMAND=/usr/bin/whoami`. Eure eigenen Aufrufe erscheinen ebenfalls, mit Benutzername, Arbeitsverzeichnis und ausgeführtem Kommando.

**Schritt 6:** `last lwagner` zeigt jede Anmeldung mit Start- und Endzeit sowie Dauer. Die erste Sitzung (Passwortänderung) dauerte nur wenige Sekunden.

**Erweiterung:** `/etc/shadow` ist nur für `root` und die Gruppe `shadow` lesbar (`-rw-r-----`). Lena kommt nicht in `/home/jbecker`: `ls -ld /home/*` zeigt bei allen Heimatverzeichnissen `drwx------`: Nur die Besitzerin oder der Besitzer darf hinein. Warum das so ist und wie man trotzdem Dateien teilt, ist Thema von Tag 2.

**Profi Login-Shell:** Mit `chsh -s /bin/sh` darf jede Person die eigene Login-Shell ändern; abgefragt wird ihr **eigenes** Passwort. Erlaubt sind nur Shells, die in `/etc/shells` stehen, `/bin/ls` wird abgelehnt. In der `sh` funktionieren u. a. Pfeiltasten und Tab-Vervollständigung nicht wie gewohnt, `echo $0` zeigt `-sh`. Zurückstellen mit `chsh -s /bin/bash`.

**Profi Vertraulichkeit:** `root` darf ohne Passwort in jedes Konto wechseln und alle Dateien lesen. Vertrauliche Daten sind vor Admins nur durch Verschlüsselung geschützt und durch Vertrauen. Dass jeder `sudo`-Aufruf mit Benutzername protokolliert wird, sorgt zumindest für Nachvollziehbarkeit.

</details>
