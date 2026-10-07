# Überarbeitete Übungen zu Kommandos und Manpages

## Hilfe auf der Kommandozeile

### Übung 1

Macht euch mit Manpages vertraut. Werft dazu einen Blick in die Manpage von `man`. Es genügt, die Abschnitte **NAME**, **SYNOPSIS**, **DESCRIPTION** und **EXAMPLES** (bzw. in der deutschen Version **NAME**, **SYNTAX**, **BESCHREIBUNG** und **BEISPIELE**) zu lesen.

### Übung 2 – Das Kommando `ls`

Findet mit Hilfe der Manpage heraus:

- Was bewirkt die jeweilige Option?
- Wann ist sie sinnvoll?
- Probiert sie an mindestens einem Beispiel aus.

#### Anzeige

```
-a
-l
-i
-p
```

#### Sortierung

```
-t
-S
-X
```

#### Verzeichnisse und Rekursion

```
-d
-R
```

#### Reihenfolge

```
-r
```

Probiert die Optionen auch praktisch aus. Dafür eignet sich beispielsweise ein Verzeichnis mit vielen Einträgen:

```bash
ls /etc
```

> **Hinweis**
>
> Manche Optionen entfalten ihre Wirkung erst in Kombination mit anderen. Vergleicht beispielsweise:
>
> ```bash
> ls -l
> ls -ld
> ```
>
> Experimentiert außerdem mit verschiedenen Kombinationen mehrerer Optionen.

#### Untersucht folgende Befehle

Erklärt, welche Wirkung die einzelnen Optionen haben:

```bash
ls -lisahF
ls -la
ls -lh
ls -ltr
ls -alR
```

#### Transferaufgabe

Beantwortet folgende Fragen:

1. Spielt die Reihenfolge der Optionen eine Rolle?
   Vergleicht beispielsweise:
   ```bash
   ls -la
   ls -al
   ```

2. Findet einen `ls`-Befehl, der
   - alle Dateien (auch versteckte),
   - in Langform,
   - mit menschenlesbaren Dateigrößen,
   - nach Änderungszeit sortiert,
   - die neuesten Dateien zuerst

   ausgibt.

### Übung 3 (Zusatz)

Mit dem Kommando `date` kann man sich das aktuelle Datum und die aktuelle Uhrzeit ausgeben lassen. `date` kann aber noch mehr.

1. Angenommen, heute ist der **15.05.2026**, **13:34:56 Uhr**. Studiert die Dokumentation von `date` und gebt die Formatierungsanweisungen an, mit denen folgende Ausgaben erzeugt werden können:

   1. `15.05.2026`
   2. `13:34 Uhr`

2. Wie spät ist es gerade in Los Angeles? Versucht die Lösung zunächst in den Manpages zu finden und recherchiert andernfalls im Internet.
