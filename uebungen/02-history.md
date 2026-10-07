# Übungen zur History

## History

### Übung 1

Macht euch mit den Funktionen der History vertraut, indem ihr euch die Manpage (`man history`) anschaut (hier geht es konkret um den Abschnitt `HISTORY EXPANSION`) und anschließend mit den folgenden Kommandos "herumspielt". Schreibt auf, was man mit den folgenden Kommandos erreichen kann. 

Sucht in der Manpage von `history` am besten nach `HISTROY EXPANSION`

Probiert auch gerne noch andere Möglichkeiten aus.

>[!NOTE]
> `<index>` und `<zeichenfolge>` sind hier im Folgenden als Platzhalter zu verstehen, `<Strg+r>` meint die Tastenkombination von `STRG` und `r`.

```bash
 history 
 history <index>

 !!
 !-<index>
 !<index>
 !<zeichenfolge> 
 !?<zeichenfolge>

 !<index>:p

 !$
```

### Übung 2

 Was passiert, wenn ihr folgende Tastenkombination eingebt:

 ```
 <Strg+r> dann eine <zeichenfolge> gefolgt von <Strg+r> (mehrmals)
 ```

 also z.B.

`<Strg+r>` drücken, dann `man` eingeben und dann (wiederholt) `<Strg+n>` drücken?
 
### Übung 3

In der Shell eingegebene Kommandos werden erst nach dem Schliessen der Shell in die Datei `~/.bash_history` geschrieben. Probiert das einmal aus, indem ihr die Ausgabe des Kommandos `history` mit dem Inhalt der Datei `~/.bash_history` (Ausgabe mit dem Kommando `cat ~/.bash_history`).

Schliesst anschliessend das entsprechende Terminal, öffnet ein neues und führt den Vergleich erneut aus. Ausgabe des Kommandos und Inhalt der Datei sollten nun übereinstimmen.

1. Sucht nun nach einer Möglichkeit, die History aus einer laufenden Shell direkt in die Datei zu schreiben. Allerdings scheint dazu nichts in der Manpage von `history` zu stehen... Versucht es doch mal mit dem Kommando `help history`.

2. Recherchiert anschliessend den Unterschied zwischen *Shell-Builtins* und *externen Kommandos*.

