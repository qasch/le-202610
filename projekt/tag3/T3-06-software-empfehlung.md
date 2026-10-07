# T3-06 – Software-Empfehlung für die Geschäftsführung

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Lizenzkosten
>
> Hallo IT,
>
> ich habe mir unsere Softwarekosten angeschaut und bin erschrocken. Unser Server läuft mit freier Software und kostet keine Lizenzgebühren – geht das auch für den Rest?
>
> Jedes Team schaut sich bitte **einen Bereich** an und stellt mir heute Nachmittag in **fünf Minuten** vor, was wir nehmen sollen. Ich bin keine Technikerin: Mich interessiert, was es kostet, was wir damit **dürfen** und wo die Haken sind.
>
> Grete

## Eure Bereiche

| Team | Bereich | Bisher bei der Pinguin GmbH |
|---|---|---|
| 1 | Office (Texte, Tabellen, Präsentationen) | Microsoft 365 |
| 2 | Browser und E-Mail | Google Chrome, Microsoft Outlook |
| 3 | Grafik und Bildbearbeitung (Website, Flyer) | Adobe Creative Cloud |
| 4 | Passwortverwaltung für alle Mitarbeitenden | Passwörter im Tabellendokument (!) |
| 5 | Betriebssystem für die Laptops der Mitarbeitenden | Windows 11 |
| 6 | Webserver und Datenbank für das neue Kundenportal | noch nichts |
| 7 | Dateien teilen und gemeinsam bearbeiten | Dropbox, Mail-Anhänge |

## ⭐ Pflicht

### Schritt 1: Recherche

Sucht für euren Bereich **mindestens zwei** freie Programme (bzw. Distributionen) und die bisherige Lösung als Vergleich. Füllt im Logbuch diese Tabelle aus:

| | Freie Lösung 1 | Freie Lösung 2 | Bisherige Lösung |
|---|---|---|---|
| Name und Website | | | |
| Lizenz (genauer Name, z. B. „GPL-3.0“) | | | |
| Art der Lizenz: Copyleft, permissiv oder proprietär? | | | |
| Kosten für 12 Arbeitsplätze | | | |
| Wer entwickelt die Software? (Firma, Stiftung, Gemeinschaft) | | | |
| Wie verdienen die Entwickler Geld? | | | |
| Läuft auf (Windows, macOS, Linux, Browser) | | | |
| Haken und Risiken | | | |

Gute Quellen: die Website des Projekts (meist unter „License“ oder „About“), Wikipedia, und – falls das Programm in Debian enthalten ist – `apt show <paket>` auf eurem Server.

### Schritt 2: Lizenzen auf eurem Server

Jedes Debian-Paket enthält eine Datei mit seinen Lizenzbedingungen: `/usr/share/doc/<paket>/copyright`.

1. Lasst euch für die Pakete `bash`, `coreutils`, `sudo` und `tar` die Lizenzen anzeigen:

   ```bash
   grep '^License:' /usr/share/doc/bash/copyright | sort | uniq -c
   ```

2. Ein Paket enthält oft Dateien unter verschiedenen Lizenzen. Die **Hauptlizenz** steht im ersten Abschnitt, der mit `Files: *` beginnt. Lasst euch diesen Abschnitt mit `grep -A 3 '^Files: \*' /usr/share/doc/bash/copyright` anzeigen und notiert für jedes Paket die Hauptlizenz. Welche sind Copyleft-Lizenzen, welche permissiv?
3. Was bedeutet das `+` in `GPL-3+`?

### Schritt 3: Der Pitch

Bereitet eine Präsentation von **höchstens fünf Minuten** vor – mit höchstens drei Folien, einem Plakat oder einer Seite im Logbuch. Gliederung:

1. **Unsere Empfehlung** in einem Satz
2. **Was kostet es?** – einmalig, jährlich, für Support
3. **Was dürfen wir?** – die Lizenz in Alltagssprache: nutzen, verändern, weitergeben, in eigene Produkte einbauen
4. **Wo sind die Haken?** – Umstellung, Schulung, Kompatibilität, Support
5. **Unser Fazit für Grete**

Jedes Teammitglied übernimmt einen Teil des Vortrags.

### Abnahmekriterien

