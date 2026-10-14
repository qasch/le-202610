# Übungen: Vim und Neovim

Vim hat einen Ruf: mächtig, schnell und berüchtigt dafür, dass man ihn nicht wieder verlassen kann. Das Gute vorweg: Nach Teil 1 kannst du das. Der Rest dieser Übungen zeigt dir, warum so viele Leute freiwillig drinbleiben.

Alle Aufgaben funktionieren in **Vim** und **Neovim**. Wo sich die beiden unterscheiden, steht es dabei. Aufgaben mit **(Bonus)** sind für alle, die schneller fertig sind.

## Bevor es losgeht

### Das wichtigste Konzept: Modi

Vim hat mehrere Modi. Fast alle Verwirrung am Anfang kommt daher, dass man im falschen ist.

| Modus | Wofür | Wie du hineinkommst | Erkennbar an |
|---|---|---|---|
| **Normal** | Bewegen, Löschen, Kopieren, Befehle | `Esc` | keine Anzeige unten |
| **Einfügen** (Insert) | Text tippen | `i`, `a`, `o` und andere | `-- EINFÜGEN --` bzw. `-- INSERT --` |
| **Visuell** | Text markieren | `v`, `V`, `Strg+V` | `-- VISUELL --` bzw. `-- VISUAL --` |
| **Befehlszeile** | Befehle wie Speichern oder Ersetzen | `:` | Doppelpunkt unten links |

**Notfallregel:** Wenn du nicht mehr weißt, wo du bist: zweimal `Esc`, dann `:q!` und Enter. Damit bist du draußen, ohne zu speichern.

### Schreibweise in diesen Übungen

| Schreibweise | Bedeutung |
|---|---|
| `dd` | im Normalmodus nacheinander d und d tippen |
| `Strg+R` | Strg gedrückt halten, dann R |
| `:w` | Doppelpunkt, w tippen, dann Enter |
| `3dd` | Zahl davor heißt: so oft wiederholen |

Groß- und Kleinschreibung zählt: `g` und `G` sind zwei völlig verschiedene Befehle.

### Deutsche Tastatur

