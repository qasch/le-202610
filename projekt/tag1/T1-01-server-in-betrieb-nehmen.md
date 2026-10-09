# T1-01: Server in Betrieb nehmen

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Unser neuer Server
>
> Hallo IT,
>
> der neue Server steht bereit, und per SSH kommt ihr auch schon drauf, allerdings nur über das eine Konto, das bei der Installation angelegt wurde. Bitte richtet ihn so ein, dass **jede Person** von ihrem Arbeitsplatz aus mit einem **eigenen** Konto darauf arbeiten kann. Und bitte nicht alle mit dem Root-Passwort. Ich habe gehört, das macht man nicht mehr so.
>
> Danke! Grete

## Pflicht

### Schritt 1: Server festlegen

1. Entscheidet, wessen VM der Server wird. Nehmt eine VM, deren `root`-Passwort ihr kennt.
2. Tragt im Logbuch ein, wessen VM der Server ist. Die anderen beiden VMs sind ab jetzt eure **Arbeitsplätze**.
3. Legt in eurer Virtualisierungssoftware einen **Snapshot** der Server-VM an und nennt ihn `vor-projekt`.

> Alle folgenden Schritte bis einschließlich Schritt 6 führt ihr **auf dem Server** als `root` aus. Die VM-Besitzerin bzw. der VM-Besitzer meldet sich dazu von einem Arbeitsplatz aus per SSH mit dem vorhandenen Konto am Server an und wechselt mit `su -` in eine Root-Shell. Die anderen schauen zu und navigieren.

### Schritt 2: Hostnamen setzen

1. Lasst euch mit `hostname` den aktuellen Namen des Servers anzeigen und notiert ihn.
2. Ändert den Hostnamen auf `pinguin-team<N>`. Eure Teamnummer `<N>` bekommt ihr vom Trainer.
3. Öffnet die Datei `/etc/hosts` in einem Editor. Ersetzt in der Zeile, die mit `127.0.1.1` beginnt, den alten Namen durch den neuen.
4. Prüft mit `hostname`, ob der neue Name gesetzt ist.

### Schritt 3: IP-Adresse für die Tafel

Die IP-Adresse kennt ihr schon, sonst hättet ihr euch nicht verbinden können. Jetzt seht ihr nach, wo der Server sie selbst anzeigt.

1. Lasst euch die Netzwerkschnittstellen des Servers anzeigen.
2. Sucht die Schnittstelle, die **nicht** `lo` heißt, und dort die Zeile, die mit `inet` beginnt.
3. Notiert im Logbuch den Namen der Schnittstelle und die IPv4-Adresse (z. B. `enp1s0`, `192.168.100.23/24`). Ist es dieselbe Adresse, mit der ihr euch verbunden habt?
4. Tragt Hostname und IP-Adresse in die Tabelle an der Tafel ein.

### Schritt 4: SSH-Server prüfen

Dass SSH funktioniert, wisst ihr schon. Aber woran erkennt man das auf dem Server?

1. Prüft mit `systemctl status ssh`, ob der SSH-Dienst läuft. Achtet auf die Zeilen `Loaded:` und `Active:`.
2. Notiert im Logbuch: Seit wann läuft der Dienst? Steht in der Zeile `Loaded:` hinter dem Pfad `enabled`? Und was bedeutet das für einen Neustart des Servers?

### Schritt 5: `sudo` installieren

1. Prüft mit `command -v sudo`, ob `sudo` installiert ist. Gibt das Kommando nichts aus, ist es nicht installiert.
2. Installiert in diesem Fall das Paket `sudo`.

### Schritt 6: Persönliche Admin-Konten anlegen

Die Person, der die VM gehört, hat bereits ein Konto. Die beiden anderen bekommen jetzt eins.

1. Legt mit `adduser <benutzername>` ein Konto für jedes Teammitglied an, das noch keines auf dem Server hat.
   - Als Benutzernamen nehmt ihr den Vornamen in Kleinbuchstaben.
   - Das Passwort tippt die **Person selbst** ein, nicht jemand anderes.
   - Die weiteren Fragen (Name, Raumnummer …) könnt ihr mit Enter überspringen.
2. Fügt **alle drei** persönlichen Konten (auch das der VM-Besitzerin bzw. des VM-Besitzers) der Gruppe `sudo` hinzu.
3. Kontrolliert mit `grep sudo /etc/group`, ob alle drei Namen in der Zeile stehen.
4. Verlasst die Root-Shell mit `exit`.