- Die Tabelle aus Schritt 1 ist im Logbuch ausgefüllt.
- Das Team hält seinen Pitch in höchstens fünf Minuten.

## ⭐⭐ Erweiterung: Lizenzen im Vergleich

1. Füllt die Tabelle für sieben verbreitete Lizenzen aus:

   | Lizenz | Copyleft? (stark / schwach / nein) | Darf in eigener, geschlossener Software verwendet werden? | Wann muss der Quellcode herausgegeben werden? | Beispiel |
   |---|---|---|---|---|
   | GPL | | | | |
   | LGPL | | | | |
   | AGPL | | | | |
   | MPL | | | | |
   | Apache | | | | |
   | MIT | | | | |
   | BSD | | | | |

2. Die Entwicklung der Pinguin GmbH verändert ein GPL-Programm und setzt es nur **intern** ein. Muss sie ihre Änderungen veröffentlichen? Und wenn sie das veränderte Programm an Kunden **verkauft**?
3. Warum gibt es die AGPL? Denkt an Software, die nicht verteilt, sondern nur über das Internet benutzt wird – wie bei Team 6 und 7.

## ⭐⭐⭐ Profi: Was ist eigentlich „frei“?

1. Lest die **vier Freiheiten** der Free Software Foundation nach und notiert sie im Logbuch.
2. Was ist der Unterschied zwischen „Free Software“ (FSF) und „Open Source“ (OSI)? Warum spricht man oft von **FOSS** oder **FLOSS**?
3. Debian teilt seine Pakete in die Bereiche `main`, `contrib`, `non-free` und `non-free-firmware` ein. Lasst euch anzeigen, welche Bereiche auf eurem Server eingebunden sind:

   ```bash
   grep -rh '^Components\|^deb ' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null
   ```

   Was bedeuten die Bereiche? Sucht dazu nach den *Debian Free Software Guidelines* (DFSG).
4. Die Website der Pinguin GmbH soll Fotos aus dem Internet verwenden. Was bedeuten die Kürzel `CC BY`, `CC BY-SA` und `CC BY-NC` bei Creative-Commons-Lizenzen?

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- **Copyleft:** Wer die Software verändert und **weitergibt**, muss das Ergebnis unter derselben Lizenz weitergeben (GPL, AGPL; schwächer: LGPL, MPL).
- **Permissiv:** Die Software darf fast beliebig verwendet werden, auch in geschlossener Software. Meist muss nur der Urheber genannt werden (MIT, BSD, Apache).
- **Proprietär:** Man erwirbt nur ein Nutzungsrecht, der Quellcode ist nicht verfügbar.
- Geschäftsmodelle freier Software: Support-Verträge, Hosting als Dienst (SaaS), Spenden, Stiftungen, Doppellizenzierung, kostenpflichtige Zusatzfunktionen (*Open Core*)
- Lizenzen von Debian-Paketen: `/usr/share/doc/<paket>/copyright`
- Lizenzübersichten: <https://opensource.org/licenses>, <https://www.gnu.org/licenses/>, <https://choosealicense.com>

</details>

<details>
<summary>🟡 Hilfekarte 2 – Mögliche Kandidaten</summary>

| Team | Kandidaten |
|---|---|
| 1 | LibreOffice, ONLYOFFICE, Collabora Online |
| 2 | Firefox, Chromium, Thunderbird |
| 3 | GIMP, Inkscape, Krita, Scribus |
| 4 | KeePassXC, Bitwarden (auch selbst betrieben), Vaultwarden |
| 5 | Debian, Ubuntu, Linux Mint, Fedora |
| 6 | Apache HTTP Server, nginx, PostgreSQL, MariaDB |
| 7 | Nextcloud, Seafile, Syncthing |

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

Die Lizenzangaben unten sind der Stand bei der Erstellung dieses Tickets. Prüft sie auf der Website des Projekts – Lizenzen können sich ändern.

**Schritt 1 – Beispiele:**

