# Änderungsvorschläge zur Linux-Essentials-Dokumentation

Geprüft wurde die Datei [`dokumentation.md`](./dokumentation.md). Die folgenden Änderungsvorschläge sind entsprechend den Überschriften zweiter Ordnung (`##`) der Dokumentation gegliedert.

Die Bewertung unterscheidet zwischen:

- **Korrektur:** Die bestehende Aussage ist sachlich falsch oder irreführend.
- **Präzisierung:** Die Aussage ist im Kern richtig, aber zu allgemein oder unvollständig.
- **Ergänzung:** Zusätzlicher Kontext würde Missverständnisse vermeiden.

## Unterschied Terminal / Shell

### Korrekturen

- Bash ist auf vielen Linux-Systemen verbreitet, aber nicht grundsätzlich die Standardshell jeder Distribution oder jedes Benutzers.
- Fish darf nicht zusammen mit Zsh und Ksh als `sh`-kompatible Shell bezeichnet werden. Fish ist ausdrücklich nicht POSIX- beziehungsweise `sh`-kompatibel.

### Formulierungsvorschlag

> Unter Linux ist Bash weit verbreitet. Daneben existieren unter anderem Zsh und Ksh, die viele Gemeinsamkeiten mit der Bourne-Shell beziehungsweise POSIX-Shells haben. Fish verwendet dagegen bewusst eine nicht POSIX-kompatible Syntax.

## Kommandos

### Korrekturen

- Optionen können nicht generell vor oder nach den Argumenten stehen. Viele GNU-Programme erlauben eine flexible Reihenfolge, andere Programme und portable POSIX-Aufrufe erwarten Optionen vor den Operanden.
- `touch` erstellt nicht ausschließlich leere Dateien. Existiert eine Datei bereits, aktualisiert `touch` standardmäßig ihre Zugriffs- und Änderungszeitstempel.
- Shell-Builtins können über gemeinsame Manpages wie `bash-builtins(7)` oder die Bash-Manpage dokumentiert sein. Für Bash-Builtins ist `help <builtin>` normalerweise die direkteste Hilfe.
- Eine Manpage für ein externes Kommando ist üblich, aber nicht garantiert.

### Formulierungsvorschläge

> Als portable Grundregel sollten Optionen vor den Argumenten beziehungsweise Operanden stehen. Einige Programme, insbesondere viele GNU-Werkzeuge, akzeptieren zusätzlich andere Reihenfolgen.

> `touch` legt eine noch nicht vorhandene Datei leer an. Bei einer vorhandenen Datei aktualisiert das Kommando standardmäßig deren Zeitstempel.

## Dateioperationen

### Korrekturen

- `cp -r` ist nicht deshalb erforderlich, weil ein Verzeichnis Inhalt besitzt. Auch ein leeres Verzeichnis benötigt bei `cp` den rekursiven Modus. Dieser weist `cp` an, Verzeichnisbäume zu verarbeiten.
- Beim Löschen einer Datei wird ein Verzeichniseintrag beziehungsweise Hardlink entfernt. Die Datenblöcke können erst freigegeben werden, wenn keine weiteren Hardlinks und keine offenen Referenzen mehr existieren.
- Die Wiederherstellbarkeit gelöschter Daten ist nicht garantiert. SSD-TRIM, Copy-on-write-Dateisysteme, Verschlüsselung und weitere Schreibvorgänge können sie verhindern.
- `rmdir *` versucht auch reguläre Dateien zu verarbeiten und meldet dafür Fehler. Außerdem erfasst `*` standardmäßig keine Namen, die mit einem Punkt beginnen.
- `mv` kann innerhalb desselben Dateisystems meist Verzeichniseinträge umbenennen. Über Dateisystemgrenzen hinweg muss es die Daten kopieren und anschließend das Original entfernen. Entscheidend ist das Dateisystem, nicht allein eine Partition oder ein physischer Datenträger.

### Formulierungsvorschlag zum Löschen

