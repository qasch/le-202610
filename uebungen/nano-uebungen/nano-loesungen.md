# Lösungen zu den nano-Übungen

Musterlösungen und Antworten zu `nano-uebungen.md`. Zeilenangaben beziehen sich auf die unveränderte `uebungsdatei.txt` (129 Zeilen).

---

## Teil 1: Öffnen, Schreiben, Speichern, Beenden

**1.1** `^X` heißt "Beenden" (Exit).

**1.2** In der Titelleiste erscheint rechts "Geändert" (bzw. "Modified"). Mit den Optionen `stateflags` oder `minibar` zeigt nano stattdessen ein Sternchen hinter dem Dateinamen.

**1.3** `^O` fragt nach dem Dateinamen und lässt dich ihn ändern ("Speichern unter"). `^S` speichert sofort ohne Rückfrage unter dem aktuellen Namen.

**1.4** Die fünfte Zeile fehlt, weil beim Beenden mit **N** verworfen wurde.

**1.5** Nach `^O` mit neuem Namen fragt nano, ob unter einem anderen Namen gespeichert werden soll. Mit **J** bestätigen. Danach existieren `hallo.txt` und `hallo-kopie.txt`. Wichtig: nano arbeitet ab jetzt mit `hallo-kopie.txt` weiter.

**1.6** `M-D` (Alt+D) zählt Zeilen, Wörter und Zeichen.

---

## Teil 2: In der Datei bewegen

**2.1** `Pos1`/`Ende` und `^A`/`^E` machen dasselbe.

**2.2** Zeile 8 hat elf Wörter, also zehn Sprünge vom Zeilenanfang bis zum letzten Wort. Der nächste Sprung landet nicht am Zeilenende, sondern am Anfang der folgenden Zeile.

**2.3** `^V`/`^Y` funktionieren auch dort, wo Bildtasten fehlen oder vom Terminal nicht korrekt durchgereicht werden.

**2.5** `^C` zeigt einmalig Zeile, Spalte und Zeichenposition (jeweils mit Gesamtzahl und Prozentangabe).

**2.6** Die Schnitzeljagd:

| Schritt | Fundort | Weg dorthin | Codewort |
|---|---|---|---|
| 1 | Zeile 15 | steht in Abschnitt 2 | TUX |
| 2 | Zeile 120 | `^_` bzw. `M-G`, dann `120` | PINGUIN |
| 3 | Zeile 129 | `M-/` | KERNEL |
| 4 | Zeile 109 | `^W` Schatztruhe | BASH |

**2.7** Ein Block ist ein Textstück, das durch eine oder mehrere Leerzeilen von anderen getrennt ist.

**2.8** Von `{` in Zeile 53 springt der Cursor zur `}` in Zeile 56. Von der `{` hinter `server` (Zeile 50) zur `}` in Zeile 60. Nochmal `M-]` springt zurück.

**2.9** `+71` öffnet die Datei in Zeile 71. `+/Schatztruhe` öffnet sie beim ersten Vorkommen von "Schatztruhe" (Zeile 108). Mit `+?Begriff` geht es zum letzten Vorkommen.

**2.10** Ab nano 8.5 zentriert `^L` die aktuelle Zeile im Fenster. In 8.1 bis 8.4 wechselt `^L` reihum zwischen Mitte, oben und unten; ab 8.5 übernimmt das `M-%`. Vor 8.1 zeichnet `^L` nur den Bildschirm neu.

---

## Teil 3: Die Anzeige anpassen

**3.1** `M-N` schaltet die Zeilennummern um. Das Codewort PINGUIN steht in Zeile 120.

**3.2** `M-C` zeigt die Position dauerhaft und aktualisiert sie bei jeder Bewegung. `^C` zeigt sie nur einmal.

**3.3** Mit `M-P` erscheinen Tabulatoren als `»` und Leerzeichen als `⋅` (in UTF-8-Umgebungen).
- Zeile 65 beginnt mit einem Tabulator, Zeile 66 mit vier Leerzeichen.
- Zeile 64 hat drei Leerzeichen am Ende: mit `Ende` ans Zeilenende, dreimal `Backspace`.
- In Makefiles müssen Befehle mit einem echten Tabulator eingerückt sein. In YAML sind Tabulatoren zur Einrückung verboten. Leerzeichen am Zeilenende können Werte in Konfigurationsdateien verfälschen.

