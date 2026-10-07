# T3-03 – Sicherheitsaudit des eigenen Servers

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Und bei uns?
>
> Hallo IT,
>
> nach der Sache mit `pinguin-dev` schlafe ich schlecht. Kann so etwas auch auf **unserem** Server passieren? Bitte schaut nach, ob alles in Ordnung ist, und gebt mir eine kurze Liste: Was habt ihr geprüft, was habt ihr gefunden?
>
> Grete

Alle Schritte führt ihr **auf eurem Server** aus. Die meisten Prüfungen brauchen `sudo`, weil ihr in alle Verzeichnisse schauen müsst. Mit `2>/dev/null` blendet ihr Fehlermeldungen aus Verzeichnissen wie `/proc` aus. Die Option `-xdev` sorgt dafür, dass `find` auf dem Wurzeldateisystem bleibt und nicht in virtuelle Dateisysteme wie `/proc` oder `/dev/shm` wandert.

Haltet jede Prüfung im Logbuch in dieser Tabelle fest:

| Nr. | Prüfung | Kommando | Befund | Bewertung (in Ordnung / prüfen) |
|---|---|---|---|---|

## ⭐ Pflicht

### Prüfung 1: Wer hat Root-Rechte?

1. Sucht in `/etc/passwd` alle Konten mit der UID 0. Tipp: `awk -F: '$3 == 0' /etc/passwd` gibt alle Zeilen aus, deren drittes Feld 0 ist.
2. Lasst euch die Mitglieder der Gruppe `sudo` anzeigen (`getent group sudo`). Sind das genau eure Admin-Konten?
3. Bewertet: Gibt es außer `root` ein Konto mit UID 0? Ist jemand in `sudo`, der dort nicht hingehört?

### Prüfung 2: Konten ohne Passwort

1. Sucht in `/etc/shadow` alle Konten, deren zweites Feld **leer** ist (`sudo awk -F: '$2 == ""' /etc/shadow`).
2. Ein leeres Feld bedeutet: Anmeldung ohne Passwort möglich. Was steht stattdessen bei den Systemkonten und bei `pinguin-backup`?

### Prüfung 3: Hinterlegte SSH-Schlüssel

Beim Einbruch auf `pinguin-dev` hat der Angreifer einen Schlüssel hinterlegt (T3-02 ⭐⭐⭐).

1. Sucht in `/home` und `/root` nach allen Dateien mit dem Namen `authorized_keys`.
2. Notiert, wie viele ihr findet und wem sie gehören. Wisst ihr bei jeder Datei, warum sie da ist?

### Prüfung 4: Programme mit SUID-Bit

1. Sucht alle Dateien mit SUID-Bit (`-perm -4000`) auf dem Wurzeldateisystem.
2. Notiert die Anzahl. Vergleicht die Liste mit der Übersicht in Hilfekarte 3: Ist ein Programm dabei, das dort nicht steht?

### Prüfung 5: Für alle beschreibbar

1. Sucht alle **Dateien**, die für `others` beschreibbar sind (`-type f -perm -0002`).
2. Sucht alle **Verzeichnisse**, die für `others` beschreibbar sind, aber **kein** Sticky Bit haben (`-type d -perm -0002 ! -perm -1000`).
3. Warum ist ein Verzeichnis, in das jede Person schreiben kann, ohne Sticky Bit gefährlich? (T2-03)

### Prüfung 6: Herrenlose Dateien

1. Sucht alle Dateien, die keinem existierenden Konto (`-nouser`) oder keiner existierenden Gruppe (`-nogroup`) gehören. Zwei Bedingungen verknüpft ihr mit `-o` und Klammern: `\( -nouser -o -nogroup \)`.
2. Wenn ihr T2-06 sauber abgeschlossen habt, sollte nichts gefunden werden.

### Prüfung 7: Was hat sich kürzlich verändert?

1. Sucht in `/etc` alle Dateien, die in den letzten drei Tagen verändert wurden (`-mtime -3`).
2. Ordnet jede gefundene Datei einer Aufgabe aus den letzten Tagen zu. Zum Beispiel: `/etc/group` → T1-03 und T1-05. Gibt es eine Datei, die ihr nicht erklären könnt?

### Prüfung 8: Fehlgeschlagene Anmeldungen auf eurem Server

