# T3-01: Server-Steckbrief

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Was steht da eigentlich?
>
> Hallo IT,
>
> unsere Versicherung möchte wissen, welche Technik wir einsetzen, und der Steuerberater fragt, was der Server „kann“. Ehrlich gesagt weiß ich das selbst nicht.
>
> Könnt ihr mir einen **Steckbrief** des Servers schreiben, auf einer Seite, als Textdatei in meinem Ordner? Was steckt drin, welches System läuft, wie ist er ans Netz angeschlossen?
>
> Grete

Alle Schritte führt ihr **auf dem Server** aus. Bis auf Schritt 4 braucht ihr kein `sudo`.

## Pflicht

### Schritt 1: Informationen sammeln

Führt die Kommandos aus und tragt die Werte im Logbuch ein. Überlegt bei jeder Zeile: Kommt die Information aus einer **Datei** oder aus einem **Programm**?

| Angabe | Kommando | Wert |
|---|---|---|
| Hostname | `hostname` | |
| Distribution und Version | `cat /etc/os-release` | |
| Kernel-Version | `uname -r` | |
| Prozessor (Modell) | `grep "model name" /proc/cpuinfo` | |
| Anzahl der CPU-Kerne | `nproc` | |
| Arbeitsspeicher gesamt / frei | `free -h` | |
| Größe und Belegung des Wurzeldateisystems | `df -h /` | |
| IPv4-Adresse | `ip -4 addr` | |
| Standard-Gateway | `ip route` | |
| DNS-Server | `cat /etc/resolv.conf` | |
| Laufzeit seit dem letzten Start | `uptime -p` | |

1. Warum gibt `grep "model name" /proc/cpuinfo` mehrere gleiche Zeilen aus, wenn der Server mehrere Kerne hat? Prüft mit `grep -c`.
2. Welche Zeile von `ip route` enthält das Standard-Gateway? Woran erkennt ihr sie?
3. `/proc/cpuinfo` ist eine Datei, aber `ls -l /proc/cpuinfo` zeigt die Größe 0. Notiert eine Vermutung, was `/proc` ist.
4. Steht in `/etc/resolv.conf` als DNS-Server `127.0.0.53`? Das ist eine Adresse auf dem Server **selbst**. Lest die Kommentare oben in der Datei: Wer beantwortet dort die DNS-Anfragen? Mit `resolvectl status` seht ihr, an welche DNS-Server die Anfragen weitergereicht werden. Tragt beide in die Tabelle ein.

### Schritt 2: Den Steckbrief zusammenbauen

Ihr schreibt die Ausgaben nacheinander in die Datei `~/steckbrief.txt`.

1. Die erste Zeile **überschreibt** eine eventuell vorhandene Datei:

   ```bash
   echo "Steckbrief des Servers $(hostname), erstellt am $(date '+%d.%m.%Y %H:%M')" > ~/steckbrief.txt
   ```

2. Alle weiteren Angaben **hängt** ihr mit `>>` an. Schreibt vor jede Angabe eine Überschrift, zum Beispiel:

   ```bash
   echo "" >> ~/steckbrief.txt
   echo "== Distribution ==" >> ~/steckbrief.txt
   grep PRETTY_NAME /etc/os-release >> ~/steckbrief.txt
   ```

3. Ergänzt auf diese Weise **alle** Angaben aus der Tabelle in Schritt 1. Nehmt für die Distribution nur die Zeile `PRETTY_NAME`, für den Prozessor nur **eine** Zeile (Tipp: `head -n 1`) und für den DNS-Server nur die Zeilen mit `nameserver`.
4. Lasst euch das Ergebnis mit `cat ~/steckbrief.txt` anzeigen. Steht jede Angabe genau **einmal** drin?
5. Habt ihr aus Versehen `>` statt `>>` verwendet? Dann fehlt alles davor. Fangt mit Punkt 1 neu an.

### Schritt 3: Was steckt in den Platzhaltern?

1. In Schritt 2.1 stehen `$(hostname)` und `$(date …)`. Führt zum Vergleich `echo "Heute ist $(date +%A)"` und `echo 'Heute ist $(date +%A)'` aus.
2. Notiert im Logbuch, was `$( … )` bewirkt und warum es in einfachen Anführungszeichen nicht funktioniert.

### Schritt 4: Ablage für Grete