**3.4** Ohne Soft-Wrap scrollt die Ansicht nach rechts (ab nano 9.0 alle Zeilen gemeinsam, vorher nur die aktuelle), am Rand erscheint `>` als Hinweis auf weiteren Text. Mit `M-S` wird die Zeile optisch umbrochen, hat aber weiterhin nur **eine** Zeilennummer (71), weil sie in der Datei eine einzige Zeile ist.

**3.6** Mit `-v` lässt sich nichts ändern. Sinnvoll zum Ansehen von Systemdateien wie `/etc/fstab`, wenn man nichts versehentlich verändern will.

---

## Teil 4: Ausschneiden, Kopieren, Einfügen, Rückgängig

**4.1** Zum Beispiel: Cursor auf "Schritt 1", `^K`, Cursor an die erste Zeile des Abschnitts, `^U`. So weiter mit Schritt 2 bis 6.

**4.2** `^U` fügt alle drei Zeilen ein. Mehrere `^K` direkt hintereinander sammeln die Zeilen im Cutbuffer. Sobald man zwischendurch den Cursor bewegt, beginnt der nächste `^K` einen neuen Cutbuffer.

**4.3** Cursor auf die Zeile (nach 4.2 ist das Zeile 33, in der unveränderten Datei Zeile 36), `M-6` (der Cursor rutscht eine Zeile tiefer), `^U`.

**4.4** Bei einer Markierung schneidet `^K` bzw. kopiert `M-6` genau den markierten Bereich, auch Teile einer Zeile.

**4.5** `M-U` macht beliebig viele Schritte rückgängig, `M-E` stellt sie wieder her.

**4.6** Korrigiert lauten die Zeilen:
```
Dieser Satz hat mehrere Fehler, die du verbessern sollst.
Der Pinguin ist das Maskottchen von Linux.
Nano ist ein Editor fuer das Terminal.
```

**4.7** `^U` bringt die mit `^K` ausgeschnittene Zeile zurück. `Alt+Entf` wirft die Zeile weg, ohne den Cutbuffer anzutasten. Praktisch, wenn man zwischendurch etwas löschen will, ohne den gerade kopierten Text zu verlieren.

---

## Teil 5: Suchen und Ersetzen

**5.1** Es gibt 5 Treffer für "Kaffee" (Zeilen 22, 26, 27, 42, 45).

**5.2** Im Suchfeld schaltet `M-C` die Groß-/Kleinschreibung um, `M-B` die Suchrichtung, `M-R` reguläre Ausdrücke. Der aktuelle Zustand steht in eckigen Klammern im Suchfeld, z. B. `[Groß-/Kleinschreibung]`.

**5.3** Ohne Beachtung der Schreibweise: 5 Treffer. Mit Beachtung: 1 Treffer (Zeile 44).

**5.4** `^\`, im Suchfeld `M-C` drücken, `Windows` eingeben, Enter, `Linux` eingeben, Enter, dann **A**. nano meldet 4 Ersetzungen. Die `windows` in Zeile 44 bleiben stehen.
Alternative ohne `M-C`: bei jeder Fundstelle einzeln mit **J** oder **N** entscheiden.

**5.5** Nur `Buero` in Zeile 41 wird ersetzt. Ersetzen wirkt bei aktiver Markierung nur innerhalb der Markierung, Zeile 44 bleibt unverändert.

**5.6** `^Schritt [1-3]` findet die Zeilen mit Schritt 1, 2 und 3. Nach dem Sortieren in 4.1 sind das die Zeilen 22 bis 24 (in der unveränderten Datei 25, 23 und 27). `^` steht für den Zeilenanfang, `[1-3]` für eine Ziffer von 1 bis 3.

---

## Teil 6: Werkzeuge für Fortgeschrittene

**6.1** `M-/`, dann `^R`, `hallo.txt`, Enter.

**6.2** Vor Version 5.0 heißt der Weg `^R` und dann `^X`.

**6.3** Mit `M-6` bleibt die Morgenroutine in `uebung.txt` stehen, mit `^K` wäre sie dort verschwunden. Der Cutbuffer gilt für alle offenen Puffer. In der Titelleiste zeigt nano an, wie viele Dateien offen sind.

**6.4** Das Kommentarzeichen kommt aus der aktiven Syntaxdefinition (Befehl `comment`). Ohne Syntax nimmt nano `#`. Für CSS wäre es z. B. `/* … */`.

