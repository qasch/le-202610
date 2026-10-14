# Übungen: Der Editor nano

Nano ist der Editor, der dir unten am Bildschirm verrät, wie er funktioniert. Das macht ihn freundlich, aber nicht trivial: Wer nur Pfeiltasten und Strg+X kennt, verschenkt eine Menge. Diese Übungen führen dich vom ersten Öffnen bis zur eigenen Konfiguration mit Farben.

Bearbeite die Teile der Reihe nach. Aufgaben mit **(Bonus)** sind für alle, die schneller fertig sind.

## Bevor es losgeht

### Die Schreibweise der Tastenkürzel

Nano und diese Übungen verwenden zwei Abkürzungen:

| Schreibweise | Bedeutung | Beispiel |
|---|---|---|
| `^X` | Strg gedrückt halten, dann X | `^O` = Strg+O |
| `M-X` | Alt gedrückt halten, dann X ("M" steht für Meta) | `M-U` = Alt+U |

**Tipp:** Manche Terminalprogramme schnappen sich Alt-Kombinationen selbst (zum Beispiel für ihre Menüs). Dann hilft der Umweg über Esc: **Esc kurz drücken, loslassen, dann die Taste.** `Esc` dann `U` ist dasselbe wie `M-U`.

### Welche Version hast du?

```bash
nano --version
```

Notiere dir die Versionsnummer. Seit **Version 8.0** sind einige Tasten anders belegt (vor allem `^F` und `^B` für die Suche). Wo es Unterschiede gibt, steht es bei der Aufgabe dabei.

Je nach Spracheinstellung fragt nano auf Deutsch ("J/N") oder Englisch ("Y/N"). Beides funktioniert gleich.

### Übungsdatei holen

Leg dir zuerst einen eigenen Übungsordner an. Die vim-Übungen verwenden teilweise dieselben Dateinamen (`hallo.txt`, `uebung.txt` usw.), so kommen sich die beiden nicht in die Quere. Lade dann die Übungsdatei herunter und arbeite immer mit einer **Kopie**, damit du jederzeit neu anfangen kannst:

```bash
mkdir -p ~/editoren/nano && cd ~/editoren/nano
wget https://raw.githubusercontent.com/qasch/le-202610/main/uebungen/nano-uebungen/uebungsdatei.txt
cp uebungsdatei.txt uebung.txt
```

## Teil 1: Öffnen, Schreiben, Speichern, Beenden

**1.1 Eine neue Datei anlegen**
Starte nano mit einem Dateinamen, den es noch nicht gibt:
```bash
nano hallo.txt
```
Schau dir den Bildschirm an: Oben die Titelleiste (Version und Dateiname), unten zwei Zeilen mit den wichtigsten Kürzeln. Was bedeutet laut dieser Leiste `^X`?

**1.2 Schreiben**
Tippe drei Zeilen: deinen Namen, deine Lieblingsdistribution und einen Grund, warum du heute hier bist. Achte auf die Titelleiste: Woran erkennst du, dass die Datei ungespeicherte Änderungen hat?

**1.3 Speichern**
Speichere mit `^O`. Nano schlägt den Dateinamen vor, du bestätigst mit Enter.
Füge eine vierte Zeile hinzu und speichere diesmal mit `^S`. Was ist der Unterschied zwischen `^O` und `^S`?

**1.4 Beenden ohne Speichern**
Schreibe eine fünfte Zeile ("Diese Zeile überlebt nicht"). Beende mit `^X` und beantworte die Frage nach dem Speichern mit **N**. Prüfe danach im Terminal:
```bash
cat hallo.txt
```
Ist die fünfte Zeile da?

**1.5 Speichern unter anderem Namen**
Öffne `hallo.txt` erneut. Drücke `^O`, lösche den vorgeschlagenen Namen und gib `hallo-kopie.txt` ein. Bestätige die Rückfrage. Kontrolliere mit `ls`, dass jetzt beide Dateien existieren.

**1.6 Die eingebaute Hilfe**
Öffne die Hilfe mit `^G`. Blättere darin mit den Bildtasten und verlasse sie mit `^X`.
Finde in der Hilfe heraus: Mit welcher Tastenkombination zählt nano Zeilen, Wörter und Zeichen?

