# T1-05: Sonderfälle

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Ein paar Änderungen …
>
> Hallo IT,
>
> kaum ist alles eingerichtet, gibt es schon Änderungen. So ist das eben in einer echten Firma:
>
> 1. Ab morgen haben wir eine Praktikantin in der Entwicklung: **Mia Neumann**. Ihr Praktikum endet am **31.01.2027**. Danach soll sie sich nicht mehr anmelden können, auch wenn wir vergessen, ihr Konto zu löschen.
> 2. **Murat Kaya** aus dem Vertrieb unterstützt ab sofort zusätzlich die Entwicklung. Er braucht also Zugriff auf beide Abteilungen.
> 3. **Eva Lindner** aus der Buchhaltung geht für ein Jahr in Elternzeit. Ihr Konto soll in dieser Zeit gesperrt sein. Bitte **nicht löschen**, sie kommt ja wieder, und ihre Daten brauchen wir auch noch.
> 4. Für die Datensicherung, die wir in ein paar Tagen einrichten, braucht ihr ein eigenes Dienstkonto `pinguin-backup`. Damit soll sich niemand anmelden können.
>
> Grete

Alle Schritte führt ihr **auf dem Server** mit `sudo` aus. Wechselt bei jedem Fall die Rollen.

## Pflicht

### Fall 1: Praktikantin mit Ablaufdatum

1. Sucht in `man useradd` die Option, mit der man ein Ablaufdatum (*expire date*) für ein Konto festlegt. Notiert, in welchem Format das Datum angegeben wird.
2. Legt das Konto `mneumann` für Mia Neumann an, mit allen Richtlinien der IT wie in T1-04 **und** dem Ablaufdatum 31.01.2027.
3. Setzt das Startpasswort und erzwingt die Passwortänderung bei der ersten Anmeldung.
4. Prüft mit `sudo chage -l mneumann`. In der Zeile zum Ablauf des Kontos (`Account expires`, auf deutschsprachigen Systemen entsprechend übersetzt) muss der 31. Januar 2027 stehen.

### Fall 2: Murat Kaya in zwei Abteilungen

1. Führt `id mkaya` aus und notiert die Gruppen **vor** der Änderung.
2. Fügt Murat Kaya mit `usermod` der Gruppe `entwicklung` hinzu.
3. Führt sofort wieder `id mkaya` aus und vergleicht mit eurer Notiz. Ist Murat jetzt in `vertrieb`, `entwicklung` **und** `mitarbeitende`?
4. Falls Gruppen fehlen: Findet heraus, was passiert ist (lest in `man usermod` die Beschreibung von `-G` genau), und repariert es.
5. Notiert im Logbuch, was ihr aus diesem Fall gelernt habt.

### Fall 3: Eva Lindner in Elternzeit

1. Gebt mit `sudo grep elindner /etc/shadow` ihre Zeile aus und notiert, wie das zweite Feld beginnt.
2. Sperrt das Konto mit `usermod` (sucht in der Manpage nach *lock*).
3. Gebt die Zeile erneut aus. Was hat sich im zweiten Feld verändert?
4. Testet die Sperre: Eine Person versucht sich von ihrem Arbeitsplatz aus mit `ssh elindner@<server>` und dem Startpasswort anzumelden. Notiert das Ergebnis.

### Fall 4: Dienstkonto für die Datensicherung

1. Sucht in `man useradd` die Option, mit der ein **Systemkonto** angelegt wird.
2. Legt das Konto `pinguin-backup` als Systemkonto an, mit der Login-Shell `/usr/sbin/nologin` und dem Kommentar `Backup-Dienst`. Setzt **kein** Passwort.
3. Prüft mit `grep pinguin-backup /etc/passwd`: Liegt die UID unter 1000? Ist die Shell `/usr/sbin/nologin`?
4. Testet mit `sudo su - pinguin-backup`, ob man sich als dieses Konto anmelden kann. Notiert die Meldung.

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T1-05** sollten alle Punkte grün sein, und im Abschnitt **T1-04** auch weiterhin.

### Abnahmekriterien

- `mneumann` erfüllt alle Kriterien aus T1-04 und ist Mitglied von `entwicklung`.
- Das Konto `mneumann` läuft am 31.01.2027 ab.
- `mkaya` ist Mitglied von `vertrieb`, `entwicklung` **und** `mitarbeitende`.
- Das Konto `elindner` ist gesperrt, hat aber weiterhin ein Passwort.
- `pinguin-backup` ist ein Systemkonto (UID unter 1000) ohne Login-Shell und ohne Passwort.

## Erweiterung

### Eva Lindner kommt zurück

1. Entsperrt das Konto von Eva Lindner.
2. Prüft die Zeile in `/etc/shadow`: Ist das zweite Feld wieder wie vor der Sperre?
3. Testet die Anmeldung per SSH mit dem Startpasswort. Klappt es?
4. Sperrt das Konto anschließend **wieder**. Eva ist ja noch in Elternzeit.