**6.6** Ergebnis in Abschnitt 10:
```
- ls
- cd
- pwd
- cp
- mv
- rm
- mkdir
- cat
```
Alternative ohne Makro: Zeilen 83 bis 90 markieren (die Markierung am Ende von Zeile 90 beenden, sonst bekommt auch die Leerzeile 91 ein `- `), `^\`, `M-R` (regulärer Ausdruck), Suchbegriff `^`, Ersetzung `- `, dann **A**.

**6.7** Bei aktiver Markierung zählt `M-D` nur den markierten Bereich. Die unveränderte Übungsdatei hat 129 Zeilen und rund 540 Wörter (nano zählt Wörter etwas anders als `wc`, kleine Abweichungen sind normal).

**6.8** Neben `uebung.txt` liegt jetzt `uebung.txt~` mit dem Stand vor dem Speichern.

---

## Teil 7: Konfiguration und Farben

**7.1** Das hängt von der Distribution ab. Unter Arch Linux ist die mitgelieferte `/etc/nanorc` weitgehend auskommentiert, andere Distributionen aktivieren die Syntaxhervorhebung schon dort.

**7.2** Die Wirkung der Optionen:

| Option | Wirkung |
|---|---|
| `linenumbers` | Zeilennummern links |
| `constantshow` | Position ständig in der Statusleiste |
| `mouse` | Cursor per Mausklick setzen, Doppelklick setzt die Markierung |
| `autoindent` | neue Zeile übernimmt die Einrückung der vorherigen |
| `tabsize 4` | Tabulator ist 4 statt 8 Spalten breit |
| `tabstospaces` | getippte Tabs werden zu Leerzeichen |
| `indicator` | Bildlaufleiste am rechten Rand |
| `guidestripe 80` | senkrechte Hilfslinie in Spalte 80 |

`tabstospaces` ist für Makefiles problematisch, weil `make` echte Tabulatoren vor Befehlen verlangt. Mit `M-V` und dann `Tab` lässt sich trotzdem ein echter Tabulator eingeben.

**7.3** Bei Shell-Skripten werden Schlüsselwörter, Strings, Variablen und Kommentare farbig. Bei `/etc/fstab` hängt es davon ab, ob eine passende Syntaxdatei vorhanden ist.

**7.4** Keine feste Lösung. Hinweise für die Kontrolle:
- Fehlerhafte Zeilen in der `nanorc` meldet nano beim Start unten in der Statusleiste.
- Schlüsselwörter müssen kleingeschrieben sein.
- `,yellow` ohne Vordergrundfarbe ist erlaubt.

**7.5** Datumsangaben in Blau:
```
color blue "[0-9]{4}-[0-9]{2}-[0-9]{2}"
```
Die Reihenfolge zählt: Spätere `color`-Zeilen übermalen frühere.

**7.6** `sudoedit` kopiert die Datei, öffnet sie mit deinem Editor **als normaler Benutzer** (also mit deiner `nanorc`) und schreibt sie danach mit Root-Rechten zurück. `sudo nano` startet dagegen den ganzen Editor als root, in der Regel mit dessen Konfiguration. Zusätzlich ist `sudoedit` sicherer, weil der Editor selbst keine Root-Rechte hat.

---

## Teil 8: Abschluss-Speedrun

Ein möglicher Weg:

1. `M-N` (entfällt, wenn `set linenumbers` in der `nanorc` steht)
2. `^_` bzw. `M-G`, `99`, Enter, `M-6`, `M-/`, `^U`
3. `^\`, `Kaffee`, Enter, `Tee`, Enter, **A** (5 Ersetzungen, inklusive "Teemaschine" und "Teeautomat")
4. Cursor auf die Überschrift von Abschnitt 4 (Zeile 30), `M-A`, mit `↓` bis Zeile 37, `^K`
5. `M-\`, `^T`, `whoami`, Enter
6. Cursor auf `server {`, `M-A`, bis zur schließenden `}` markieren, `M-3`
7. `M-D`
8. `^S`, `^X`

`diff` sollte genau diese Änderungen zeigen: die eingefügte Zeile oben, die fünf Kaffee-Zeilen, den fehlenden Abschnitt 4, den auskommentierten Server-Block und die angehängte Zeile 99 am Ende.

---

## Quellen

- GNU nano Cheatsheet: https://www.nano-editor.org/dist/latest/cheatsheet.html
- Handbuchseite nanorc: https://www.nano-editor.org/dist/latest/nanorc.5.html
- Versionshinweise von nano: https://www.nano-editor.org/news.php