### Schritt 7: Anmeldung von den Arbeitsplätzen testen

Jede Person führt diese Schritte **an ihrem eigenen Arbeitsplatz** aus (die VM-Besitzerin bzw. der VM-Besitzer meldet sich am Server einmal neu an):

1. Verbindet euch mit `ssh <benutzername>@<ip-des-servers>`.
2. Habt ihr euch von diesem Arbeitsplatz aus noch nie mit dem Server verbunden, fragt SSH, ob ihr ihm vertraut (*fingerprint*). Antwortet mit `yes`. Wart ihr schon verbunden, kommt die Frage nicht, auch nicht nach dem neuen Hostnamen: SSH erkennt den Server an seinem Schlüssel, nicht an seinem Namen.
3. Führt nacheinander aus und notiert die Ausgaben:
   - `hostname`, erwartet: `pinguin-team<N>`
   - `whoami`, erwartet: euer Benutzername
   - `sudo whoami`, erwartet: `root` (nach Eingabe **eures eigenen** Passworts)

### Schritt 8: Selbstkontrolle

1. Ladet das Check-Skript von GitHub auf den Server:

   ```bash
   wget https://raw.githubusercontent.com/qasch/le-202610/main/projekt/check/check-tag1.sh
   ```

2. Führt es aus: `sudo bash check-tag1.sh`
3. Im Abschnitt **T1-01** sollten alle Punkte grün sein. Die übrigen Abschnitte sind noch rot. Das ist richtig so.

### Abnahmekriterien

- Der Hostname lautet `pinguin-team<N>` und ist in `/etc/hosts` eingetragen.
- Der SSH-Dienst läuft.
- `sudo` ist installiert.
- Alle drei persönlichen Konten sind Mitglied der Gruppe `sudo`.
- Alle Teammitglieder können sich per SSH anmelden, und `sudo whoami` liefert `root`.

## Erweiterung

### Gruppenzugehörigkeit und Anmeldung

1. Legt mit `sudo adduser testadmin` ein Testkonto an.
2. Eine Person meldet sich von ihrem Arbeitsplatz aus per SSH als `testadmin` an und führt `id` aus. Notiert die Ausgabe.
3. Eine **andere** Person fügt `testadmin` in ihrer eigenen Sitzung der Gruppe `sudo` hinzu.
4. Die Person in der `testadmin`-Sitzung führt erneut `id` und dann `sudo whoami` aus. Was passiert?
5. Die Person meldet sich mit `exit` ab, wieder an und führt erneut `id` und `sudo whoami` aus.
6. Erklärt im Logbuch, warum sich das Ergebnis erst nach der neuen Anmeldung ändert.
7. Löscht das Testkonto wieder: `sudo deluser --remove-home testadmin`

### Server über seinen Namen erreichen

1. Prüft an eurem Arbeitsplatz mit `ping -c 2 pinguin-team<N>`, ob der Name aufgelöst wird. Notiert die Fehlermeldung.
2. Tragt an **jedem** Arbeitsplatz in die Datei `/etc/hosts` eine Zeile mit der IP-Adresse und dem Namen des Servers ein.
3. Wiederholt den `ping`. Verbindet euch anschließend mit `ssh <benutzername>@pinguin-team<N>`.

## Profi

### Die Konfiguration von `sudo` verstehen

1. Lasst euch die Datei `/etc/sudoers` mit `sudo cat /etc/sudoers` anzeigen. **Bearbeitet sie nicht.**
2. Sucht die Zeile, die mit `%sudo` beginnt, und übertragt sie ins Logbuch.
3. Erklärt jeden der vier Teile: `%sudo`, das erste `ALL`, `(ALL:ALL)` und das letzte `ALL`.
4. Findet heraus, mit welchem Kommando man diese Datei bearbeiten soll, und warum man sie nicht mit einem normalen Editor öffnen sollte.

### Root-Anmeldung per SSH