- `^` und `` ` `` sind Tottasten: Drück danach einmal die Leertaste, sonst wartet die Tastatur auf einen Buchstaben für â oder à. (Wer das nicht mag, stellt das Tastaturlayout "Deutsch, ohne Tottasten" ein.)
- `[ ] { } ~` erreichst du wie gewohnt mit `AltGr`. Nur `Strg+]` kommt in vielen Terminals nicht an (siehe Aufgabe 1.7).
- Arbeitest du per SSH aus dem Windows Terminal, fügt `Strg+V` dort Text ein, statt die Taste an Vim weiterzugeben. In Vim macht `Strg+Q` dasselbe wie `Strg+V`.

### Welche Version hast du?

```bash
vim --version | head -n 3
nvim --version | head -n 3
```

Vim und Neovim haben unterschiedliche Grundeinstellungen. Neovim schaltet von Haus aus zum Beispiel Syntaxhervorhebung, Suchhervorhebung und die Maus ein.

### Übungsdatei holen

Leg dir einen eigenen Übungsordner an. Die nano-Übungen verwenden teilweise dieselben Dateinamen (`hallo.txt`, `uebung.txt` usw.), und Vim weigert sich zum Beispiel, eine vorhandene Datei mit `:w name` zu überschreiben.

```bash
mkdir -p ~/editoren/vim && cd ~/editoren/vim
wget https://raw.githubusercontent.com/qasch/le-202610/main/vim-uebungsdatei.txt
cp vim-uebungsdatei.txt uebung.txt
```

Arbeite immer mit der Kopie. Wer nur `vim` hat, ersetzt in allen Aufgaben `nvim` durch `vim` und umgekehrt.

### Zum Aufwärmen (optional)

Beide Editoren bringen ein interaktives Tutorial mit, das etwa 30 Minuten dauert:
- Vim: im Terminal `vimtutor`
- Neovim: im Editor `:Tutor`

## Teil 1: Modi, Schreiben, Speichern, Beenden

**1.1 Eine neue Datei anlegen**
```bash
vim hallo.txt
```
Tippe einfach drauflos, zum Beispiel "Hallo". Was passiert? Warum?
Drück danach `Esc` und dann so oft `u`, bis die Datei wieder leer ist.

**1.2 In den Einfügemodus wechseln**
Drücke `i` und tippe drei Zeilen: deinen Namen, deine Lieblingsdistribution und einen Grund, warum du heute hier bist. Drücke danach `Esc`. Achte auf die Anzeige unten links.

**1.3 Die verschiedenen Wege in den Einfügemodus**
Probiere jeden Befehl einmal aus (immer mit `Esc` zurück in den Normalmodus) und notiere, wo der Cursor landet:

| Befehl | Wo fängst du an zu schreiben? |
|---|---|
| `i` | |
| `a` | |
| `I` | |
| `A` | |
| `o` | |
| `O` | |

**1.4 Speichern und beenden**
Probiere nacheinander:
- `:w` speichert.
- `:q` beendet. Was passiert, wenn du vorher noch etwas geändert hast?
- `:q!` beendet ohne zu speichern.
- `:wq` speichert und beendet.

Öffne die Datei jedes Mal wieder. Bonusfrage: Was machen `:x` und `ZZ`?

**1.5 Änderungen verwerfen**
Öffne `hallo.txt` wieder, schreibe eine Zeile "Diese Zeile überlebt nicht", beende mit `:q!` und prüfe im Terminal mit `cat hallo.txt`.

**1.6 Speichern unter anderem Namen**
Öffne `hallo.txt` und probiere:
1. `:w hallo-kopie.txt`, dann eine Änderung machen und `:w`. In welcher Datei landet die Änderung?
2. `:saveas hallo-kopie2.txt`, dann eine Änderung und `:w`. Und jetzt?

Schau dir die drei Dateien mit `cat` an. Was ist der Unterschied zwischen `:w name` und `:saveas name`?

**1.7 Die eingebaute Hilfe**
- `:help` öffnet die Hilfe.
- `:help :w` springt direkt zur Hilfe für `:w`.
- Steht der Cursor auf einem farbig markierten Begriff, folgst du mit `Strg+]` dem Verweis. `Strg+O` springt zurück. Auf deutschen Tastaturen kommt `Strg+]` in vielen Terminals nicht an. Dann hilft ein Doppelklick mit der Maus auf den Begriff (in Vim vorher `:set mouse=a`, falls die Maus nicht reagiert).
- `:q` schließt die Hilfe.

Finde in der Hilfe heraus, was `ZQ` macht.

## Teil 2: In der Datei bewegen

```bash
vim uebung.txt
```

Ab jetzt gilt: **Die Pfeiltasten funktionieren, aber versuch sie zu vermeiden.** Die Bewegungsbefehle sind der Grund, warum Vim schnell ist, und du brauchst sie gleich für alles andere.

**2.1 Die Grundrichtungen**
`h` links, `j` runter, `k` hoch, `l` rechts. Eselsbrücke: Das `j` hat unten einen Haken. Beweg dich ein paar Zeilen in alle Richtungen.

**2.2 Mit Zahlen**
`5j` geht fünf Zeilen runter, `3k` drei hoch. Fast jeder Befehl in Vim versteht eine Zahl davor.

**2.3 Wortweise**
Geh in Zeile 8 und probiere `w` (Anfang nächstes Wort), `b` (Anfang vorheriges Wort) und `e` (Ende des Wortes). Was ist der Unterschied zwischen `w` und `W`? (Tipp: Probiere es in Zeile 120 mit `/var/log/app.log`.)

**2.4 Innerhalb der Zeile**
- `0` springt an den Zeilenanfang, `^` zum ersten Zeichen, das kein Leerzeichen ist, `$` ans Zeilenende.
- `f` plus Zeichen springt zum nächsten Vorkommen dieses Zeichens. Geh in Zeile 52 an den Anfang und tippe `f"`. Mit `;` geht es zum nächsten Treffer, mit `,` zurück.
- Was ist der Unterschied zwischen `f"` und `t"`?

**2.5 Große Sprünge**
- `gg` an den Dateianfang, `G` ans Dateiende
- `Strg+D` / `Strg+U`: eine halbe Seite runter / hoch
- `Strg+F` / `Strg+B`: eine ganze Seite runter / hoch
- `H`, `M`, `L`: oben, Mitte, unten im sichtbaren Bereich

**2.6 Wo bin ich?**
Drücke `Strg+G`. Was zeigt Vim an?

**2.7 Die Schnitzeljagd**
In Abschnitt 2 beginnt eine Schnitzeljagd über vier Codewörter. Du brauchst:
- Zu einer Zeile springen: Zeilennummer plus `G` (also `42G`) oder `:42`
- Dateiende: `G`
- Suchen: `/Suchbegriff` und Enter