> `rm` entfernt den angegebenen Verzeichniseintrag. Verweist kein weiterer Hardlink mehr auf die Datei und hält kein Prozess sie geöffnet, kann das Dateisystem die belegten Datenblöcke zur erneuten Verwendung freigeben. Eine spätere Wiederherstellung ist nicht zuverlässig möglich.

## Relative und absolute Pfadangaben

### Korrekturen und Präzisierungen

- Das Windows-Pendant zum Wurzelverzeichnis `/` wäre eher ein Laufwerkswurzelverzeichnis wie `C:\` als lediglich `C:`.
- `~` ist keine besondere Form eines absoluten Pfades. Es ist ein Kürzel, das die Shell vor der Ausführung expandiert. Das Ergebnis ist gewöhnlich der absolute Pfad des Home-Verzeichnisses.
- `.` und `..` besitzen definierte Verzeichnissemantik, müssen aber nicht als physisch gespeicherte, reguläre Verzeichniseinträge vorliegen.
- Bezeichnungen wie „Pseudodirektoren“ oder „implizite Links“ sind für Einsteiger eher missverständlich und sollten entfallen.

### Formulierungsvorschlag

> Beginnt ein Pfad nach der Auswertung durch die Shell mit `/`, ist er absolut. Die Tilde `~` ist eine Shell-Syntax, die beispielsweise zum Home-Verzeichnis des aktuellen Benutzers expandiert wird.

## History

### Korrekturen und Präzisierungen

- Nicht jedes eingegebene Kommando wird zwingend in die History aufgenommen. Das Verhalten hängt unter anderem von `HISTCONTROL`, `HISTIGNORE` und der Shellkonfiguration ab.
- Bash kann History-Einträge nicht nur beim Beenden, sondern beispielsweise mit `history -a` bereits während einer Sitzung speichern.
- Bei gleichzeitig laufenden Shells hängt das Zusammenführen der Einträge von der Konfiguration ab.
- `!$` steht für das letzte Wort des vorherigen History-Eintrags. Dieses ist häufig, aber nicht zwingend, ein Argument im semantischen Sinn.
- Für die Vorwärtssuche ist in Bash/Readline standardmäßig `Ctrl+S` vorgesehen. Die Tastenkombination kann allerdings durch die Terminalflusssteuerung belegt sein. `Shift+Ctrl+R` ist normalerweise nicht die Gegenrichtung zu `Ctrl+R`.

## Pattern Matching / Globbing / Wildcards

### Korrekturen

- `*` passt innerhalb einer Pfadkomponente auf beliebig viele Zeichen, aber nicht auf `/`. Am Anfang einer Pfadkomponente erfasst es standardmäßig keine Namen, die mit `.` beginnen.
- `[!pattern]` negiert kein vollständiges Muster. Eine solche Klammerexpression passt auf genau ein Zeichen, das nicht zur angegebenen Zeichenmenge gehört.
- Globbingzeichen innerhalb einer Klammerexpression besitzen nicht automatisch ihre sonstige Bedeutung. Beispielsweise ist `*` dort normalerweise ein wörtliches Sternchen.
- `!(pattern)` gehört zum Extended Globbing von Bash. Diese Syntax setzt `shopt -s extglob` voraus und ist nicht portable POSIX-Shell-Syntax.
- Findet Bash keine Übereinstimmung, bleibt das Muster standardmäßig unverändert. Die Optionen `nullglob` und `failglob` verändern dieses Verhalten.
- Die gezeigten `mv`-Muster erfassen standardmäßig keine versteckten Dateien.

### Formulierungsvorschlag

```bash
# Ein Zeichen, das weder o noch p ist, gefolgt von beliebigen Zeichen:
ls [!op]*