1. Lasst euch mit `journalctl` die Meldungen des SSH-Dienstes von heute anzeigen und zählt die Zeilen mit `Failed password`:

   ```bash
   sudo journalctl -u ssh --since today | grep -c 'Failed password'
   ```

2. Ermittelt wie in T3-02, von welchen IP-Adressen die Fehlversuche kamen. Waren das Angreifer oder Kolleginnen und Kollegen aus dem Kurs?

### Bericht an Grete

Schreibt im Logbuch eine kurze Antwort an Grete: Was habt ihr geprüft (8 Punkte), was war in Ordnung, was müsst ihr euch noch genauer anschauen?

## ⭐⭐ Erweiterung: Die SSH-Konfiguration

1. Lasst euch die **tatsächlich gültige** Konfiguration des SSH-Servers ausgeben und filtert die wichtigsten Einstellungen:

   ```bash
   sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries)'
   ```

2. Vergleicht mit der Datei `/etc/ssh/sshd_config`. Warum stehen dort die meisten Einstellungen nur auskommentiert?
3. Welche dieser Einstellungen hätten den Einbruch auf `pinguin-dev` verhindert?
4. Lasst euch mit `sudo ss -tlnp` anzeigen, welche Dienste von außen erreichbar sind. Ist das wirklich nur SSH?

Ändert die Konfiguration **nicht** – sonst kommt ihr womöglich nicht mehr auf euren Server.

## ⭐⭐⭐ Profi: Anmeldung mit SSH-Schlüssel

Ihr richtet für **euer eigenes** Admin-Konto die Anmeldung per Schlüssel ein – so, wie es auf `pinguin-dev` sicher gewesen wäre.

1. Erzeugt **auf eurem Arbeitsplatz** (nicht auf dem Server) ein Schlüsselpaar: `ssh-keygen -t ed25519`. Vergebt eine Passphrase.
2. Schaut euch die beiden neuen Dateien in `~/.ssh` an. Welche davon ist geheim, welche darf jeder sehen? Vergleicht ihre Rechte.
3. Kopiert den öffentlichen Schlüssel auf den Server: `ssh-copy-id <euer-konto>@<server>`
4. Meldet euch erneut per SSH an. Was wird jetzt abgefragt – das Passwort oder die Passphrase?
5. Wiederholt **Prüfung 3** auf dem Server. Was findet ihr jetzt? Welche Rechte haben `~/.ssh` und `~/.ssh/authorized_keys`?
6. Gebt testweise der Gruppe Schreibrecht an eurer `authorized_keys` (`chmod g+w ~/.ssh/authorized_keys`) und meldet euch in einem **zweiten** Terminal neu an. Was passiert? Sucht die Erklärung im Journal (`sudo journalctl -u ssh -n 20`). Setzt die Rechte danach wieder auf `600`.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- `find`: `man find` – Suchbegriffe `-name`, `-perm`, `-type`, `-nouser`, `-nogroup`, `-mtime`, `-xdev`
- `-perm -4000` bedeutet „mindestens diese Bits gesetzt“. Mit `!` vor einem Test wird er verneint.
- `-mtime -3` = vor weniger als drei Tagen verändert
- Konten und Gruppen: `/etc/passwd`, `/etc/shadow`, `getent group <gruppe>`
- SSH-Server: `man sshd_config` (u. a. `PermitRootLogin`, `PasswordAuthentication`, `StrictModes`)

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
awk -F: '$3 == 0' /etc/passwd
getent group sudo
sudo awk -F: '$2 == ""' /etc/shadow
sudo find /home /root -name authorized_keys
sudo find / -xdev -type f -perm -4000 2>/dev/null
sudo find / -xdev -type f -perm -0002 2>/dev/null
sudo find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null
sudo find / -xdev \( -nouser -o -nogroup \) 2>/dev/null
sudo find /etc -type f -mtime -3
sudo journalctl -u ssh --since today | grep 'Failed password'
sudo sshd -T
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

**Prüfung 1:** Nur `root` hat die UID 0. In `sudo` stehen genau eure persönlichen Admin-Konten.

**Prüfung 2:** Keine Ausgabe. Systemkonten und `pinguin-backup` haben im zweiten Feld `!` oder `*` – damit ist eine Anmeldung mit Passwort **unmöglich**, nicht ohne Passwort möglich.