Notiere die vier Codewörter.

**2.8 Absätze und Klammern**
- Geh zu Abschnitt 14 (Linux-Trivia) und springe mit `}` und `{` von Absatz zu Absatz.
- Setze in Abschnitt 6 den Cursor auf die `{` hinter `location /` und drücke `%`. Wo landet der Cursor? Und von der `{` hinter `server`?

**2.9 Markierungen und zurückspringen**
- Setz in Zeile 15 mit `ma` eine Marke namens a.
- Spring irgendwo anders hin, zum Beispiel mit `G`.
- Mit `'a` kommst du zurück. Was ist der Unterschied zu `` `a `` (Backtick)?
- `Strg+O` springt zur vorherigen Position, `Strg+I` wieder vor. Probiere es nach ein paar großen Sprüngen.

**2.10 Direkt an die richtige Stelle starten**
```bash
vim +71 uebung.txt
vim +/Schatztruhe uebung.txt
```

**2.11 (Bonus) Bildschirm ausrichten**
Geh mit `G` ans Ende und probiere `zz`, `zt` und `zb`. Was passiert jeweils?

## Teil 3: Die Anzeige anpassen

Einstellungen änderst du mit `:set`. Ein paar Grundregeln:
- `:set number` schaltet ein, `:set nonumber` aus.
- `:set number!` schaltet um.
- `:set number?` zeigt den aktuellen Zustand.

**3.1 Zeilennummern**
- `:set number` (kurz `:set nu`): Prüfe damit, ob das zweite Codewort in Zeile 155 steht.
- `:set relativenumber` (kurz `:set rnu`): Was zeigen die Zahlen jetzt? Wozu ist das in Kombination mit `5j` oder `3dd` praktisch?
- Schalte beides gleichzeitig ein. Was steht in der Zeile, in der der Cursor ist?

**3.2 Unsichtbares sichtbar machen**
Geh zu Abschnitt 7 und tippe `:set list`.
- Wie werden Tabulatoren und Zeilenenden dargestellt? (Vim und Neovim zeigen das unterschiedlich.)
- Welche Zeile beginnt mit einem Tabulator, welche mit Leerzeichen?
- Entferne die Leerzeichen am Ende von Zeile 64.

**3.3 Lange Zeilen**
Geh zu Abschnitt 8. Tippe `:set nowrap`, beweg dich in der Zeile nach rechts, dann `:set wrap`. Wie viele Zeilennummern hat die lange Zeile? Bonus: Was ändert `:set linebreak`?

**3.4 Orientierungshilfen**
- `:set cursorline` hebt die aktuelle Zeile hervor.
- `:set colorcolumn=80` zeigt eine Linie in Spalte 80.
- `:set ruler` zeigt die Position unten rechts (in Neovim schon an, in Vim ebenfalls, solange du keine eigene `~/.vimrc` hast).

**3.5 Nur lesen**
Beende Vim (wegen der Änderung aus 3.2 mit `:wq`) und öffne die Datei schreibgeschützt:
```bash
vim -R uebung.txt
```
Versuch etwas zu ändern und zu speichern. Was sagt Vim?

## Teil 4: Bearbeiten im Normalmodus

Beende Vim und öffne die Übungsdatei wieder normal, also ohne `-R`:
```bash
vim uebung.txt
```

Das Herz von Vim: **Operator plus Bewegung.** `d` heißt löschen, `w` heißt Wort, also löscht `dw` ein Wort. Einmal verstanden, kannst du dir hunderte Befehle selbst zusammenbauen.

| Operator | Bedeutung |
|---|---|
| `d` | löschen (landet im Zwischenspeicher, ist also eigentlich "ausschneiden") |
| `y` | kopieren ("yank") |
| `c` | ändern (löschen und direkt in den Einfügemodus) |
| `>` / `<` | ein- und ausrücken |

Doppelt getippt wirkt ein Operator auf die ganze Zeile: `dd`, `yy`, `cc`, `>>`.

**4.1 Die Morgenroutine sortieren**
Bring die Schritte in Abschnitt 3 in die Reihenfolge 1 bis 6. Du brauchst:
- `dd` schneidet die Zeile aus
- `p` fügt unter der aktuellen Zeile ein, `P` darüber
- Bonus-Trick: Was macht `ddp`?

**4.2 Mehrere Zeilen auf einmal**
Lösche die drei doppelten Zeilen in Abschnitt 4 mit **einem** Befehl.

**4.3 Zeile verdoppeln**
Die letzte Zeile von Abschnitt 4 soll zweimal dastehen. (`yy` und `p`)

**4.4 Rückgängig und Wiederholen**
- `u` macht rückgängig, `Strg+R` stellt wieder her.
- Setz den Cursor auf die Überschrift von Abschnitt 1 und tippe `dap` (delete a paragraph). Was wird gelöscht? Hol es mit `u` zurück.
- Probiere jetzt `d2ap` auf der Überschrift. Warum ist jetzt der ganze Abschnitt weg? Wieder `u`.

**4.5 Der Punkt-Befehl**
`.` wiederholt die letzte Änderung. Geh in Abschnitt 13 auf das `#` am Anfang der Zeile `#logfile=...` (am schnellsten mit `/#logfile`, das landet genau auf dem `#`), lösche es mit `x`, geh mit `3j` zur Zeile `#timeout=30` und drück `.`. Danach `j` und noch einmal `.`. Was passiert?

