# Lösungen zu den Vim/Neovim-Übungen

Musterlösungen und Antworten zu `vim-uebungen.md`. Zeilenangaben beziehen sich auf die unveränderte `vim-uebungsdatei.txt` (164 Zeilen). Ab Teil 5 arbeiten alle mit einer frischen Kopie, dort stimmen sie wieder genau. Die Befehle aus Teil 4 und 5 sind in Vim 9.1 getestet.

---

## Teil 1: Modi, Schreiben, Speichern, Beenden

**1.1** Im Normalmodus sind Buchstaben Befehle. "Hallo" bedeutet für Vim zum Beispiel: `H` (Cursor nach oben im Bildschirm), `a` (Einfügen nach dem Cursor) und dann wird "llo" als Text eingefügt. Deshalb wirkt es zufällig.

**1.3**

| Befehl | Wo fängst du an zu schreiben? |
|---|---|
| `i` | vor dem Cursor |
| `a` | nach dem Cursor |
| `I` | am Zeilenanfang (erstes Zeichen, das kein Leerzeichen ist) |
| `A` | am Zeilenende |
| `o` | in einer neuen Zeile darunter |
| `O` | in einer neuen Zeile darüber |

**1.4** Mit ungespeicherten Änderungen verweigert `:q` das Beenden (Fehler E37) und verlangt `!` zum Erzwingen. `:x` und `ZZ` speichern nur, wenn es Änderungen gibt, und beenden dann. `:wq` speichert immer.

**1.5** Die Zeile fehlt, weil mit `:q!` verworfen wurde.

**1.6** `:w hallo-kopie.txt` schreibt eine Kopie, du arbeitest aber weiter in `hallo.txt`. Das folgende `:w` landet also in `hallo.txt`. `:saveas hallo-kopie2.txt` schreibt die Kopie und wechselt in sie, das folgende `:w` landet in `hallo-kopie2.txt`.

**1.7** `ZQ` beendet ohne zu speichern, wie `:q!`.

---

## Teil 2: In der Datei bewegen

**2.3** `w` hält an jedem Satzzeichen an (`/`, `.`, `=` usw.), `W` springt nur an Leerzeichen weiter. In Zeile 120 braucht `w` deshalb viele Sprünge, `W` einen.

**2.4** `f"` springt **auf** das Anführungszeichen, `t"` direkt **davor**. Das ist wichtig für Operatoren: `dt"` löscht bis zum Anführungszeichen, ohne es selbst zu löschen.

**2.6** `Strg+G` zeigt Dateinamen, ob die Datei geändert wurde, die Zeilenanzahl und die Position in Prozent.

**2.7** Die Schnitzeljagd:

| Schritt | Fundort | Weg dorthin | Codewort |
|---|---|---|---|
| 1 | Zeile 15 | steht in Abschnitt 2 | TUX |
| 2 | Zeile 155 | `155G` oder `:155` | PINGUIN |
| 3 | Zeile 164 | `G` | KERNEL |
| 4 | Zeile 144 | `/Schatztruhe`, dann `j` | BASH |

**2.8** `{` und `}` springen zur vorherigen bzw. nächsten Leerzeile. Von der `{` in Zeile 53 springt `%` zur `}` in Zeile 56, von der `{` hinter `server` (Zeile 50) zur `}` in Zeile 60.

**2.9** `'a` springt an den Anfang der markierten Zeile, `` `a `` an die exakte Position (Zeile und Spalte).

**2.10** `+71` öffnet in Zeile 71, `+/Schatztruhe` beim ersten Treffer der Suche (Zeile 143).

**2.11** `zz` holt die aktuelle Zeile in die Bildschirmmitte, `zt` nach oben, `zb` nach unten. Der Cursor bleibt in seiner Textzeile.

---

## Teil 3: Die Anzeige anpassen

**3.1** Mit `relativenumber` zeigt jede Zeile ihren Abstand zum Cursor. So siehst du sofort, dass das Ziel zum Beispiel `7j` entfernt ist oder dass `4dd` die nächsten Zeilen bis zu einer bestimmten Stelle löscht. Sind beide Optionen an, zeigt die Cursorzeile ihre echte Zeilennummer und alle anderen den Abstand.

**3.2** In Vim erscheinen Tabulatoren mit den Grundeinstellungen als `^I` und Zeilenenden als `$`. Neovim zeigt Tabulatoren als `>` und Leerzeichen am Zeilenende als `-`. Zeile 65 beginnt mit einem Tabulator, Zeile 66 mit Leerzeichen. Leerzeichen in Zeile 64 entfernen: `64G`, `$`, dreimal `x` (oder `3X` direkt hinter dem Text), oder ganz elegant `:64s/\s\+$//`.

**3.3** Die lange Zeile hat immer nur **eine** Zeilennummer (71). `linebreak` bricht beim Umbruch an Wortgrenzen statt mitten im Wort.

**3.5** Beim Versuch zu ändern warnt Vim, dass die Datei schreibgeschützt geöffnet ist. `:w` schlägt fehl (`:w!` würde es trotzdem erzwingen, wenn die Dateirechte es erlauben).

