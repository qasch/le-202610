# T1-02 – Bestandsaufnahme: Wer ist schon da?

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Wer hat eigentlich Zugriff auf unseren Server?
>
> Hallo IT,
>
> bevor wir hier alle Mitarbeitenden anlegen, möchte ich wissen, wer schon alles ein Konto auf dem Server hat. Ich habe gehört, da gibt es schon jede Menge Benutzer, die keiner von uns angelegt hat?!
>
> Grete

Alle Schritte führt ihr **auf dem Server** aus, angemeldet mit eurem persönlichen Konto. Haltet die Ergebnisse im Logbuch fest – wir besprechen sie im nächsten Standup.

## ⭐ Pflicht

### Schritt 1: Konten zählen

1. Jede Zeile in `/etc/passwd` ist ein Benutzerkonto. Zählt die Zeilen mit dem Kommando, das ihr aus dem Kapitel zu Pipelines kennt.
2. Notiert die Anzahl. Ihr habt selbst drei Konten angelegt – wie viele waren also schon vorher da?

### Schritt 2: Login-Shells untersuchen

Das **letzte** Feld jeder Zeile in `/etc/passwd` ist die Login-Shell.

1. Gebt alle Zeilen aus, in denen **weder** `nologin` **noch** `false` vorkommt. Notiert die Benutzernamen. Das sind die Konten, die sich interaktiv anmelden können.
2. Gebt alle Zeilen aus, in denen `nologin` oder `false` vorkommt. Wie viele sind es?
3. Notiert, welche verschiedenen Werte im letzten Feld bei diesen Konten stehen.

### Schritt 3: UIDs vergleichen

1. Führt `id` aus und notiert eure UID, eure primäre GID und eure Gruppen.
2. Führt `id root` aus. Welche UID hat `root`?
3. Öffnet `/etc/login.defs` und sucht die Einträge `UID_MIN` und `SYS_UID_MAX`. Notiert die Werte.
4. Beantwortet: In welchem Bereich liegen die UIDs von normalen Benutzern, in welchem die von Systemkonten?

### Schritt 4: Systemkonten erforschen

1. Sucht euch drei Konten aus, die ihr nicht selbst angelegt habt. Vorschlag: `daemon`, `nobody` und ein Konto, dessen Name mit `systemd` beginnt.
2. Füllt im Logbuch diese Tabelle aus:

   | Konto | UID | Heimatverzeichnis | Login-Shell | Wofür wird es vermutlich gebraucht? |
   |---|---|---|---|---|
   | | | | | |

3. Beantwortet: Warum laufen Dienste nicht einfach als `root`?

### Schritt 5: Aufbau der Dateien

1. Gebt die Zeile **eures eigenen** Kontos aus den drei Dateien aus:
   - aus `/etc/passwd` (ohne `sudo`)
   - aus `/etc/shadow` (mit `sudo`)
   - aus `/etc/group` (die Gruppe mit eurem Benutzernamen)
2. Übertragt die drei Zeilen ins Logbuch und schreibt unter jedes Feld (durch `:` getrennt), was es bedeutet. Die Bedeutung der Felder steht in `man 5 passwd`, `man 5 shadow` und `man 5 group`.

### Schritt 6: Berechtigungen vergleichen

1. Führt `ls -l /etc/passwd /etc/shadow` aus. Notiert für beide Dateien die Berechtigungen, den Besitzer und die Gruppe.
2. Versucht **ohne** `sudo`: `cat /etc/passwd` und `cat /etc/shadow`. Notiert, was passiert.
3. Erklärt: Warum darf jede Person `/etc/passwd` lesen, aber nicht `/etc/shadow`?

### Schritt 7: Wer ist angemeldet?

Dafür sind alle drei Teammitglieder per SSH am Server angemeldet.

1. Führt `who` aus. Notiert für jede Sitzung: Benutzername, Terminal (z. B. `pts/0`), Anmeldezeit und die IP-Adresse in Klammern.
2. Führt `w` aus. Welche Informationen zeigt `w` zusätzlich zu `who`? Achtet auf die erste Zeile und die Spalte `WHAT`.
3. Führt `last | head -n 10` aus. Wann hat sich heute wer zum ersten Mal angemeldet? Was bedeutet `still logged in`?

## ⭐⭐ Erweiterung

### `su`, `su -` und `sudo -i` vergleichen

1. Führt nacheinander die drei Kommandos `su`, `su -` und `sudo -i` aus. Gebt in jeder neuen Shell `whoami`, `pwd` und `echo $PATH` ein und verlasst sie mit `exit`.
2. Füllt diese Tabelle aus:

   | Kommando | Welches Passwort? | `whoami` | `pwd` | Enthält `PATH` `/usr/sbin`? |
   |---|---|---|---|---|
   | `su` | | | | |
   | `su -` | | | | |
   | `sudo -i` | | | | |

3. Erklärt, warum `useradd` nach `su` (ohne `-`) möglicherweise nicht gefunden wird.

### Gesperrte Passwörter

1. Gebt mit `sudo` die Zeilen von `root`, `daemon` und eurem eigenen Konto aus `/etc/shadow` aus.
2. Vergleicht jeweils das zweite Feld. Welche Zeichen stehen bei Konten, die sich nicht mit Passwort anmelden können?

## ⭐⭐⭐ Profi

### Konten mit Login-Shell auflisten