# Extended Globbing aktivieren und Namen ausschließen, die mit o beginnen:
shopt -s extglob
printf '%s\n' !(o*)
```

Bei destruktiven Kommandos sollte ein Muster zuerst mit `printf '%s\n' MUSTER` oder `ls -- MUSTER` kontrolliert werden.

## Brace Expansion

### Bewertung

Der Abschnitt ist inhaltlich weitgehend korrekt.

### Ergänzungen

- Ein alleinstehendes `{}` löst keine Brace Expansion aus. Benötigt wird beispielsweise `{a,b}` oder `{1..5}`.
- Brace Expansion ist eine Shell-Erweiterung, etwa von Bash, und keine portable POSIX-`sh`-Syntax.

## Escaping / Quoting / Maskieren

### Korrekturen

- Nicht nur Leerzeichen können Wörter trennen. Auch Tabulatoren und Zeilenumbrüche gehören zum Shell-Whitespace.
- `#` beginnt nur an syntaktisch passenden Positionen einen Kommentar, nicht mitten in einem Wort.
- `;` beendet nicht einfach eine Eingabe, sondern trennt Kommandos.
- Einfache und doppelte Anführungszeichen sind Quoting-Mechanismen. Ein Backslash maskiert dagegen ein einzelnes folgendes Zeichen.
- Der Backtick fehlt als Sonderzeichen für die veraltete Form der Kommandosubstitution.
- `!` ist innerhalb doppelter Anführungszeichen nur bei aktiver History Expansion besonders. Das betrifft typischerweise interaktive Bash-Shells.

### Formulierungsvorschlag

> Einfache Anführungszeichen erhalten jedes eingeschlossene Zeichen wörtlich. Doppelte Anführungszeichen verhindern unter anderem Wortaufteilung und Globbing, lassen aber Parameter-, Kommando- und arithmetische Expansion zu. Ein Backslash schützt außerhalb von Anführungszeichen das unmittelbar folgende Zeichen.

## Aliase

### Präzisierungen

- `~/.bash_aliases` ist keine von Bash fest vorgegebene Startdatei. Sie ist insbesondere auf Debian- und Ubuntu-Systemen üblich und wirkt nur, wenn eine tatsächlich gelesene Startdatei sie einbindet.
- `~/.bashrc` wird normalerweise von interaktiven Nicht-Login-Shells gelesen. Für Login-Shells gelten weitere Startdateiregeln.
- Aliase führen Textersetzung durch und besitzen keine echten Parameter. Für komplexere Abläufe oder Argumentverarbeitung sollten Shellfunktionen verwendet werden.
- Das Starten von `bash` erzeugt eine neue Shell. Nach `exit` gelten wieder die Einstellungen der ursprünglichen Shell.

## Variablen

### Grundlegende Korrekturen

Dieser Abschnitt vermischt Umgebungsvariablen, Kindprozesse, neu gestartete Shells und Bash-Subshell-Umgebungen. Er sollte grundlegend überarbeitet werden.

- Umgebungsvariablen sind nicht „systemweit gültig“. Jeder Prozess besitzt eine eigene Umgebung.
- Beim Start eines Kindprozesses wird die Umgebung als Kopie übergeben. Änderungen des Kindes wirken nicht auf die Umgebung des Elternprozesses zurück.
- `export` markiert eine Shellvariable für die Weitergabe an Kindprozesse, nicht nur an „Subshells“.
- `SHELL` enthält üblicherweise die konfigurierte Login-Shell und muss nicht die momentan laufende Shell bezeichnen.
- `/usr/bin/rm` ist ein externes Programm und kein eingebautes Kommando.
- Die Beispiele `echo $PATH=...` sind syntaktisch irreführend. Zur Anzeige sollte `printf '%s\n' "$PATH"` oder `echo "$PATH"` verwendet werden.

### Korrektur der arithmetischen Operation

Folgendes Beispiel ist ungültig:

```bash
let summe = $zahl1 + $zahl2
```

Korrekte Varianten sind:

```bash
let "summe = zahl1 + zahl2"
summe=$((zahl1 + zahl2))
```

Die zweite Form ist klarer und sollte bevorzugt werden.

### Subshells und Kindprozesse