---

## Teil 4: Bearbeiten im Normalmodus

**4.1** Zum Beispiel "Schritt 1" mit `dd` ausschneiden, an den Anfang des Abschnitts gehen, `P`. Und so weiter. `ddp` tauscht die aktuelle Zeile mit der darunter.

**4.2** Cursor auf Zeile 33, dann `3dd`.

**4.3** Cursor auf Zeile 36, `yy`, `p`.

**4.4** Die Überschrift ist durch Leerzeilen vom Text getrennt und damit ein eigener Absatz. `dap` löscht deshalb nur die Überschrift samt folgender Leerzeile. `d2ap` löscht zwei Absätze mit ihren Leerzeilen, also Überschrift und Text. `u` holt jeweils alles zurück.

**4.5** `.` wiederholt das `x`, auch das `#` vor `timeout` verschwindet. Mit `j` und `.` auch vor `retries`.

**4.6** Die Lösungswege im Detail:

| Zeile | Ablauf | Ergebnis |
|---|---|---|
| 1 (76) | Cursor auf "Dises", `cw` "Dieser" `Esc`; Cursor auf das h von "Fhler", `i` "e" `Esc` | Dieser Satz hat mehrere Fehler, … |
| 2 (77) | Cursor auf das zweite i in "Pingiun" (z. B. `0`, `fi`, `;`), `xp`; Cursor auf das t von "Maskotchen", `a` "t" `Esc` | Der Pinguin ist das Maskottchen von Linux. |
| 3 (78) | Cursor irgendwo in "Termnial", `ciw` "Terminal" `Esc` | Vim ist ein Editor fuer das Terminal. |
| 4 (79) | Cursor auf das erste "Wort", `dw` | In diesem Satz steht ein Wort doppelt. |
| 5 (80) | Cursor auf "ziemlich", `c2w` "grossartiger" `Esc` | Vim ist ein grossartiger Editor. |

**4.7** Textobjekte:
- `ci"` funktioniert auch, wenn der Cursor noch vor dem Anführungszeichen in der Zeile steht. Vim sucht das nächste Paar in der Zeile. Steht der Cursor dagegen hinter dem schließenden Anführungszeichen (z. B. auf dem `;`), passiert nichts.
- `di{` in der `root`-Zeile löscht die `root`- und die `index`-Zeile, die Klammern bleiben stehen.
- `da{` löscht zusätzlich die Klammern selbst.
- `dip` löscht nur den Absatz, `dap` auch die folgende Leerzeile.

**4.8** Im visuellen Modus rückt `>` alle markierten Zeilen um eine Stufe ein (`shiftwidth`).

**4.9** Spalte löschen: Cursor auf das D von "Distro" (Zeile 107), `Strg+V`, `5j`, `9l`, `d`. Präfix einfügen: Der Text erscheint erst in allen Zeilen, wenn du `Esc` gedrückt hast.

**4.10** `Strg+A` erhöht die Zahl unter oder rechts vom Cursor. Mit `g Strg+A` im visuellen Modus zählt Vim fortlaufend hoch: Die erste Zeile bekommt +1, die zweite +2 usw. Ergebnis: Kapitel 1 bis 6.

**4.11** Register a bleibt erhalten, auch wenn du danach andere Dinge kopierst oder löschst. Das Standardregister `""` wird dagegen bei jedem `d`, `x` oder `y` überschrieben.

---

## Teil 5: Suchen und Ersetzen

**5.1** 5 Treffer (Zeilen 22, 26, 27, 42, 45).

**5.2** `/windows` findet 1 Treffer (Zeile 44), `/windows\c` findet 5. `\c` ignoriert die Schreibweise für diese eine Suche, `\C` erzwingt sie. Mit `ignorecase` und `smartcase` wird die Schreibweise nur dann beachtet, wenn der Suchbegriff Großbuchstaben enthält.

**5.3** `%` steht für alle Zeilen der Datei, `g` für alle Treffer innerhalb einer Zeile (ohne `g` nur der erste pro Zeile). Vim meldet 4 Ersetzungen in 4 Zeilen.

**5.4** Bei den Nachfragen: `y` ersetzen, `n` überspringen, `a` alle restlichen, `q` abbrechen, `l` diesen ersetzen und dann aufhören. Für die Kaffeeautomat-Zeile (45) mit `n` antworten.

**5.5** Zeile 44 bleibt unverändert, weil sie außerhalb des Bereichs liegt. Im markierten Bereich lautet der Befehl `:'<,'>s/Kaffee/Tee/`.

**5.6** `/debug` findet `debug=true` (119) und `debug_level=3` (122). `\<` und `\>` markieren Wortgrenzen, deshalb findet `/\<debug\>` nur noch Zeile 119. Der Unterstrich gehört zum Wort, `debug_level` ist also ein eigenes Wort.

