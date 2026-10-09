# Die Pinguin GmbH

Die Pinguin GmbH ist ein kleines Softwarehaus mit Sitz am Südpol. Bisher lief alles über einen alten Windows-Rechner unter dem Schreibtisch der Geschäftsführung. Damit ist jetzt Schluss: Die Firma bekommt einen Linux-Server, und ihr seid die IT-Abteilung, die ihn einrichtet.

## Abteilungen

| Abteilung | Gruppe | Aufgabe |
|---|---|---|
| Geschäftsführung | `geschaeftsfuehrung` | leitet die Firma, möchte überall den Überblick haben |
| Vertrieb | `vertrieb` | verkauft die Software, schreibt Angebote |
| Entwicklung | `entwicklung` | entwickelt die Software |
| Buchhaltung | `buchhaltung` | Rechnungen, Gehälter, vertrauliche Zahlen |

Zusätzlich gehören **alle** Mitarbeitenden der Gruppe `mitarbeitende` an.

## Mitarbeitende

| Name | Benutzername | Abteilung |
|---|---|---|
| Grete Frost | `gfrost` | Geschäftsführung |
| Lena Wagner | `lwagner` | Vertrieb |
| Murat Kaya | `mkaya` | Vertrieb |
| Sofia Romano | `sromano` | Vertrieb |
| Jonas Becker | `jbecker` | Entwicklung |
| Aylin Demir | `ademir` | Entwicklung |
| Tim Hoffmann | `thoffmann` | Entwicklung |
| Nina Schulz | `nschulz` | Entwicklung |
| Peter Krause | `pkrause` | Buchhaltung |
| Eva Lindner | `elindner` | Buchhaltung |
| Oskar Weber | `oweber` | Buchhaltung |

Die Liste gibt es auch als Datei: [`daten/mitarbeitende.csv`](./daten/mitarbeitende.csv).

**Regel für Benutzernamen:** erster Buchstabe des Vornamens + Nachname, alles klein, ohne Umlaute.

## Richtlinien der IT

- Jede Person hat ein **eigenes** Konto. Konten werden nicht geteilt.
- Neue Konten erhalten das Startpasswort `Pinguin-Start-2026` und müssen es **bei der ersten Anmeldung ändern**.
- Als Login-Shell wird die `bash` verwendet.
- Im Kommentarfeld steht der vollständige Name der Person.
- Administrative Aufgaben werden mit `sudo` erledigt, nicht in einer dauerhaft offenen Root-Shell.
- Konten von Personen, die die Firma verlassen, werden **nicht** einfach gelöscht. Ihre Daten könnten noch gebraucht werden.