- Eine durch `( … )` erzeugte Bash-Subshell sieht den Shellzustand der Elternshell, darunter auch nicht exportierte Variablen und Funktionen. Änderungen wirken anschließend nicht zurück.
- Eine separat gestartete `bash` übernimmt grundsätzlich nur exportierte Umgebungsvariablen. Shellvariablen, Aliase und nicht exportierte Funktionen werden nicht auf dieselbe Weise übernommen.
- Shellfunktionen laufen normalerweise in der aktuellen Shell.
- Externe Programme werden als Kindprozesse gestartet.
- Ein ausgeführtes Shellskript läuft normalerweise in einem neuen Interpreterprozess. Ein mit `source` beziehungsweise `.` geladenes Skript läuft in der aktuellen Shell.
- Bash führt die Elemente einer Pipeline üblicherweise in Subshell-Umgebungen aus. Die Option `lastpipe` kann das Verhalten des letzten Pipelineelements ändern.
- Ein Benutzerwechsel mit `su` oder `sudo` ist nicht treffend als „Subshell mit den Berechtigungen des anderen Benutzers“ beschrieben.
- `BASH_SUBSHELL` zählt Bash-Subshell-Umgebungen. Eine separat gestartete Bash beginnt wieder mit dem Wert `0`.

### Empfohlener Ersatztext

> Shellvariablen gehören zur aktuellen Shell. Mit `export` werden sie zusätzlich Teil der Umgebung, die an neu gestartete Kindprozesse weitergegeben wird. Ein Kindprozess erhält dabei eine Kopie; spätere Änderungen wirken nicht auf die Elternshell zurück. Bash-Subshell-Umgebungen wie `( … )` übernehmen den aktuellen Shellzustand, isolieren aber darin vorgenommene Änderungen.

## Textströme und Standardkanäle

### Bewertung

Der Abschnitt ist fachlich weitgehend korrekt.

### Präzisierung

> Ein Prozess erbt beim Start offene Filedeskriptoren von seinem Elternprozess. Vor dem Start eines Programms richtet die Shell die Standardkanäle und angegebene Umleitungen ein.

## UNIX Philosophie

### Bewertung

Die Darstellung ist als didaktische Zusammenfassung korrekt. Das kurze Zitat „Write programs that do one thing and do it well“ bildet allerdings nur einen Teil der zuvor genannten Prinzipien ab.

## KISS Prinzip

### Bewertung

Der Abschnitt ist verwendbar. „Keep it simple, stupid“ ist die verbreitetste Form; die anderen Formulierungen sind Varianten.

## Redirects

### Grundlegende Ergänzung

Redirects betreffen nicht nur `stdout`, `stderr` und Dateien. Sie können auch `stdin`, andere Filedeskriptoren und Verbindungen zwischen Filedeskriptoren einrichten.

### Korrekturen

- `&>` ist eine Bash-Erweiterung und keine portable POSIX-Syntax.
- Bei `> datei 2>> datei` starten nicht einfach beide Schreibpositionen bei Position 0. Der zweite Filedeskriptor wird im Append-Modus geöffnet. Da zwei getrennte offene Dateibeschreibungen verwendet werden, können Schreibpositionen und Pufferung trotzdem zu Überschreibungen oder unerwarteter Reihenfolge führen.
- Bei `> datei 2>&1` koordiniert die Shell nicht die späteren Schreibvorgänge. Filedeskriptor 2 wird zu einer Kopie von Filedeskriptor 1. Beide verweisen dadurch auf dieselbe offene Dateibeschreibung und teilen den Dateioffset.
- Aussagen darüber, welcher Kanal zuerst erscheint und welcher Kanal gepuffert ist, dürfen nicht verallgemeinert werden. Das hängt vom Programm, der Bibliothek und dem Zieltyp ab.
- `sed` verändert eine Datei ohne zusätzliche Option ebenfalls nicht direkt. Dafür sind beispielsweise `sed -i` oder eine temporäre Datei erforderlich.
- `< /dev/null` verhindert interaktive Eingabeaufforderungen nicht sicher. Ein Programm kann direkt von `/dev/tty` lesen.
- Der Markdown-Codeblock bei der Kurzform `&>` wird mit zwei statt drei Backticks geschlossen.

### Empfohlener Ersatz für die Race-Condition-Erklärung