**5.7** `:g/^#/d` löscht 4 Zeilen (117, 120, 123, 124), Vim meldet die Anzahl unten in der Statuszeile. Ohne die frische Kopie wäre es nur noch eine Zeile gewesen, weil 4.5 drei der `#` schon entfernt hat. Bei weniger als drei Zeilen meldet Vim übrigens gar nichts (Option `report`).

**5.8** `:22,27sort` sortiert die Zeilen alphabetisch, also Schritt 1 bis 6. `:22,27!sort` schickt die Zeilen durch das Linux-Programm `sort` und ersetzt sie durch dessen Ausgabe.

---

## Teil 6: Werkzeuge für Fortgeschrittene

**6.2** `:ls` zeigt alle Puffer mit Nummer. `%` markiert den aktuellen, `#` den zuletzt benutzten. Zwischen den beiden springst du mit `Strg+^` (auf deutscher Tastatur oft schwierig, dann `:b#`). In Vim muss der aktuelle Puffer vor dem Wechsel gespeichert sein, sonst kommt E37, außer `hidden` ist eingeschaltet. Neovim hat `hidden` von Haus aus an.

**6.4** Ergebnis wie in 4.9: vor jeder Zeile steht `- `.

**6.5** Kommentieren braucht die Option `commentstring`, die normalerweise vom Dateityp gesetzt wird. Bei `test.sh` erkennt Vim ein Shell-Skript und nimmt `#`. Eine `.txt`-Datei hat keinen Dateityp mit Kommentarzeichen: Neovim meldet einen Fehler, Vim nimmt seinen Standard `/* … */`.

**6.6** `=%` auf der Klammer hinter `server` rückt den ganzen Block bis zur passenden Klammer neu ein. Ohne Dateityp nutzt Vim dafür seine eingebaute Einrückung für C-artige Klammerblöcke. Die Tiefe richtet sich nach `shiftwidth`, mit den Grundeinstellungen sind das Tabulatoren mit 8 Spalten.

**6.7** Im visuellen Modus zählt `g Strg+G` nur die Markierung.

**6.9** `Strg+N` schlägt Wörter vor, die schon in der Datei (und in anderen offenen Puffern) vorkommen, hier "Schatztruhe".

---

## Teil 7: Konfiguration und Farben

**7.2** `expandtab` ist für Makefiles problematisch, weil `make` echte Tabulatoren vor Befehlen verlangt. Im Einfügemodus erzeugt `Strg+V` und dann `Tab` trotzdem einen echten Tabulator. Die mitgelieferten Dateityp-Einstellungen für Makefiles schalten `expandtab` außerdem automatisch ab.

**7.3** `background` sagt dem Farbschema, ob dein Terminal hell oder dunkel ist. Viele Schemata haben eine helle und eine dunkle Variante.

**7.4** Keine feste Lösung. Kontrollhinweise:
- Ohne `termguicolors` greifen in Vim nur `ctermfg`/`ctermbg`, die `guifg`-Werte werden ignoriert.
- Anpassungen vor der `colorscheme`-Zeile werden vom Schema überschrieben.

**7.5** Datumsangaben in Blau:
```vim
syntax match listeDatum /\d\{4}-\d\{2}-\d\{2}/
highlight listeDatum ctermfg=blue guifg=#6699ff
```
Prüfen, ob der Dateityp erkannt wurde: `:set filetype?` muss `filetype=liste` anzeigen.

**7.6** `sudoedit` kopiert die Datei, öffnet sie mit deinem Editor **als normaler Benutzer** (also mit deiner Konfiguration) und schreibt sie danach mit Root-Rechten zurück. `sudo vim` startet dagegen den ganzen Editor als root, in der Regel mit dessen Konfiguration. Außerdem ist `sudoedit` sicherer, weil der Editor selbst keine Root-Rechte bekommt.

---

## Teil 8: Abschluss-Speedrun

Ein möglicher Weg:

1. `:set nu`
2. `134G`, `yy`, `G`, `p`
3. `:%s/Kaffee/Tee/g` (5 Ersetzungen, inklusive "Teemaschine" und "Teeautomat")
4. `:30,37d`
5. `:0r !whoami`
6. `:g/^#/d` (4 Zeilen)
7. `gg`, `/Kapitel 0`, `V`, `5j`, `g`, `Strg+A` (das `gg` sorgt dafür, dass die Suche sicher beim ersten Kapitel landet)
8. `:wq` (oder `ZZ`)

`diff` sollte genau diese Änderungen zeigen: die eingefügte Zeile oben, die fünf Kaffee-Zeilen, den fehlenden Abschnitt 4, die vier gelöschten Kommentarzeilen, die neu nummerierten Kapitel und die angehängte Zeile am Ende.

---

## Quellen

- Neovim-Hilfe "vim_diff": https://neo.vimhelp.org/vim_diff.txt.html
- Kommentarfunktion in Vim 9.1 und Neovim 0.10: https://batsov.com/articles/2025/05/25/how-to-vim-toggle-comments/
- Neuerungen in Vim 9.2: https://linuxiac.com/vim-9-2-debuts-full-wayland-and-xdg-base-directory-support/