## Teil 2: In der Datei bewegen

Beende nano und öffne für diesen Teil die Kopie der Übungsdatei:
```bash
nano uebung.txt
```

**2.1 Am Zeilenanfang und -ende**
Springe in Zeile 3 ans Zeilenende und zurück an den Anfang. Probiere beide Varianten:
- `Pos1` / `Ende`
- `^A` / `^E`

**2.2 Wortweise**
Geh in Zeile 8 und springe mit `Strg+→` und `Strg+←` von Wort zu Wort. Wie viele Sprünge brauchst du vom Zeilenanfang bis zum letzten Wort? Und wo landest du mit dem nächsten Sprung?

**2.3 Seitenweise**
Blättere mit `Bild↓` / `Bild↑` durch die Datei. Dasselbe geht mit `^V` (Seite runter) und `^Y` (Seite hoch). Wozu braucht man die Strg-Variante überhaupt? (Denk an Tastaturen ohne Bildtasten oder an SSH über merkwürdige Terminals.)

**2.4 Anfang und Ende der Datei**
- `M-\` springt an den Dateianfang
- `M-/` springt ans Dateiende

Alternativ funktionieren in vielen Terminals auch `Strg+Pos1` und `Strg+Ende`.

**2.5 Wo bin ich eigentlich?**
Drücke `^C`. Was zeigt nano dir jetzt unten an?

**2.6 Die Schnitzeljagd**
In Abschnitt 2 der Datei beginnt eine Schnitzeljagd über vier Codewörter. Folge den Hinweisen, ohne dich mit den Pfeiltasten durchzuhangeln. Du brauchst dafür:
- **Gehe zu Zeile:** `M-G` (auf deutscher Tastatur am bequemsten) oder `^_` (Strg+Shift+Minus); in vielen Terminals auch `^/` (auf deutscher Tastatur Strg+Shift+7)
- Dateiende: `M-/`
- Suchen: `^W` (dazu mehr in Teil 5)

Notiere die vier Codewörter.

**2.7 Blockweise springen**
Geh zur Überschrift von Abschnitt 11 (Linux-Trivia). Springe mit `Strg+↓` und `Strg+↑` von Absatz zu Absatz. Was gilt für nano als "Block"?

**2.8 Passende Klammer finden**
Setze in Abschnitt 6 den Cursor auf die geschweifte Klammer `{` hinter `location /` und drücke `M-]`. Wo landet der Cursor? Probiere es auch mit der allerersten `{` hinter `server`.

**2.9 Direkt an die richtige Stelle starten**
Beende nano. Öffne die Datei so, dass der Cursor sofort an der gewünschten Stelle steht:
```bash
nano +71 uebung.txt
nano +/Schatztruhe uebung.txt
```
Was macht jeweils das `+`?

**2.10 (Bonus) Zeile zentrieren**
Geh ganz nach unten und drücke mehrmals `^L`. Was passiert mit der Zeile, in der der Cursor steht?

## Teil 3: Die Anzeige anpassen

**3.1 Zeilennummern**
Schalte mit `M-N` die Zeilennummern ein und wieder aus. Kontrolliere damit, ob das zweite Codewort wirklich in Zeile 120 steht.
Zum Vergleich: Mit `nano -l uebung.txt` startet nano gleich mit Zeilennummern.

**3.2 Position dauerhaft anzeigen**
Schalte mit `M-C` die ständige Positionsanzeige ein. Bewege den Cursor und beobachte die Statusleiste. Was ist der Unterschied zu `^C` aus Aufgabe 2.5?

**3.3 Unsichtbares sichtbar machen**
Geh zu Abschnitt 7 und drücke `M-P`.
- Welche Zeile beginnt mit einem Tabulator, welche mit Leerzeichen? Woran erkennst du das?
- Entferne die überflüssigen Leerzeichen am Ende der ersten Zeile.
- Warum kann so etwas in Konfigurationsdateien oder Makefiles echten Ärger machen?

**3.4 Lange Zeilen**
Geh zu Abschnitt 8. Bewege den Cursor in der langen Zeile nach rechts und beobachte, was passiert.
Schalte die Zeilennummern mit `M-N` wieder ein (falls du sie in 3.1 ausgeschaltet hast) und dann mit `M-S` den Soft-Wrap. Wie viele Zeilennummern hat die lange Zeile jetzt? Und warum?

**3.5 Mehr Platz**
- `M-X` blendet die Hilfezeilen unten aus und wieder ein.
- `M-Z` blendet Titel- und Statusleiste aus und wieder ein.

**3.6 Nur gucken, nicht anfassen**
Beende nano und öffne die Datei im Nur-Lese-Modus:
```bash
nano -v uebung.txt
```
Versuch etwas zu tippen. Wann ist dieser Modus sinnvoll?

## Teil 4: Ausschneiden, Kopieren, Einfügen, Rückgängig

Beende nano und öffne die Übungsdatei wieder ganz normal, also ohne `-v`:
```bash
nano uebung.txt
```

Nano hat eine eigene Zwischenablage, den **Cutbuffer**. Mit der Zwischenablage deiner grafischen Oberfläche hat er nichts zu tun.

| Aktion | Taste |
|---|---|
| Zeile (oder Markierung) ausschneiden | `^K` |
| Zeile (oder Markierung) kopieren | `M-6` |
| Einfügen | `^U` |
| Markierung setzen/aufheben | `M-A` (oder Shift + Pfeiltasten) |
| Rückgängig / Wiederholen | `M-U` / `M-E` |

**4.1 Die Morgenroutine sortieren**
Abschnitt 3 ist durcheinander geraten. Bring die Schritte mit `^K` und `^U` in die Reihenfolge 1 bis 6.

**4.2 Mehrere Zeilen auf einmal**
In Abschnitt 4 steht eine Zeile dreimal zu viel. Setz den Cursor auf die erste doppelte Zeile und drücke dreimal hintereinander `^K`. Geh dann ganz ans Dateiende und drücke einmal `^U`. Wie viele Zeilen werden eingefügt? Was lernst du daraus über aufeinanderfolgende `^K`?
Mach das Einfügen danach mit `M-U` wieder rückgängig.

**4.3 Zeile verdoppeln**
Die letzte Zeile von Abschnitt 4 soll zweimal dastehen. Kopiere sie mit `M-6` (ohne sie zu löschen) und füge sie mit `^U` ein.

**4.4 Markieren**
- Markiere in Abschnitt 6 die drei Zeilen des `location /bilder/`-Blocks: Cursor an den Anfang, `M-A`, dann mit den Pfeiltasten bis hinter die schließende Klammer. Kopiere sie mit `M-6` und füge sie am Dateiende ein.
- Markiere jetzt nur ein einzelnes Wort mitten in einer Zeile, zum Beispiel "Hobbyprojekt" in Abschnitt 11, und kopiere es ans Dateiende.
- Probiere das Markieren auch mit Shift + Pfeiltasten.

**4.5 Rückgängig als Rettungsanker**
Markiere den kompletten Abschnitt 1 und schneide ihn mit `^K` aus. Schreck lass nach. Hol ihn mit `M-U` zurück. Und dann mit `M-E` wieder weg, und mit `M-U` wieder her.

**4.6 Tippfehler korrigieren**
Korrigiere alle Fehler in Abschnitt 9. Probiere dabei:
- `Backspace` und `Entf` für einzelne Zeichen
- `Alt+Backspace` löscht das Wort links vom Cursor
- `Strg+Entf` löscht das Wort rechts vom Cursor

**4.7 (Bonus) Ausschneiden oder wegwerfen?**
Schneide eine beliebige Zeile mit `^K` aus. Lösche danach eine **andere** Zeile mit `Alt+Entf`. Drück jetzt `^U`. Welche Zeile kommt zurück? Wofür ist `Alt+Entf` praktisch?

## Teil 5: Suchen und Ersetzen

| Aktion | Taste |
|---|---|
| Vorwärts suchen | `^W` (alle Versionen), ab 8.0 auch `^F` |
| Rückwärts suchen | ab 8.0 `^B` |
| Nächster Treffer | ab 8.0 `M-F` (vorwärts) / `M-B` (rückwärts), ältere Versionen `M-W` |
| Ersetzen | `^\` (Strg+Backslash) oder `M-R` |

**Achtung bei älteren Versionen (vor 8.0):** Dort bewegen `^F` und `^B` nur den Cursor ein Zeichen vor oder zurück.

**5.1 Einfach suchen**
Suche mit `^W` nach `Kaffee`. Spring mit `M-F` (bzw. `M-W`) zu den weiteren Treffern. Wie viele gibt es in der Datei?
Tipp für alle Versionen: `^W` und dann direkt Enter sucht noch einmal nach dem letzten Begriff.

**5.2 Optionen im Suchfeld**
Wenn das Suchfeld offen ist, zeigen die Hilfezeilen neue Optionen. Finde dort heraus:
- Mit welcher Taste schaltest du auf **Groß-/Kleinschreibung beachten** um?
- Mit welcher Taste schaltest du auf **rückwärts suchen** um?

**5.3 Groß und klein**
Suche nach `windows` (kleingeschrieben), einmal ohne und einmal mit Beachtung der Groß-/Kleinschreibung. Wie viele Treffer gibt es jeweils?

**5.4 Ersetzen**
Im Büro aus Abschnitt 5 wird umgestellt: Ersetze überall `Windows` durch `Linux`. Der Hausmeister soll aber weiterhin seine `windows` putzen.
- Starte das Ersetzen mit `^\`.
- Sorge dafür, dass Groß-/Kleinschreibung beachtet wird.
- Bei jeder Fundstelle fragt nano nach: **J** (ja), **N** (nein) oder **A** (alle).

Wie viele Ersetzungen meldet nano am Ende?

**5.5 (Bonus) Ersetzen nur in einem Bereich**
Markiere nur die ersten drei Zeilen von Abschnitt 5 und ersetze dort `Buero` durch `Homeoffice`. Was passiert mit dem `Buero` in der vierten Zeile?

**5.6 (Bonus) Reguläre Ausdrücke**
Schalte im Suchfeld mit `M-R` auf reguläre Ausdrücke um und suche nach `^Schritt [1-3]`. Welche Zeilen findet nano?

## Teil 6: Werkzeuge für Fortgeschrittene

**6.1 Eine Datei einfügen**
Geh in `uebung.txt` ans Dateiende und füge mit `^R` den Inhalt von `hallo.txt` ein.

**6.2 Die Ausgabe eines Befehls einfügen**
Drücke `^T` (ab Version 5.0) und gib `date` ein. Die Ausgabe landet an der Cursorposition. Probiere auch `uname -r` und `ls -l`.

**6.3 Mehrere Dateien gleichzeitig**
Beende nano (ob du die Änderungen aus 6.1 und 6.2 speicherst, ist egal) und öffne zwei Dateien auf einmal:
```bash
nano hallo.txt uebung.txt
```
- Wechsle mit `M-→` und `M-←` zwischen den Dateien. (Vor Version 9.0 gingen dafür auch `M->` und `M-<`. Seit 9.0 schieben diese beiden die Ansicht seitwärts.)
- Kopiere die Morgenroutine aus `uebung.txt` mit `M-6` (sechsmal hintereinander drücken oder die sechs Zeilen vorher markieren) und füge sie in `hallo.txt` mit `^U` ein. Der Cutbuffer gilt für alle offenen Dateien.

**6.4 Auskommentieren**
Beende nano und leg eine kleine Testdatei an:
```bash
nano test.sh
```
Schreib fünf beliebige Zeilen (zum Beispiel `echo "Zeile 1"` usw.), markiere drei davon und drücke `M-3`. Noch einmal `M-3` macht es rückgängig. Woher weiß nano, welches Kommentarzeichen es nehmen soll?

**6.5 Einrücken**
Markiere in `test.sh` mehrere Zeilen und drücke `Tab`. Mit `Shift+Tab` rückst du sie wieder aus.

**6.6 Ein Makro aufzeichnen**
Vor jeden Befehl in Abschnitt 10 von `uebung.txt` soll ein `- ` (Bindestrich und Leerzeichen). Beende nano und öffne dafür wieder `uebung.txt` (`nano uebung.txt`).
1. Cursor auf `ls`.
2. `M-:` startet die Aufzeichnung.
3. `Pos1`, `- ` tippen, `Pfeil runter`.
4. `M-:` beendet die Aufzeichnung.
5. `M-;` spielt das Makro ab. Siebenmal drücken, fertig.

**6.7 Wie viel steht da?**
Lass dir mit `M-D` die Zeilen, Wörter und Zeichen der Datei anzeigen. Markiere dann nur einen Abschnitt und drücke wieder `M-D`. Was ändert sich?

**6.8 (Bonus) Sicherheitskopie beim Speichern**
Beende nano und starte es mit der Option `-B` neu:
```bash
nano -B uebung.txt
```
Ändere etwas, speichere und schau mit `ls` nach. Was ist neu dazugekommen?

## Teil 7: Konfiguration und Farben

Nano liest beim Start zwei Konfigurationsdateien:
- systemweit: `/etc/nanorc`
- für deinen Benutzer: `~/.nanorc` oder `~/.config/nano/nanorc` (gibt es eine `~/.nanorc`, liest nano die zweite gar nicht erst)

Optionen in deiner eigenen Datei überschreiben die systemweiten, Optionen auf der Kommandozeile überschreiben beide.

**7.1 Die Systemkonfiguration erkunden**
```bash
nano -v /etc/nanorc
```
Suche darin nach `linenumbers` und `include`. Sind die Zeilen aktiv oder mit `#` auskommentiert?

**7.2 Deine eigene Konfiguration**
```bash
mkdir -p ~/.config/nano
nano ~/.config/nano/nanorc
```
Trag Folgendes ein, speichere und starte nano neu. Teste jede Einstellung einzeln: Was bewirkt sie?
```
set linenumbers
set constantshow
set mouse
set autoindent
set tabsize 4
set tabstospaces
set indicator
set guidestripe 80
```
Frage zum Nachdenken: Warum ist `tabstospaces` für ein Makefile eine schlechte Idee?

**7.3 Syntaxhervorhebung einschalten**
Schau nach, welche Syntaxdateien deine Distribution mitbringt:
```bash
ls /usr/share/nano/
```
Ist die Hervorhebung bei dir noch nicht aktiv, ergänze in deiner `nanorc`:
```
include "/usr/share/nano/*.nanorc"
```
Öffne danach `test.sh` aus Aufgabe 6.4 und eine Systemdatei wie `/etc/fstab` (mit `-v`!). Was wird farbig?
Ab Version 8.1 listet `nano --listsyntaxes` alle verfügbaren Syntaxen auf.

**7.4 Ein eigenes Farbschema für die Oberfläche**
Mit diesen Optionen färbst du die Bedienelemente:

| Option | Färbt |
|---|---|
| `titlecolor` | Titelleiste |
| `statuscolor` | Statusleiste |
| `errorcolor` | Fehlermeldungen |
| `keycolor` | Tastenkürzel in den Hilfezeilen |
| `functioncolor` | Beschreibungen in den Hilfezeilen |
| `numbercolor` | Zeilennummern |
| `selectedcolor` | markierten Text |
| `stripecolor` | Hilfslinie (`guidestripe`) |
| `spotlightcolor` | Suchtreffer |

Das Format ist `set option [bold,][italic,]vordergrund,hintergrund`, zum Beispiel:
```
set titlecolor bold,white,blue
set statuscolor white,green
set keycolor cyan
set functioncolor green
set numbercolor lightblack
set selectedcolor white,magenta
set stripecolor ,yellow
```
Erlaubte Farben sind `red`, `green`, `blue`, `magenta`, `yellow`, `cyan`, `white`, `black`, jeweils auch mit `light` davor (`lightblue`). Terminals mit 256 Farben kennen zusätzlich Namen wie `orange`, `purple`, `teal` oder `#rgb`-Werte wie `#f80`.

**Aufgabe:** Bau dir ein eigenes Farbschema, zum Beispiel "Retro-Terminal" (grün auf schwarz) oder "Augenkrebs" (für den Lacher in der Gruppe). Zeig es deinem Nachbarn.

**7.5 (Bonus) Eine eigene Syntax**
Du kannst nano beibringen, deine eigenen Dateitypen einzufärben. Füge in deine `nanorc` ein:
```
syntax "todo" "\.todo$"
color red "\[ \]"
color green "\[x\].*"
color bold,yellow "!!.*"
color grey "#.*"
```
Leg dann `einkauf.todo` an:
```
# Wochenende
[ ] Kaffee kaufen !! wichtig
[x] Tee kaufen
[ ] Neue Tastatur
```
Erweitere die Syntax: Wie bekommst du Datumsangaben wie `2026-10-12` blau?

**7.6 (Bonus) nano als Standard-Editor**
Viele Programme (zum Beispiel `git commit`, `crontab -e`, `sudoedit`) öffnen den Editor aus der Umgebungsvariable `EDITOR`. Trag in deine `~/.bashrc` ein:
```bash
export EDITOR=nano
```
Lade die Datei neu (`source ~/.bashrc`) und probiere `crontab -e` aus (ohne zu speichern, falls du keinen Cronjob willst). Unter Arch Linux gibt es `crontab` erst mit dem Paket `cronie`. Ist bei dir zusätzlich die Variable `VISUAL` gesetzt (`echo $VISUAL`), hat sie Vorrang vor `EDITOR`.
Frage: Warum ist `sudoedit /etc/hosts` angenehmer als `sudo nano /etc/hosts`, wenn du deine eigene `nanorc` mit Farben hast?

## Teil 8: Abschluss-Speedrun

Jetzt kommt alles zusammen. Nimm eine frische Kopie und stopp die Zeit. Ziel: unter fünf Minuten, ohne dich mit den Pfeiltasten durch die Datei zu quälen.

```bash
cp uebungsdatei.txt speedrun.txt
nano speedrun.txt
```

1. Schalte die Zeilennummern ein (falls sie durch deine `nanorc` aus 7.2 nicht schon an sind, sonst schaltest du sie mit `M-N` gerade aus).
2. Spring zu Zeile 99, kopiere sie und füge sie am Dateiende ein.
3. Ersetze in der ganzen Datei `Kaffee` durch `Tee`.
4. Lösche Abschnitt 4 komplett (Überschrift und Inhalt).
5. Füge ganz oben in der Datei die Ausgabe von `whoami` ein.
6. Kommentiere den `server`-Block in Abschnitt 6 aus.
7. Lass dir die Wortanzahl anzeigen und notiere sie.
8. Speichere und beende nano.

Vergleiche dein Ergebnis mit dem Original:
```bash
diff uebungsdatei.txt speedrun.txt
```
Passt die Ausgabe von `diff` zu dem, was du geändert hast?

## Spickzettel

| Bereich | Taste | Funktion |
|---|---|---|
| **Datei** | `^S` | Speichern |
| | `^O` | Speichern unter |
| | `^R` | Datei einfügen |
| | `^X` | Beenden |
| | `^G` | Hilfe |
| **Bewegen** | `^A` / `^E` | Zeilenanfang / Zeilenende |
| | `Strg+←` / `Strg+→` | Wortweise |
| | `Strg+↑` / `Strg+↓` | Blockweise |
| | `^Y` / `^V` | Seite hoch / runter |
| | `M-\` / `M-/` | Dateianfang / Dateiende |
| | `^_` oder `M-G` | Gehe zu Zeile |
| | `M-]` | Passende Klammer |
| | `^C` | Position anzeigen |
| **Bearbeiten** | `^K` | Ausschneiden |
| | `M-6` | Kopieren |
| | `^U` | Einfügen |
| | `M-A` | Markierung setzen |
| | `M-U` / `M-E` | Rückgängig / Wiederholen |
| | `Alt+Entf` | Zeile löschen (ohne Cutbuffer) |
| | `M-3` | Kommentieren |
| | `^T` | Befehl ausführen |
| **Suchen** | `^W` / `^F` | Vorwärts suchen (`^F` ab 8.0) |
| | `^B` | Rückwärts suchen (ab 8.0) |
| | `M-F` / `M-B` | Nächster Treffer (ab 8.0) |
| | `^\` oder `M-R` | Ersetzen |
| **Anzeige** | `M-N` | Zeilennummern |
| | `M-C` | Position ständig anzeigen |
| | `M-P` | Leerraum sichtbar |
| | `M-S` | Soft-Wrap |
| | `M-X` | Hilfezeilen ein/aus |
| **Makros** | `M-:` | Aufzeichnung starten/stoppen |
| | `M-;` | Makro abspielen |


> [!NOTE]
> Hilfe findest du unter `man nano` und `man nanorc`