### Ablaufdatum genauer ansehen

1. Gebt mit `sudo grep mneumann /etc/shadow` die Zeile von Mia Neumann aus. In welchem Feld steht das Ablaufdatum, und warum ist es eine Zahl und kein Datum?
2. Rechnet nach: Mit `date -d @$((ZAHL * 86400))` (`ZAHL` ersetzt ihr durch den Wert aus der Datei) könnt ihr die Zahl in ein Datum umrechnen.

## Profi: Drei Wege, eine Anmeldung zu verhindern

1. Füllt im Logbuch diese Tabelle aus:

   | Methode | Kommando | Was wird verändert (Datei, Feld)? | Blockiert Anmeldung mit Passwort? | Blockiert Anmeldung mit SSH-Schlüssel? |
   |---|---|---|---|---|
   | Konto sperren | | | | |
   | Ablaufdatum in der Vergangenheit | | | | |
   | Login-Shell `nologin` | | | | |

2. Recherchiert in `man usermod` bei der Beschreibung von `-L`, was dort zu SSH-Schlüsseln bzw. zum Sperren des ganzen Kontos steht.
3. Empfehlt Grete Frost in zwei Sätzen, wie das Konto von Eva Lindner wirklich sicher gesperrt wird.

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Ablaufdatum: Sucht in `man useradd` und `man usermod` nach `expire`.
- Gruppen ändern: `man usermod`. Lest die Beschreibung von `-G` **und** von `-a`.
- Sperren und Entsperren: Sucht in `man usermod` nach `lock`.
- Systemkonten: Sucht in `man useradd` nach `system`.
- Ablaufdaten anzeigen: `man chage`, Option `-l`

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
useradd -e JJJJ-MM-TT ...
chage -l <benutzer>
usermod -a -G <gruppe> <benutzer>
usermod -L <benutzer>     /   usermod -U <benutzer>
useradd -r -s /usr/sbin/nologin -c "..." <benutzer>
su - <benutzer>
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

```bash
# Fall 1: Praktikantin mit Ablaufdatum
sudo useradd -m -c "Mia Neumann" -s /bin/bash -G entwicklung,mitarbeitende -e 2027-01-31 mneumann
sudo passwd mneumann
sudo chage -d 0 mneumann
sudo chage -l mneumann

# Fall 2: Murat Kaya zusätzlich in die Entwicklung. OHNE -a würde er
#         aus allen anderen zusätzlichen Gruppen entfernt!
id mkaya
sudo usermod -aG entwicklung mkaya
id mkaya

# Fall 3: Eva Lindner sperren
sudo grep elindner /etc/shadow
sudo usermod -L elindner
sudo grep elindner /etc/shadow   # vor dem Hash steht jetzt ein "!"

# Fall 4: Dienstkonto
sudo useradd -r -s /usr/sbin/nologin -c "Backup-Dienst" pinguin-backup
grep pinguin-backup /etc/passwd
sudo su - pinguin-backup         # This account is currently not available.
```

**Fall 2:** Wer `usermod -G entwicklung mkaya` ohne `-a` verwendet hat, hat Murat aus `vertrieb` und `mitarbeitende` entfernt: `-G` setzt die **vollständige** Liste der zusätzlichen Gruppen. Reparieren mit `sudo usermod -aG vertrieb,mitarbeitende mkaya`. Dieser Fehler passiert auch erfahrenen Admins. Deshalb immer mit `id` kontrollieren.

**Fall 3:** `usermod -L` setzt ein `!` vor den Passwort-Hash. Der Hash bleibt erhalten, kann aber nicht mehr passen.

**Erweiterung Rückkehr:** `sudo usermod -U elindner` entfernt das `!` wieder. Eva kann sich danach mit ihrem alten Passwort anmelden.

**Erweiterung Ablaufdatum:** Feld 8 in `/etc/shadow`. Alle Datumsangaben in `/etc/shadow` werden als Anzahl der Tage seit dem 01.01.1970 gespeichert.

**Profi:**

| Methode | Kommando | Was wird verändert? | Passwort | SSH-Schlüssel |
|---|---|---|---|---|
| Konto sperren | `usermod -L` | `!` vor dem Hash in `/etc/shadow`, Feld 2 | blockiert | **nicht** blockiert |
| Ablaufdatum | `usermod -e 1` bzw. `chage -E 0` | `/etc/shadow`, Feld 8 | blockiert | blockiert |
| Login-Shell `nologin` | `usermod -s /usr/sbin/nologin` | `/etc/passwd`, Feld 7 | keine Shell | keine Shell |

Die Manpage von `usermod` empfiehlt, zum Sperren des gesamten Kontos zusätzlich das Ablaufdatum auf `1` zu setzen: `sudo usermod -L -e 1 elindner`.

</details>