**4.6 Tippfehler-Paradies**
Korrigiere Abschnitt 9. Probiere für jede Zeile den angegebenen Weg:

| Zeile in Abschnitt 9 | Fehler | Werkzeug |
|---|---|---|
| 1 | "Dises", "Fhler" | `cw` (Wort ersetzen), `i` (Buchstabe einfügen) |
| 2 | "Pingiun", "Maskotchen" | `xp` (zwei Buchstaben tauschen), `a` |
| 3 | "Termnial" | `ciw` (ganzes Wort ersetzen, egal wo der Cursor im Wort steht) |
| 4 | "Wort Wort" | `dw` |
| 5 | "ziemlich schwieriger" soll "grossartiger" werden | `c2w` |

Bonus: `r` ersetzt ein einzelnes Zeichen, ohne in den Einfügemodus zu gehen. `~` ändert Groß-/Kleinschreibung.

**4.7 Textobjekte**
Textobjekte sind einer der größten Vorteile von Vim. `i` steht für "inner" (innen), `a` für "around" (mit Rand).
- In der Zeile mit `server_name`: Setz den Cursor irgendwo vor das schließende Anführungszeichen und ändere mit `ci"` den Servernamen in `linux.local`. (Teil 4 hat schon Zeilen gelöscht und verdoppelt, deshalb hier keine Zeilennummern.)
- In der Zeile mit `root`: Setz den Cursor in die Zeile und lösche mit `di{` den Inhalt des Blocks `location / { ... }`. Danach `u`.
- Was löscht `da{` stattdessen?
- Was macht `dap` im Unterschied zu `dip`?

**4.8 Markieren im visuellen Modus**
- `v` markiert zeichenweise, `V` zeilenweise.
- Markiere mit `V` und `j` die drei Zeilen des `location /bilder/`-Blocks, kopiere sie mit `y` und füge sie mit `G` und `p` am Ende ein.
- Markiere mit `v` nur das Wort "Hobbyprojekt" in Abschnitt 14 und kopiere es ans Dateiende.
- Markiere mehrere Zeilen und drücke `>`. Was passiert?

**4.9 Blockauswahl**
`Strg+V` markiert ein Rechteck. Das ist nano-Nutzern komplett fremd. (Im Windows Terminal: `Strg+Q` statt `Strg+V`.)
- In Abschnitt 12: Lösche die komplette Spalte "Distro". (Cursor auf das D von "Distro", `Strg+V`, nach unten und rechts erweitern, `d`.)
- In Abschnitt 10: Setz vor jeden Befehl ein `- `. Cursor auf `ls`, `Strg+V`, `7j`, dann `I`, `- ` tippen, `Esc`.

**4.10 Zahlen hochzählen**
- Setz den Cursor in Abschnitt 11 auf die erste `0` und drücke `Strg+A`. Dann `5` und `Strg+A`. `Strg+X` zählt runter.
- Mach das mit `u` rückgängig (dreimal, es waren drei Änderungen). Markiere jetzt alle sechs Kapitelzeilen mit `V` und drücke `g` und dann `Strg+A`. Was passiert?

**4.11 (Bonus) Register**
Vim hat nicht einen, sondern viele Zwischenspeicher.
- `"ayy` kopiert die aktuelle Zeile in Register a, `"ap` fügt sie ein.
- `:reg` zeigt alle Register.
- Das Register `"+` ist die System-Zwischenablage. Ob das klappt, zeigt `vim --version | grep clipboard` (bei Vim muss `+clipboard` stehen). Neovim braucht dafür ein Hilfsprogramm wie `wl-clipboard` oder `xclip`.