1. Baut Schritt für Schritt eine Pipeline, die **nur** Benutzername und UID aller Konten mit Login-Shell ausgibt (Format `name:uid`).
2. Erweitert die Pipeline so, dass die Ausgabe numerisch nach der UID sortiert ist.

### Spuren eines Einbruchsversuchs

1. Eine Person versucht von ihrem Arbeitsplatz aus `ssh <euer-benutzername>@<server>` mit einem **falschen** Passwort, dreimal hintereinander.
2. Eine andere Person sucht auf dem Server im Journal des SSH-Dienstes nach diesen fehlgeschlagenen Versuchen.
3. Notiert: Uhrzeit, Benutzername und IP-Adresse, von der die Versuche kamen.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- Aufbau der Dateien: `man 5 passwd`, `man 5 shadow`, `man 5 group`
- Bereich der UIDs: `/etc/login.defs`
- Angemeldete Benutzer: `man who`, `man w`, `man last`
- Fehlgeschlagene Anmeldungen landen im Journal des Systems: `man journalctl`, Option `-u`

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
wc -l
grep, grep -v, grep -E 'a|b'
cut -d: -f...
sort -t: -k... -n
id, id root
grep UID_MIN /etc/login.defs
ls -l
who, w, last
sudo journalctl -u ssh
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

```bash
# Schritt 1: Konten zählen
wc -l /etc/passwd

# Schritt 2: Login-Shells
grep -v -E 'nologin|false' /etc/passwd
grep -E 'nologin|false' /etc/passwd
grep -c -E 'nologin|false' /etc/passwd

# Schritt 3: UIDs
id
id root
grep -E '^(UID_MIN|UID_MAX|SYS_UID_MIN|SYS_UID_MAX)' /etc/login.defs

# Schritt 4: Systemkonten
grep -E '^(daemon|nobody|systemd)' /etc/passwd

# Schritt 5: eigene Zeilen (Beispiel für das Konto anna)
grep '^anna:' /etc/passwd
sudo grep '^anna:' /etc/shadow
grep '^anna:' /etc/group

# Schritt 6: Berechtigungen
ls -l /etc/passwd /etc/shadow

# Schritt 7: angemeldete Benutzer
who
w
last | head -n 10
```

**Zu Schritt 2:** Systemkonten haben meist `/usr/sbin/nologin` oder `/bin/false` als Shell. `sync` hat `/bin/sync` – eine Besonderheit aus der Unix-Geschichte.

**Zu Schritt 3:** `root` hat immer die UID 0. Normale Benutzer beginnen auf Debian bei `UID_MIN 1000`, Systemkonten liegen darunter (bis `SYS_UID_MAX 999`).

**Zu Schritt 4:** Systemkonten werden von Diensten verwendet. Ein Dienst läuft mit den Rechten seines eigenen Kontos – wird er kompromittiert, hat der Angreifer nur dessen Rechte und nicht die von `root`. `nobody` ist ein Konto ohne jegliche Rechte für Prozesse, die gar nichts dürfen sollen.

**Zu Schritt 5:**

- `/etc/passwd`: `name:x:UID:GID:Kommentar:Heimatverzeichnis:Shell` – das `x` bedeutet „Passwort steht in `/etc/shadow`“.
- `/etc/shadow`: `name:passwort-hash:letzte-änderung:min:max:warnung:inaktiv:ablaufdatum:reserviert` – Datumsangaben in Tagen seit dem 01.01.1970.
- `/etc/group`: `gruppenname:x:GID:mitglieder,durch,komma,getrennt`

**Zu Schritt 6:** `/etc/passwd` muss für alle lesbar sein (`-rw-r--r--`), da viele Programme Benutzernamen und UIDs nachschlagen (z. B. `ls -l`). Die Passwort-Hashes stehen deshalb in `/etc/shadow`, die nur `root` und die Gruppe `shadow` lesen dürfen (`-rw-r-----`).

**Zu Schritt 7:** `w` zeigt in der ersten Zeile Uhrzeit, Laufzeit des Systems und Systemlast, außerdem in der Spalte `WHAT`, welches Programm in der Sitzung gerade läuft. `still logged in` bei `last` bedeutet, dass die Sitzung noch offen ist.

**Zu ⭐⭐ `su`/`sudo -i`:**

| Kommando | Passwort | `whoami` | `pwd` | `/usr/sbin` im `PATH` |
|---|---|---|---|---|
| `su` | von `root` | root | unverändert | nein (auf Debian) |
| `su -` | von `root` | root | `/root` | ja |
| `sudo -i` | eigenes | root | `/root` | ja |

`useradd` liegt in `/usr/sbin`. Ohne diesen Pfad im `PATH` findet die Shell das Kommando nicht.

**Zu ⭐⭐ gesperrte Passwörter:** `!` oder `*` im zweiten Feld – damit ist keine Anmeldung mit Passwort möglich. Bei `root` steht ein Hash, wenn bei der Installation ein Root-Passwort vergeben wurde.

**Zu ⭐⭐⭐ Pipeline:**

```bash
grep -v -E 'nologin|false' /etc/passwd | cut -d: -f1,3 | sort -t: -k2 -n
```

**Zu ⭐⭐⭐ Einbruchsversuch:**

```bash
sudo journalctl -u ssh | grep -i failed
```

Je nach System stehen die Einträge zusätzlich in `/var/log/auth.log` (falls `rsyslog` installiert ist).

</details>