> `> datei 2>> datei` öffnet dieselbe Datei zweimal und erzeugt zwei voneinander unabhängige offene Dateibeschreibungen. `stdout` schreibt mit einem eigenen Dateioffset, während `stderr` im Append-Modus schreibt. Dadurch sind Reihenfolge und Position der Ausgaben nicht zuverlässig. Bei `> datei 2>&1` werden dagegen beide Filedeskriptoren an dieselbe offene Dateibeschreibung gebunden und teilen den Dateioffset.

## Kommandopipelines

### Korrekturen und Präzisierungen

- Die Länge einer Pipeline wird nicht ausschließlich durch Hardware begrenzt. Betriebssystem-, Prozess-, Filedeskriptor- und weitere Ressourcenlimits spielen ebenfalls eine Rolle.
- `grep "sh$" /etc/passwd` ermittelt nicht zuverlässig „reale Benutzer“. Systemkonten können eine solche Shell besitzen; normale Benutzer können andere Shells oder keine interaktive Shell verwenden.

### Formulierungsvorschlag zum Beispiel

> Das folgende Beispiel zeigt Konten, deren Shell-Feld auf `sh` endet. Daraus lässt sich nicht zuverlässig ableiten, ob es sich um menschliche beziehungsweise reguläre Benutzer handelt.

Je nach Lernziel könnten UID-Bereiche, `getent passwd` oder eine explizite Liste erlaubter Login-Shells behandelt werden.

## Prozesse

### Grundlegende Korrekturen

- Ein Programm erzeugt erst bei seiner Ausführung einen oder mehrere Prozesse.
- Prozesse besitzen getrennte virtuelle Adressräume, können aber Ressourcen teilen und über verschiedene IPC-Mechanismen kommunizieren.
- Prozesse kennen nicht ausschließlich ihre PPID. Je nach Berechtigungen können sie Informationen über andere Prozesse ermitteln und ihnen Signale senden.
- Im Vordergrund eines Terminals kann eine Prozessgruppe beziehungsweise eine vollständige Pipeline laufen, nicht nur ein einzelner Prozess.
- `Ctrl+Z` sendet üblicherweise `SIGTSTP` an den Vordergrundjob. Der Job wird angehalten; erst `bg` setzt ihn im Hintergrund fort.
- `jobs` zeigt auch angehaltene Jobs und nicht lediglich laufende Hintergrundprozesse.
- `ps` ohne Optionen zeigt nur eine voreingestellte Prozessauswahl.
- `ps -aux` mischt unterschiedliche Optionsstile und ist mehrdeutig. Empfohlen werden `ps aux` oder `ps -ef`.

### Signale

- `SIGINT` ist nicht stärker oder „deutlicher“ als `SIGTERM`. Beide Signale können von einem Prozess abgefangen oder ignoriert werden.
- `SIGKILL` wird wie andere Signale vom Kernel zugestellt. Der Prozess wird zwangsweise beendet und seine Ressourcen werden bereinigt. Bis der Elternprozess den Exitstatus abholt, kann ein Zombie-Prozess verbleiben.
- `SIGSTOP` und `SIGTSTP` halten Prozesse an, verschieben sie aber nicht selbst in den Hintergrund.
- `SIGSTOP` und `SIGKILL` können nicht abgefangen, blockiert oder ignoriert werden.
- Signalnummern können von der Architektur abhängen. In Beispielen sollten vorzugsweise Signalnamen verwendet werden.

### Shellende und `SIGHUP`

- Beim Schließen einer Shell erhalten nicht pauschal alle Kindprozesse ein `SIGHUP`. Das Verhalten hängt unter anderem von Job Control, Shell, Session und kontrollierendem Terminal ab.
- `nohup` leitet `stdout` nur dann automatisch nach `nohup.out` um, wenn `stdout` ein Terminal ist. Ist `stderr` ein Terminal, wird es auf `stdout` umgeleitet.
- `disown` entfernt einen Job aus der Jobtabelle beziehungsweise verhindert je nach Option die Weitergabe des Shell-`SIGHUP`. Es trennt einen Prozess nicht vollständig von allen Terminalressourcen.