1. Kopiert den Steckbrief mit `sudo` nach `/srv/firma/geschaeftsfuehrung/server-steckbrief.txt`.
2. Prüft mit `ls -l /srv/firma/geschaeftsfuehrung`: Welcher Besitzer, welche Gruppe? Warum gehört die Datei der Gruppe `geschaeftsfuehrung`, obwohl ihr sie als `root` angelegt habt? (Erinnert euch an T2-02.)
3. Testet als Grete (`sudo -iu gfrost`), ob sie den Steckbrief lesen kann.

### Selbstkontrolle

Führt das Check-Skript aus. Im Abschnitt **T3-01** sollten alle Punkte grün sein.

### Abnahmekriterien

- `/srv/firma/geschaeftsfuehrung/server-steckbrief.txt` existiert und gehört der Gruppe `geschaeftsfuehrung`.
- Der Steckbrief enthält den Hostnamen, die Zeile `PRETTY_NAME`, die Ausgabe von `free -h` (Zeile `Mem:`), die Zeile mit dem Standard-Gateway (`default via`) und mindestens eine Zeile `nameserver`.
- Grete kann den Steckbrief lesen.

## Erweiterung: Prozesse und Dienste

Grete möchte außerdem wissen, was auf dem Server **läuft**.

1. Zählt die laufenden Prozesse: `ps -e --no-headers | wc -l`
2. Lasst euch die fünf Prozesse mit dem größten Speicherverbrauch anzeigen. Sucht in `man ps` nach der Option `--sort` und nach dem Feld `%mem`. Achtet darauf, dass die Kopfzeile mitgezählt wird.
3. Startet `top`. Welcher Prozess braucht gerade am meisten CPU? Wie viele Prozesse hat `top` gezählt (Zeile `Tasks`)? Beendet `top` mit `q`.
4. Lasst euch mit `sudo ss -tlnp` anzeigen, auf welchen Netzwerk-Ports der Server Verbindungen annimmt. Welches Programm lauscht auf Port 22? Gibt es weitere?
5. Hängt die Ausgaben von Punkt 2 und 4 mit passenden Überschriften an den Steckbrief an und kopiert ihn erneut zu Grete.

## Profi: Hardware und Virtualisierung

1. Führt `hostnamectl` aus. Welche Angaben aus Schritt 1 findet ihr dort auf einen Blick? Welche zusätzliche Angabe verrät, dass der Server eine VM ist?
2. Prüft mit `systemd-detect-virt`, unter welcher Virtualisierung der Server läuft.
3. Lasst euch mit `lsblk` die Festplatten und Partitionen anzeigen. Wie heißt die Festplatte unter `/dev`? Wie viele Partitionen hat sie?
4. Lasst euch mit `lspci` die (virtuelle) Hardware anzeigen. Fehlt das Kommando, installiert das Paket `pciutils`. Findet ihr die Netzwerkkarte und den Festplatten-Controller?
5. Lasst euch mit `sudo dmesg | head -n 20` die ersten Meldungen des Kernels beim Start anzeigen. Notiert, was ihr wiedererkennt.
6. Vergleicht `free` mit `grep -E 'MemTotal|MemAvailable' /proc/meminfo`. Woher hat `free` seine Zahlen?

---

## Hilfekarten

<details>
<summary>Hilfekarte 1: Wo steht's?</summary>

- `/proc` ist ein virtuelles Dateisystem: Der Kernel erzeugt den Inhalt beim Lesen. Dort stehen u. a. `cpuinfo`, `meminfo` und für jeden Prozess ein Verzeichnis mit seiner PID.
- Distribution: `/etc/os-release`, Kernel: `man uname`
- Netzwerk: `man ip-address`, `man ip-route`, DNS: `man resolv.conf`, bei `nameserver 127.0.0.53` zusätzlich `man systemd-resolved` und `resolvectl status`
- Redirects: `>` überschreibt, `>>` hängt an.
- Befehlssubstitution `$( … )`: Die Shell führt das Kommando aus und setzt seine Ausgabe an dieser Stelle ein, nur in doppelten Anführungszeichen oder ganz ohne.
- Prozesse: `man ps` (`--sort`), `man top`, Netzwerk-Ports: `man ss`

</details>

<details>
<summary>Hilfekarte 2: Welche Kommandos?</summary>

```text
grep -c "model name" /proc/cpuinfo
grep "model name" /proc/cpuinfo | head -n 1 >> ~/steckbrief.txt
free -h >> ~/steckbrief.txt
df -h / >> ~/steckbrief.txt
ip -4 addr >> ~/steckbrief.txt
ip route | grep default >> ~/steckbrief.txt
grep nameserver /etc/resolv.conf >> ~/steckbrief.txt
sudo cp ~/steckbrief.txt /srv/firma/geschaeftsfuehrung/server-steckbrief.txt
ps aux --sort=-%mem | head -n 6
sudo ss -tlnp
```