## Teil 5: Suchen und Ersetzen

**Erst eine frische Kopie:** Teil 4 hat Zeilen gelöscht und verdoppelt, die Zeilennummern stimmen also nicht mehr mit der Originaldatei überein. In diesem Teil arbeitest du aber mit Zeilennummern. Beende Vim (`:wq` oder `:q!`, wie du magst) und hol dir eine frische Kopie:
```bash
cp vim-uebungsdatei.txt uebung.txt
vim uebung.txt
```

| Aktion | Befehl |
|---|---|
| Vorwärts suchen | `/Begriff` |
| Rückwärts suchen | `?Begriff` |
| Nächster / vorheriger Treffer | `n` / `N` |
| Wort unter dem Cursor suchen | `*` (vorwärts), `#` (rückwärts) |
| Hervorhebung ausschalten | `:noh` |
| Ersetzen | `:s/alt/neu/` |

**5.1 Einfach suchen**
Suche nach `Kaffee` und spring mit `n` durch die Treffer. Wie viele gibt es?
Falls die Treffer nicht hervorgehoben werden: `:set hlsearch` (in Neovim schon an).

**5.2 Groß und klein**
Suche nach `windows`. Wie viele Treffer? Suche dann nach `windows\c`. Und jetzt?
Probiere auch `:set ignorecase` und `:set smartcase`. Was macht `smartcase`?

**5.3 Ersetzen in der ganzen Datei**
Im Büro aus Abschnitt 5 wird umgestellt: `Windows` wird überall zu `Linux`, die `windows` des Hausmeisters bleiben. Falls du in 5.2 `ignorecase` eingeschaltet hast, schalte es vorher mit `:set noignorecase` wieder aus.
```
:%s/Windows/Linux/g
```
Was bedeuten `%` und `g`? Wie viele Ersetzungen meldet Vim? Mach es mit `u` rückgängig.

**5.4 Mit Nachfrage ersetzen**
```
:%s/Windows/Linux/gc
```
Vim fragt jetzt bei jedem Treffer. Lass die Zeile mit dem Kaffeeautomaten aus (der bleibt bei Windows, der hat Charakter).

**5.5 Ersetzen in einem Bereich**
- `:41,43s/Buero/Homeoffice/` ersetzt nur in den Zeilen 41 bis 43. Was passiert mit Zeile 44?
- Markiere Zeilen mit `V` und tippe `:`. Vim schreibt automatisch `:'<,'>` davor. Ersetze so in Abschnitt 3 `Kaffee` durch `Tee`.

**5.6 Ganze Wörter**
Suche nach `/debug`. Welche Zeilen findet Vim in Abschnitt 13? Suche jetzt nach `/\<debug\>`. Was bewirken `\<` und `\>`?

**5.7 (Bonus) Der globale Befehl**
`:g` führt einen Befehl auf allen Zeilen aus, die zu einem Muster passen.
- `:g/debug/` zeigt alle Zeilen mit "debug" an.
- `:g/^#/d` löscht alle Zeilen, die mit `#` beginnen. Wie viele sind es?
- Mach es mit `u` rückgängig.

**5.8 (Bonus) Sortieren**
Dank der frischen Kopie ist die Morgenroutine wieder durcheinander. Sortiere sie mit einem einzigen Befehl:
```
:22,27sort
```
Linux-Variante über ein externes Programm: `:22,27!sort`

## Teil 6: Werkzeuge für Fortgeschrittene

**6.1 Dateien und Befehlsausgaben einfügen**
- `:r hallo.txt` fügt den Inhalt von `hallo.txt` unter der aktuellen Zeile ein.
- `:r !date` fügt die Ausgabe von `date` ein. Probiere auch `:r !uname -r`.
- `:!ls` führt einen Befehl aus, ohne etwas einzufügen.

**6.2 Mehrere Dateien: Puffer**
- `:e hallo.txt` öffnet eine weitere Datei.
- `:ls` listet alle offenen Puffer.
- `:bn` / `:bp` wechseln zum nächsten / vorherigen Puffer.
- **Nur Vim:** Hat der aktuelle Puffer ungespeicherte Änderungen (zum Beispiel aus 6.1), verweigert Vim `:e` und `:bn` mit dem Fehler E37. Speichere vorher mit `:w` oder erlaube das Wechseln mit `:set hidden`. Neovim hat `hidden` schon eingeschaltet.
- Kopiere die Morgenroutine aus `uebung.txt` nach `hallo.txt`. Die Zwischenspeicher gelten für alle Puffer.