1. Versucht von eurem Arbeitsplatz aus `ssh root@<ip-des-servers>` mit dem richtigen Root-Passwort. Notiert das Ergebnis.
2. Sucht in der Datei `/etc/ssh/sshd_config` nach `PermitRootLogin`. Notiert den Wert und ob die Zeile auskommentiert ist.
3. Erklärt im Logbuch, was der Wert bedeutet und warum das ein sinnvoller Standard ist.

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- Hostname: `man hostnamectl`, außerdem die Dateien `/etc/hostname` und `/etc/hosts`
- Dienste: `man systemctl`. `enabled` bedeutet „wird beim Start automatisch gestartet“
- IP-Adresse: Kapitel Netzwerkkonfiguration in der Dokumentation
- Pakete installiert ihr als `root` mit `apt`.
- Gruppen eines Kontos ändern: `man usermod`. Lest die Beschreibung der Optionen `-a` und `-G`.

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
su -
hostnamectl hostname ...
nano /etc/hosts
ip a
systemctl status ssh
apt install sudo
adduser ...
usermod -aG ...
ssh ...
```

**Typischer Stolperstein:** `sudo` meldet `unable to resolve host pinguin-team<N>`? Dann fehlt der neue Hostname in `/etc/hosts`.

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

Auf dem Server als `root`:

```bash
su -

# Schritt 2: Hostname setzen
hostnamectl hostname pinguin-team3
nano /etc/hosts          # Zeile ändern zu:  127.0.1.1   pinguin-team3
hostname

# Schritt 3: IP-Adresse ermitteln (Eintrag "inet" der Schnittstelle, nicht lo)
ip a

# Schritt 4 und 5: SSH-Server prüfen, sudo installieren
systemctl status ssh     # Loaded: … enabled …   Active: active (running) since …
apt update
apt install sudo

# Schritt 6: Admin-Konten anlegen und zur Gruppe sudo hinzufügen. Das -a ist wichtig!
adduser anna
usermod -aG sudo anna
usermod -aG sudo ben
usermod -aG sudo carla
grep sudo /etc/group
```

Auf den Arbeitsplätzen (Schritt 7):

```bash
ssh anna@192.168.100.23
hostname
whoami
sudo whoami      # Ausgabe: root
```

**`hostnamectl hostname` oder `hostnamectl set-hostname`?** Bis systemd 248 hieß der Befehl `set-hostname`. Seit systemd 249 gibt es nur noch `hostname`: ohne Argument zeigt er den Namen an, mit Argument setzt er ihn. Der alte Name funktioniert weiter, steht aber nicht mehr in der Manpage. Viele Anleitungen im Netz verwenden noch `set-hostname`. Die Manpage beschreibt immer die Version, die auf **eurem** System installiert ist.

**Schritt 4:** `enabled` in der Zeile `Loaded:` bedeutet, dass der Dienst beim Systemstart automatisch gestartet wird. Hinter `Active: active (running) since` steht, seit wann er läuft, meist seit dem letzten Start der VM.

**Warum `sudo` statt Root-Passwort?** Jede Person meldet sich mit ihrem eigenen Passwort an, jede Aktion ist einer Person zuzuordnen, und wenn jemand das Team verlässt, wird nur dessen Konto deaktiviert. Das Root-Passwort muss nicht geändert werden.

**Zu Erweiterung Gruppenzugehörigkeit:** Gruppenzugehörigkeiten werden beim Anmelden festgelegt. Eine bereits laufende Sitzung kennt die neue Gruppe noch nicht. Erst nach einer neuen Anmeldung erscheint `sudo` in der Ausgabe von `id`.

**Zu Erweiterung Name statt IP:** Auf jedem Arbeitsplatz in `/etc/hosts` eine Zeile ergänzen: `192.168.100.23   pinguin-team3`

**Zu Profi sudoers:** `%sudo ALL=(ALL:ALL) ALL`: Mitglieder der Gruppe `sudo` (`%` kennzeichnet eine Gruppe) dürfen auf allen Hosts (`ALL`) als beliebiger Benutzer und beliebige Gruppe (`(ALL:ALL)`) alle Kommandos (`ALL`) ausführen. Bearbeitet wird die Datei mit `visudo`: Es prüft die Syntax vor dem Speichern. Ein Tippfehler in `/etc/sudoers` kann sonst dazu führen, dass niemand mehr `sudo` benutzen kann.

**Zu Profi Root-Anmeldung:** In `/etc/ssh/sshd_config` steht (meist auskommentiert, also als Standard) `PermitRootLogin prohibit-password`: `root` darf sich nur mit SSH-Schlüssel anmelden, nicht mit Passwort. Das schützt vor Angriffen, die Root-Passwörter durchprobieren.

</details>