</details>

<details>
<summary>Hilfekarte 3: Lösung</summary>

```bash
# Schritt 2
S=~/steckbrief.txt
echo "Steckbrief des Servers $(hostname), erstellt am $(date '+%d.%m.%Y %H:%M')" > $S
echo "" >> $S; echo "== Distribution ==" >> $S; grep PRETTY_NAME /etc/os-release >> $S
echo "" >> $S; echo "== Kernel ==" >> $S; uname -r >> $S
echo "" >> $S; echo "== Prozessor ==" >> $S; grep "model name" /proc/cpuinfo | head -n 1 >> $S
echo "Kerne: $(nproc)" >> $S
echo "" >> $S; echo "== Arbeitsspeicher ==" >> $S; free -h >> $S
echo "" >> $S; echo "== Festplatte ==" >> $S; df -h / >> $S
echo "" >> $S; echo "== Netzwerk ==" >> $S; ip -4 addr >> $S
ip route | grep default >> $S
grep nameserver /etc/resolv.conf >> $S
echo "" >> $S; echo "== Laufzeit ==" >> $S; uptime -p >> $S
cat $S

# Schritt 4
sudo cp ~/steckbrief.txt /srv/firma/geschaeftsfuehrung/server-steckbrief.txt
ls -l /srv/firma/geschaeftsfuehrung
sudo -iu gfrost cat /srv/firma/geschaeftsfuehrung/server-steckbrief.txt
```

Die Variable `S` ist nur eine Abkürzung zum Tippen. Mehr zu Variablen in T3-05.

**Schritt 1:** `/proc/cpuinfo` enthält einen Block pro CPU-Kern, deshalb steht `model name` mehrfach drin. Das Standard-Gateway steht in der Zeile `default via <IP> dev <schnittstelle>`. `/proc` ist ein **virtuelles Dateisystem**: Die Dateien liegen nicht auf der Festplatte, der Kernel erzeugt ihren Inhalt in dem Moment, in dem man sie liest, deshalb die Größe 0. Aus Dateien kommen Distribution, Prozessor, DNS-Server; aus Programmen der Rest (die ihre Daten aber oft selbst aus `/proc` lesen).

`nameserver 127.0.0.53` bedeutet: Auf dem Server läuft `systemd-resolved` als lokaler Zwischenspeicher (*DNS-Stub*). Programme fragen ihn, er fragt die eigentlichen DNS-Server und merkt sich die Antworten. Welche das sind, zeigt `resolvectl status` (Zeilen `Current DNS Server` und `DNS Servers`). Steht in `/etc/resolv.conf` dagegen direkt eine andere Adresse, wird ohne Zwischenspeicher gefragt.

**Schritt 3:** In doppelten Anführungszeichen ersetzt die Shell `$( … )` durch die Ausgabe des Kommandos (*Befehlssubstitution*). In einfachen Anführungszeichen bleibt alles wörtlich stehen.

**Schritt 4:** `cp` legt eine **neue** Datei an. Der Ordner hat das SGID-Bit, deshalb gehört die Datei der Gruppe `geschaeftsfuehrung`, Besitzer ist `root`. Mit den Rechten `644` darf Grete sie als Mitglied der Gruppe lesen.

**Erweiterung:**

```bash
ps -e --no-headers | wc -l
ps aux --sort=-%mem | head -n 6          # 1 Kopfzeile + 5 Prozesse
sudo ss -tlnp                             # Port 22: sshd
```

Von außen erreichbar ist meist nur `sshd` auf Port 22 (IPv4 `0.0.0.0:22` und IPv6 `[::]:22`). Läuft `systemd-resolved`, lauscht es zusätzlich auf Port 53, aber nur auf `127.0.0.53` und `127.0.0.54` (also nur für den Server selbst), und auf Port 5355 (LLMNR, Namensauflösung im lokalen Netz ohne DNS-Server). `-t` = TCP, `-l` = lauschend (*listening*), `-n` = Zahlen statt Namen, `-p` = Prozess anzeigen (braucht `sudo`).

**Profi:** `hostnamectl` zeigt u. a. Betriebssystem, Kernel, Architektur und eine Zeile `Virtualization` (z. B. `oracle` für VirtualBox oder `kvm`). Die Festplatte heißt meist `/dev/sda` oder `/dev/vda`. `free` liest seine Zahlen aus `/proc/meminfo`.

</details>