**6.3 Mehrere Fenster**
- `:split hallo.txt` teilt das Fenster waagerecht, `:vsplit hallo.txt` senkrecht.
- `Strg+W` und dann `w` springt zum nächsten Fenster, `Strg+W` und `h`/`j`/`k`/`l` in eine Richtung.
- `:q` schließt das aktuelle Fenster, `:only` alle anderen.

**6.4 Ein Makro aufzeichnen**
Seit der frischen Kopie in Teil 5 stehen in Abschnitt 10 keine `- ` mehr. Jetzt lösen wir das Problem aus 4.9 noch einmal, diesmal mit einem Makro:
1. Cursor auf `ls`.
2. `qa` startet die Aufzeichnung in Register a.
3. `I`, `- ` tippen, `Esc`, `j`.
4. `q` beendet die Aufzeichnung.
5. `7@a` spielt das Makro siebenmal ab.

`@@` wiederholt das zuletzt abgespielte Makro. In Neovim spielt zusätzlich `Q` das zuletzt aufgezeichnete Makro ab.

**6.5 Auskommentieren**
Leg eine Testdatei `test.sh` an und schreib fünf Zeilen wie `echo "Zeile 1"`.
- **Neovim (ab 0.10):** `gcc` kommentiert die aktuelle Zeile, `gc` eine visuelle Markierung. Funktioniert sofort.
- **Vim (ab 9.1):** Erst mit `:packadd comment` einschalten, dann wie bei Neovim.

Warum funktioniert das in `uebung.txt` nicht oder nur schlecht?

**6.6 Ein- und Ausrücken**
- `>>` und `<<` rücken die aktuelle Zeile ein und aus.
- Im visuellen Modus wirkt `>` auf alle markierten Zeilen. Wiederhole mit `.`.
- `=` rückt automatisch passend ein. Mach im `server`-Block die Einrückungen kaputt (zum Beispiel mit `<<` auf einigen Zeilen). Setz dann den Cursor auf die `{` hinter `server` und tippe `=%`. Was passiert?

**6.7 Wie viel steht da?**
`g` und dann `Strg+G` zeigt Wörter, Zeichen und Position. Markiere einen Abschnitt und probiere es noch mal.

**6.8 (Bonus) Zeitreise**
Vim merkt sich deine Änderungen mit Zeitstempel.
- `:earlier 2m` zeigt den Stand von vor zwei Minuten.
- `:later 2m` geht wieder vorwärts.

**6.9 (Bonus) Autovervollständigung**
Tippe im Einfügemodus `Schatz` und drücke `Strg+N`. Woher kommen die Vorschläge?

## Teil 7: Konfiguration und Farben

### Wo die Konfiguration liegt

| | Vim | Neovim |
|---|---|---|
| Datei | `~/.vimrc` (oder `~/.vim/vimrc`, ab 9.2 auch `~/.config/vim/vimrc`) | `~/.config/nvim/init.vim` **oder** `~/.config/nvim/init.lua` |
| Verzeichnis für Erweiterungen | `~/.vim/` | `~/.config/nvim/` |
| Öffnen aus dem Editor | `:e $MYVIMRC` | `:e $MYVIMRC` |

Neovim akzeptiert entweder `init.vim` oder `init.lua`, nicht beide gleichzeitig. `$MYVIMRC` ist erst gesetzt, wenn beim Start eine Konfigurationsdatei geladen wurde. Beim allerersten Mal öffnest du die Datei also über ihren Pfad (z. B. `vim ~/.vimrc`).

**7.1 Die Falle bei Vim**
Solange es keine `~/.vimrc` gibt, lädt Vim eine Datei mit sinnvollen Grundeinstellungen (`defaults.vim`). Sobald du eine eigene `~/.vimrc` anlegst, **fällt diese weg**, und plötzlich fehlen zum Beispiel Syntaxfarben. Deshalb beginnt jede Vim-Konfiguration hier mit zwei Zeilen, die die Grundeinstellungen trotzdem laden. Neovim betrifft das nicht.

**7.2 Deine eigene Konfiguration**

Für **Vim** in `~/.vimrc`:
```vim
" Grundeinstellungen von Vim trotzdem laden
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set number
set relativenumber
set cursorline
set colorcolumn=80
set hlsearch
set ignorecase
set smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:»·,trail:·
```