### Terminal-Multiplexer

`screen`, `tmux` und Zellij halten Sessions nach einem Detach am Leben. Sie speichern oder restaurieren Sessions jedoch normalerweise nicht automatisch über einen Neustart des Multiplexer-Servers oder Systems hinweg.

## Archivierung und Komprimierung

### Archivierung mit `tar`

- Ein Archiv kann auch nur eine oder sogar keine Nutzdatei enthalten. „Mehrere Dateien“ ist daher kein Definitionsmerkmal.
- Die Option `-f` ist für normale Archivdateien wichtig, aber nicht technisch immer erforderlich. Ohne `-f` verwendet GNU tar die Variable `TAPE` oder ein einkompiliertes Standardziel.
- Die Aussage, der Archivname müsse „direkt hinter der Option“ stehen, sollte sich ausdrücklich auf die gezeigten gebündelten Kurzoptionen beziehen. `tar -f archiv.tar -t` ist ebenfalls möglich.
- `-P` bewahrt führende Slashes beim Erstellen eines Archivs. Damit beim Entpacken tatsächlich absolute Zielpfade verwendet werden, muss dieses Verhalten auch beim Extrahieren erlaubt werden. Der gezeigte Erstellungsbefehl allein überschreibt später nicht automatisch `/etc/hosts`.

### Komprimierung

- Kompressionsalgorithmen verarbeiten Datenströme. Die Beschränkung auf „eine einzelne Datei“ beschreibt eher die Bedienung der Programme `gzip`, `bzip2` und `xz`, nicht das technische Konzept.
- Das Ersetzen der Originaldatei gilt für den direkten Standardaufruf dieser Kompressionsprogramme, nicht für die Kompression eines Archivs durch `tar`.
- Geschwindigkeits- und Größenvergleiche hängen stark von Eingabedaten, Kompressionsstufe, Programmversion und Hardware ab.
- Der gezeigte Test ist nicht repräsentativ: Eine Datei von 1 GiB wird auf wenige hundert Bytes reduziert und enthält daher offenbar extrem redundante Daten.
- Die Aussage, XZ sei bei realen Daten generell am schnellsten beim Dekomprimieren, ist nicht allgemeingültig.
- Ob `zip` vorinstalliert ist, hängt von Distribution und Installation ab.

### Formulierungsvorschlag zum Vergleich

> In diesem konkreten Test komprimiert Gzip am schnellsten, während Bzip2 die kleinste Datei und XZ die schnellste Dekomprimierung erreicht. Diese Ergebnisse lassen sich wegen der stark redundanten Testdaten nicht verallgemeinern. Bei anderen Daten, Kompressionsstufen und Systemen können sowohl Reihenfolge als auch Abstände anders ausfallen.

## Benutzerkonten

### Root-Konto

- UID 0 besitzt traditionell besondere Rechte. Diese können unter anderem durch Linux-Capabilities, Namespaces, Mandatory Access Control und Containergrenzen eingeschränkt werden.
- Der Kernel erkennt besondere Privilegien technisch anhand der UID 0 und nicht anhand des Namens `root`.
- Die Aussage, `root` dürfe ausnahmslos alles, ist deshalb zu absolut.

### Reguläre Benutzer

- Reguläre Benutzer dürfen grundsätzlich Programme starten, sofern die Ausführungsrechte und weitere Zugriffsbedingungen dies erlauben. Nicht das Kommando selbst, sondern die ausgeführte Operation kann an fehlenden Berechtigungen scheitern.
- Durch Mechanismen wie `sudo` können reguläre Benutzer gezielt administrative Befugnisse erhalten.

### Systembenutzer

- Systembenutzer besitzen ebenfalls ein Shell-Feld in `/etc/passwd`. Häufig ist dort `/usr/sbin/nologin` oder `/bin/false` eingetragen; einige Dienstkonten können jedoch eine reguläre Shell besitzen.
- Ein kompromittierter Dienst unter `www-data` kann auf alle Dateien und Ressourcen zugreifen, für die dieses Konto Berechtigungen besitzt. Er ist lediglich nicht automatisch vollständig privilegiert.
- `www-data` ist insbesondere auf Debian-basierten Systemen üblich; andere Distributionen können andere Kontonamen verwenden.

