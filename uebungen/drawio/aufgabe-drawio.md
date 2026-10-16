# Aufgabe: Netzwerkplan mit draw.io

**Zeitrahmen:** ca. 60–90 Minuten
**Werkzeug:** [draw.io](https://app.diagrams.net) im Browser oder draw.io Desktop
**Ziel:** Du kannst in draw.io einen sauberen, lesbaren Netzwerkplan erstellen.

## Vorbereitung (ca. 15 Minuten)

Wer draw.io noch nie genutzt hat, schaut vorher in den Bereich [Getting Started](https://www.drawio.com/docs/) der offiziellen Doku.

Arbeite dann diese beiden kurzen Artikel durch (Englisch, aber mit vielen Bildern):

1. [Network and infrastructure diagrams](https://www.drawio.com/blog/network-diagrams.html): Welche Symbol-Bibliotheken gibt es, und wie aktiviert man sie?
2. [Networking shape library with customisable shadows](https://www.drawio.com/blog/network-library-shadow): Ein Heimnetz als Beispiel, dazu Netzzonen mit Farben.

## Szenario

Die **Kleinholz GmbH** (12 Mitarbeitende, eine Schreinerei mit Büro) braucht endlich einen Netzwerkplan. Bisher existiert das Netz nur im Kopf des Azubis, und der hat bald Prüfung.

### Bestandsaufnahme

| Gerät | Hostname | Netz | IP-Adresse |
|---|---|---|---|
| Internet-Anschluss (Glasfaser) | – | – | öffentliche IP vom Provider |
| Firewall / Router | fw01 | alle Zonen | 192.168.100.1 (DMZ), 10.10.10.1 (LAN) |
| Switch DMZ | sw-dmz | DMZ | – |
| Webserver (Firmenwebsite) | web01 | DMZ | 192.168.100.10 |
| Switch LAN | sw-lan | LAN | – |
| Server für DNS und DHCP | srv01 | LAN | 10.10.10.5 |
| Fileserver (Samba) | srv02 | LAN | 10.10.10.6 |
| Netzwerkdrucker | prn01 | LAN | 10.10.10.20 |
| WLAN-Access-Point | ap01 | LAN | 10.10.10.30 |
| 3 Büro-PCs | pc01–pc03 | LAN | per DHCP |
| Laptops der Werkstatt | – | LAN (über WLAN) | per DHCP |

**Netze:**
- DMZ: 192.168.100.0/24
- LAN: 10.10.10.0/24

## Aufgabe

Zeichne den Netzwerkplan der Kleinholz GmbH in draw.io. Dein Plan muss folgende Punkte erfüllen:

- [ ] Für die Geräte verwendest du **Netzwerksymbole** aus einer Netzwerk-Bibliothek, keine einfachen Rechtecke.
- [ ] Jedes Gerät ist mit **Hostname und IP-Adresse** beschriftet. Bei DHCP-Geräten steht „DHCP“.
- [ ] **DMZ und LAN** sind als farbige Zonen sichtbar, also als Rechteck im Hintergrund. Jede Zone trägt ihren Namen und das Netz, z. B. „LAN – 10.10.10.0/24“.
- [ ] Die **Verbindungen** zwischen den Geräten sind eingezeichnet. Die WLAN-Verbindung unterscheidet sich optisch von Kabelverbindungen, z. B. durch eine gestrichelte Linie.
- [ ] Der Plan ist **ordentlich ausgerichtet**: keine schiefen Linien und keine Symbole, die übereinander liegen.
- [ ] Eine kleine **Legende** erklärt Farben und Linienarten.
- [ ] Ein **Titelfeld** nennt Firma, Ersteller:in und Datum.

## Tipps

- **Symbole suchen statt suchen:** Gib im Suchfeld links oben einfach „router“, „firewall“ oder „server“ ein. Das geht schneller, als sich durch die Bibliotheken zu klicken.
- **Weitere Bibliotheken:** Ganz unten links findest du *Weitere Formen* (*More Shapes*). Dort aktivierst du im Abschnitt *Netzwerk* eine Netzwerk-Bibliothek.
- **Verbindungen:** Fahre mit der Maus über ein Symbol. Dann erscheinen blaue Pfeile, die du auf das Zielsymbol ziehst. So „kleben“ die Linien am Symbol und wandern mit, wenn du es verschiebst.
- **Ausrichten:** Markiere mehrere Symbole und nutze rechts im Bereich *Anordnen* die Ausrichten-Funktionen.
- **Zonen in den Hintergrund:** Das Zonen-Rechteck muss hinter den Geräten liegen. Dafür nutzt du *Anordnen → Nach hinten*.
- **Einfache Regel:** Ein Plan ist gut, wenn jemand Fremdes ihn ohne Erklärung versteht.

---

## Bonus (für Schnelle)

**Bonus 1 – Dienste-Ebene:** Lege eine zweite Ebene an (*Ansicht → Ebenen*). Trage darin ein, welche Dienste auf welchem Server laufen und welche Ports die Firewall von außen in die DMZ durchlässt. So kann man die Ebene ein- und ausblenden, und der Grundplan bleibt übersichtlich.

**Bonus 2 – Unser Lab:** Zeichne die Umgebung, in der du gerade arbeitest: deinen Rechner, die RDP-Verbindung, den Windows-Host mit Hyper-V, den virtuellen Switch und die VMs. Welche Teile sind physisch und welche virtuell? Mach diesen Unterschied im Plan sichtbar.