Für **Neovim** in `~/.config/nvim/init.lua`:
```lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·" }
```

Speichere, starte neu und teste jede Einstellung. Mit `:source %` lädst du eine geänderte Konfiguration, ohne den Editor neu zu starten (die Konfigurationsdatei muss dafür gerade offen sein).

Frage zum Nachdenken: Warum ist `expandtab` für ein Makefile eine schlechte Idee?

**7.3 Farbschemata ausprobieren**
Tippe `:colorscheme ` (mit Leerzeichen) und drücke `Tab`. Vim zeigt dir die mitgelieferten Schemata. Probiere einige aus, zum Beispiel `habamax`, `desert` oder `retrobox`.
- Was ändert `:set background=light` bzw. `:set background=dark`?
- Gefällt dir eins? Trag es in deine Konfiguration ein:
  - Vim: `colorscheme habamax`
  - Neovim: `vim.cmd.colorscheme("habamax")`

**7.4 Einzelne Farben anpassen**
Jedes Element hat eine Hervorhebungsgruppe. `:highlight` zeigt alle, `:highlight LineNr` nur die Zeilennummern.

Für **Vim**:
```vim
set termguicolors
colorscheme habamax
highlight LineNr       guifg=#666666
highlight CursorLineNr guifg=#ffcc00 gui=bold
highlight ColorColumn  guibg=#3a0000
```

Für **Neovim**:
```lua
vim.cmd.colorscheme("habamax")
vim.api.nvim_set_hl(0, "LineNr", { fg = "#666666" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffcc00", bold = true })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3a0000" })
```

Wichtig ist die Reihenfolge: Erst das Farbschema, dann deine Anpassungen, sonst überschreibt das Schema sie wieder. Neovim nutzt echte Farben (`termguicolors`), sobald dein Terminal das kann. In Vim schaltest du sie mit `set termguicolors` ein; ohne gelten stattdessen die `ctermfg`/`ctermbg`-Angaben mit Farbnamen wie `red` oder `darkgrey`.

**Aufgabe:** Bau dir dein eigenes Schema, zum Beispiel "Retro-Terminal" (grün auf schwarz) oder "Augenkrebs" (für den Lacher in der Gruppe).

**7.5 (Bonus) Eine eigene Syntax**
Vim lässt sich beibringen, eigene Dateitypen einzufärben. Du brauchst zwei Dateien (bei Neovim liegen sie unter `~/.config/nvim/` statt `~/.vim/`).

`~/.vim/ftdetect/liste.vim` erkennt den Dateityp:
```vim
autocmd BufRead,BufNewFile *.liste setfiletype liste
```

`~/.vim/syntax/liste.vim` legt die Farben fest:
```vim
syntax match listeOffen     /\[ \]/
syntax match listeErledigt  /\[x\].*/
syntax match listeWichtig   /!!.*/
syntax match listeKommentar /^#.*/

highlight listeOffen    ctermfg=red    guifg=#ff5555
highlight listeErledigt ctermfg=green  guifg=#50fa7b
highlight listeWichtig  cterm=bold ctermfg=yellow gui=bold guifg=#f1fa8c
highlight link listeKommentar Comment
```

Leg `einkauf.liste` an:
```
# Wochenende
[ ] Kaffee kaufen !! wichtig
[x] Tee kaufen
[ ] Neue Tastatur
```
Erweitere die Syntax: Wie bekommst du Datumsangaben wie `2026-10-12` blau?

**7.6 (Bonus) Vim als Standard-Editor**
In `~/.bashrc`:
```bash
export EDITOR=nvim   # oder vim
```
Danach öffnen `git commit`, `crontab -e` und `sudoedit` deinen Editor. Warum ist `sudoedit /etc/hosts` angenehmer als `sudo vim /etc/hosts`, wenn du deine eigene Konfiguration mit Farben hast?

**7.7 (Bonus, nur Neovim) Gesundheitscheck**
`:checkhealth` prüft deine Neovim-Installation, zum Beispiel ob die Zwischenablage funktioniert. Was meldet es bei dir?

## Teil 8: Abschluss-Speedrun

Nimm eine frische Kopie und stopp die Zeit. Ziel: unter fünf Minuten. Wer mag, zählt zusätzlich die Tastendrücke: In Vim gewinnt, wer am wenigsten braucht (es gibt dafür sogar einen Wettbewerb namens VimGolf).