## Benutzer und Gruppen

### `useradd` und Home-Verzeichnisse

- Ob `useradd` ohne `-m` ein Home-Verzeichnis erstellt, hängt von der Einstellung `CREATE_HOME` und den Distributionseinstellungen ab.
- `-m` erzwingt die Erstellung, während `-M` sie verhindert.
- Das Ziel muss nicht `/home/<benutzer>` sein. Basis- und Zielverzeichnis können konfiguriert oder mit Optionen geändert werden.

### Passwörter

- Das Passwortfeld in `/etc/shadow` enthält nicht immer einen gesalzenen Hash. Es kann auch Sperrwerte wie `!` oder `*` sowie in Sonderfällen einen leeren Wert enthalten.
- SHA-512-crypt ist nicht pauschal der aktuell für Linux empfohlene Algorithmus. Die Auswahl hängt von Distribution und PAM-/`crypt`-Konfiguration ab; moderne Systeme verwenden häufig Yescrypt.
- Das Beispiel mit `useradd -p $(openssl passwd ...)` sollte entfernt werden. Die `useradd`-Manpage warnt davor, da der Hash über die Prozessliste sichtbar sein kann. Das gezeigte Klartextpasswort kann zusätzlich in der Shell-History und in Prozessargumenten erscheinen.

### Sicherer Formulierungsvorschlag

```bash
useradd -m -c "User mit Passwort" -s /bin/bash userwithpass
passwd userwithpass
```

Bei automatisierter Benutzeranlage sollte ein dafür vorgesehener, gegen Offenlegung geschützter Mechanismus genutzt werden. Passwörter oder Hashes sollten nicht als sichtbare Kommandozeilenargumente übergeben werden.

### `adduser`

- Implementierung, Verfügbarkeit und Standardwerte von `adduser` hängen von der Distribution und Version ab.
- Bash als Login-Shell ist ein konfigurierter Standardwert und keine unveränderliche Eigenschaft von `adduser`.

### Betroffene Dateien und Ressourcen

Die Aussage, Benutzeranlage ändere lediglich vier Textdateien, ist falsch. Je nach System und Optionen können zusätzlich betroffen sein:

- das Home-Verzeichnis und Dateien aus `/etc/skel`,
- ein Mailspool,
- `/etc/subuid` und `/etc/subgid`,
- SELinux-Zuordnungen,
- distributionsspezifische Hooks oder Skripte,
- externe Identitätsquellen und Verwaltungsmechanismen.

Die primäre Gruppe wird über die GID im Eintrag von `/etc/passwd` zugeordnet. Nur wenn eine neue benutzerspezifische Gruppe erstellt wird, entsteht dafür ein neuer Eintrag in `/etc/group` und gewöhnlich `/etc/gshadow`.

### Struktureller Fehler

Die Überschrift `### Benutzerkonfiguration ändern` ist doppelt vorhanden und sollte einmal entfernt werden.

## Priorisierung der Überarbeitung

Die folgenden Themen sollten zuerst korrigiert werden, da sie entweder zu falschem Systemverständnis oder zu unsicheren Arbeitsweisen führen können:

1. Variablen, Umgebungsvariablen und Subshells
2. Passwortvergabe mit `useradd -p`
3. Globbing und Extended Globbing
4. Redirects und Filedeskriptoren
5. Prozesse, Job Control und Signale
6. Absolute Pfade in `tar`-Archiven
7. Verallgemeinerungen bei Kompressionsbenchmarks

## Referenzen

- [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/coreutils.html)
- [GNU tar Manual](https://www.gnu.org/software/tar/manual/tar.html)
- [Linux manual page signal(7)](https://man7.org/linux/man-pages/man7/signal.7.html)
- Lokale Manpages: `man bash`, `man useradd`, `man nohup`, `man tar`, `man ps`