**Prüfung 3:** Habt ihr selbst keine Schlüssel eingerichtet (⭐⭐⭐), sollte es keine `authorized_keys` geben. Ausnahmen: VMs, die aus einem Cloud-Image erstellt wurden, bekommen bei der Installation oft Schlüssel für das erste Konto und für `root` eingetragen. Dann klärt ihr, wem der Schlüssel gehört (der Kommentar am Ende der Zeile verrät es meist). Jede Datei, deren Herkunft ihr nicht kennt, ist ein Alarmzeichen.

**Prüfung 4:** Auf einem frischen Debian 13 etwa ein Dutzend Programme, z. B.:

```text
/usr/bin/chfn  /usr/bin/chsh  /usr/bin/gpasswd  /usr/bin/mount  /usr/bin/newgrp
/usr/bin/passwd  /usr/bin/su  /usr/bin/sudo  /usr/bin/umount
/usr/lib/dbus-1.0/dbus-daemon-launch-helper  /usr/lib/openssh/ssh-keysign
/usr/lib/polkit-1/polkit-agent-helper-1
```

Je nach installierten Paketen kommen einzelne Programme hinzu (z. B. `fusermount3`). Ein SUID-Programm in `/home`, `/tmp` oder `/srv` wäre ein deutliches Alarmzeichen.

**Prüfung 5:** Normalerweise keine Dateien. Verzeichnisse, die für alle beschreibbar sind, haben das Sticky Bit (`/tmp`, `/var/tmp`) und tauchen deshalb nicht auf. Ohne Sticky Bit könnte jede Person dort fremde Dateien löschen oder austauschen.

**Prüfung 6:** Keine Ausgabe, wenn in T2-06 alle Dateien von Oskar übergeben wurden.

**Prüfung 7:** Die Liste hängt stark davon ab, wie und wann die VM installiert wurde (bei frisch aus einem Cloud-Image erstellten VMs z. B. auch `/etc/ssh/ssh_host_*`, `/etc/netplan/…`, `/etc/cloud/…`). Typische Funde aus dem Projekt und ihre Herkunft: `/etc/hostname`, `/etc/hosts` (T1-01), `/etc/passwd`, `/etc/shadow`, `/etc/group`, `/etc/gshadow` und ihre Sicherungskopien mit `-` am Ende (T1-01 bis T2-06), `/etc/skel/…` (T1-03 ⭐⭐), evtl. `/etc/subuid` und `/etc/subgid` (neue Konten). Je nach Netzwerk auch `/etc/resolv.conf` (wird beim Start per DHCP geschrieben).

**Prüfung 8:** Die Fehlversuche stammen von den Arbeitsplätzen eures Teams oder von anderen Teams aus dem Kurs (T1-02 ⭐⭐⭐, T1-05) – im Kursnetz gibt es keine Angreifer aus dem Internet.

**⭐⭐:**

```text
permitrootlogin without-password
pubkeyauthentication yes
passwordauthentication yes
maxauthtries 6
```

`without-password` ist der alte Name für `prohibit-password`: `root` darf sich nur mit Schlüssel anmelden. In `sshd_config` stehen auskommentierte Zeilen, um die **Standardwerte** zu zeigen – `sshd -T` zeigt, was tatsächlich gilt. Auf `pinguin-dev` hätte `PasswordAuthentication no` den Einbruch verhindert: Ohne Passwort-Anmeldung hilft das Erraten nichts. `ss -tlnp` zeigt `sshd` auf Port 22 und, falls `systemd-resolved` läuft, Port 53 nur auf `127.0.0.53`/`127.0.0.54` sowie Port 5355 (LLMNR) – siehe T3-01 ⭐⭐.

**⭐⭐⭐:** `id_ed25519` ist der **private** Schlüssel (`-rw-------`, niemals weitergeben), `id_ed25519.pub` der **öffentliche** (`-rw-r--r--`). `ssh-copy-id` hängt den öffentlichen Schlüssel an `~/.ssh/authorized_keys` auf dem Server an. Bei der Anmeldung wird die Passphrase des Schlüssels abgefragt, nicht das Passwort. Auf dem Server haben `~/.ssh` die Rechte `700` und `authorized_keys` die Rechte `600`.

Mit `g+w` an `authorized_keys` lehnt `sshd` den Schlüssel ab und fragt wieder nach dem Passwort. Im Journal steht `Authentication refused: bad ownership or modes for file …/authorized_keys`. Grund ist die Einstellung `StrictModes yes`: Wenn andere die Datei ändern könnten, könnten sie dort ihren eigenen Schlüssel eintragen.

</details>