```bash
cp vim-uebungsdatei.txt speedrun.txt
vim speedrun.txt
```

1. Schalte die Zeilennummern ein.
2. Kopiere Zeile 134 ans Dateiende.
3. Ersetze in der ganzen Datei `Kaffee` durch `Tee`.
4. Lösche Abschnitt 4 komplett (Überschrift und Inhalt).
5. Füge ganz oben in der Datei die Ausgabe von `whoami` ein.
6. Lösche alle Zeilen, die mit `#` beginnen.
7. Nummeriere die Kapitel in Abschnitt 11 von 1 bis 6.
8. Speichere und beende.

Vergleiche mit dem Original:
```bash
diff vim-uebungsdatei.txt speedrun.txt
```

## Spickzettel

| Bereich | Befehl | Funktion |
|---|---|---|
| **Modi** | `i` / `a` | Einfügen vor / nach dem Cursor |
| | `I` / `A` | Einfügen am Zeilenanfang / -ende |
| | `o` / `O` | Neue Zeile darunter / darüber |
| | `v` / `V` / `Strg+V` | Visuell: Zeichen / Zeilen / Block |
| | `Esc` | Zurück in den Normalmodus |
| **Datei** | `:w` | Speichern |
| | `:w name` / `:saveas name` | Kopie speichern / Speichern unter |
| | `:q` / `:q!` | Beenden / ohne Speichern beenden |
| | `:wq` / `:x` / `ZZ` | Speichern und beenden |
| | `:e datei` | Datei öffnen |
| | `:r datei` / `:r !befehl` | Datei / Befehlsausgabe einfügen |
| **Bewegen** | `h` `j` `k` `l` | Links, runter, hoch, rechts |
| | `w` / `b` / `e` | Wortanfang vor / zurück, Wortende |
| | `0` / `^` / `$` | Zeilenanfang / erstes Zeichen / Zeilenende |
| | `f`x / `t`x | Zu / vor das Zeichen x |
| | `gg` / `G` / `42G` | Dateianfang / -ende / Zeile 42 |
| | `{` / `}` | Absatz zurück / vor |
| | `%` | Passende Klammer |
| | `Strg+D` / `Strg+U` | Halbe Seite runter / hoch |
| | `ma` / `'a` | Marke setzen / anspringen |
| | `Strg+O` / `Strg+I` | Zurück / vor in der Sprungliste |
| **Bearbeiten** | `x` | Zeichen löschen |
| | `dd` / `yy` / `cc` | Zeile löschen / kopieren / ändern |
| | `dw` / `cw` / `yw` | Wort löschen / ändern / kopieren |
| | `ciw` / `ci"` / `di{` | Wort / Text in "" / Blockinhalt bearbeiten |
| | `p` / `P` | Einfügen nach / vor |
| | `u` / `Strg+R` | Rückgängig / Wiederholen |
| | `.` | Letzte Änderung wiederholen |
| | `>>` / `<<` | Ein- / ausrücken |
| | `Strg+A` / `Strg+X` | Zahl hoch / runter zählen |
| | `gcc` | Zeile kommentieren (Neovim; Vim nach `:packadd comment`) |
| **Suchen** | `/text` / `?text` | Vorwärts / rückwärts suchen |
| | `n` / `N` | Nächster / vorheriger Treffer |
| | `*` | Wort unter dem Cursor suchen |
| | `:%s/alt/neu/g` | In der ganzen Datei ersetzen |
| | `:%s/alt/neu/gc` | Ersetzen mit Nachfrage |
| | `:g/muster/d` | Alle passenden Zeilen löschen |
| | `:noh` | Hervorhebung aus |
| **Anzeige** | `:set nu` / `:set rnu` | Zeilennummern / relative Zeilennummern |
| | `:set list` | Leerraum sichtbar |
| | `:set wrap!` | Zeilenumbruch umschalten |
| | `:colorscheme name` | Farbschema wechseln |
| **Makros** | `qa` … `q` | In Register a aufzeichnen |
| | `@a` / `@@` | Abspielen / zuletzt gespieltes wiederholen |
| **Fenster** | `:split` / `:vsplit` | Teilen |
| | `Strg+W w` | Fenster wechseln |
| **Hilfe** | `:help thema` | Hilfe öffnen |


## Quellen

> [!NOTE]
> Hilfe findest du mit `:help` in Vim und Neovim, `vimtutor`, in Neovim `:Tutor`