| Bereich | Freie Lösung | Lizenz | Art |
|---|---|---|---|
| Office | LibreOffice | MPL-2.0 (Teile LGPL-3.0) | schwaches Copyleft |
| Browser, Mail | Firefox, Thunderbird | MPL-2.0 | schwaches Copyleft |
| | Chromium | BSD-3-Clause (überwiegend) | permissiv |
| Grafik | GIMP, Krita | GPL-3.0-or-later | Copyleft |
| Passwörter | KeePassXC | GPL-3.0 (bzw. GPL-2.0/3.0) | Copyleft |
| | Bitwarden-Server | AGPL-3.0 | Copyleft mit Netzwerkklausel |
| Betriebssystem | Debian | überwiegend GPL, dazu viele andere freie Lizenzen | – |
| Webserver | Apache HTTP Server | Apache-2.0 | permissiv |
| | nginx | BSD-2-Clause | permissiv |
| Datenbank | PostgreSQL | PostgreSQL License | permissiv |
| | MariaDB | GPL-2.0 | Copyleft |
| Dateien teilen | Nextcloud | AGPL-3.0 | Copyleft mit Netzwerkklausel |

Typische Haken: Umstellungsaufwand und Schulung, Dateiformate (z. B. komplexe Makros in Office-Dokumenten), fehlende Spezialfunktionen, Support muss eingekauft oder selbst geleistet werden. Viele Projekte bieten kostenpflichtigen Support oder gehostete Varianten an (Nextcloud, Bitwarden, Collabora).

**Schritt 2:** `bash`, `coreutils` und `tar` stehen unter **GPL-3+** (Copyleft), `sudo` hauptsächlich unter der **ISC**-Lizenz (permissiv, ähnlich MIT). Das `+` bedeutet „Version 3 **oder jede spätere** Version“ (*or later*).

**⭐⭐:**

| Lizenz | Copyleft | In geschlossener Software? | Quellcode herausgeben … | Beispiel |
|---|---|---|---|---|
| GPL | stark | nein (nur als getrenntes Programm) | bei Weitergabe | Linux-Kernel (GPL-2.0), bash |
| LGPL | schwach | ja, als Bibliothek eingebunden | bei Weitergabe von Änderungen an der Bibliothek | glibc |
| AGPL | stark + Netzwerk | nein | bei Weitergabe **und** bei Nutzung über das Netz | Nextcloud |
| MPL | schwach (pro Datei) | ja | bei Weitergabe veränderter MPL-Dateien | Firefox |
| Apache | nein | ja | nie (Hinweise und Patentklausel beachten) | Apache HTTP Server, Android |
| MIT | nein | ja | nie (Urhebervermerk behalten) | jQuery, Node.js |
| BSD | nein | ja | nie (Urhebervermerk behalten) | nginx, FreeBSD |

Interne Nutzung ist bei der GPL **keine** Weitergabe – die Änderungen müssen nicht veröffentlicht werden. Wer das veränderte Programm an Kunden verkauft, muss ihnen den Quellcode unter der GPL mitliefern bzw. anbieten. Die AGPL schließt die „SaaS-Lücke“: Wer die Software Nutzern über das Netzwerk anbietet, muss ihnen ebenfalls den Quellcode zur Verfügung stellen.

**⭐⭐⭐:** Die vier Freiheiten: (0) das Programm für jeden Zweck **ausführen**, (1) **verstehen und verändern** (dafür ist der Quellcode nötig), (2) **Kopien weitergeben**, (3) **veränderte Versionen weitergeben**. Die FSF betont die Freiheit der Nutzenden (ethisch), die OSI die praktischen Vorteile des offenen Entwicklungsmodells. Die Lizenzlisten überschneiden sich fast vollständig, daher der Sammelbegriff **FOSS**/**FLOSS** (*Free/Libre and Open Source Software*).

Debian: `main` = frei nach den DFSG und nur von freier Software abhängig, `contrib` = frei, aber abhängig von unfreier Software, `non-free` = unfrei, `non-free-firmware` = unfreie Firmware für Hardware (seit Debian 12 eigener Bereich, bei einer normalen Installation vom Installationsmedium standardmäßig eingebunden – VMs aus Cloud-Images haben oft nur `main`). Creative Commons: `BY` = Namensnennung, `SA` = Weitergabe unter gleichen Bedingungen (*Share Alike*, das Copyleft der CC-Welt), `NC` = keine kommerzielle Nutzung – für eine Firmenwebsite also ungeeignet.

</details>
