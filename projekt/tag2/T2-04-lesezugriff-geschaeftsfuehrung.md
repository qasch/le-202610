# T2-04 – Lesezugriff für die Geschäftsführung (Bonus)

> **Bonus-Ticket:** Dieses Ticket ist freiwillig. Wenn die Zeit knapp ist, überspringt es und macht mit T2-05 weiter.

> **Von:** Grete Frost (Geschäftsführung)
> **Betreff:** Zugriff verweigert?!
>
> Hallo IT,
>
> ich wollte mir gerade die Angebote im Vertriebsordner ansehen – und bekomme „Zugriff verweigert“. Ich bin doch die Chefin!
>
> Mein Wunsch: Ich möchte in **allen** Abteilungsordnern **lesen** können. Verändern oder löschen möchte ich dort aber nichts – nicht, dass ich aus Versehen etwas kaputt mache.
>
> Ist das schwierig?
>
> Grete

**Ja, das ist schwierig.** In diesem Ticket gibt es keine perfekte Lösung. Ihr probiert verschiedene Ansätze aus, findet heraus, warum sie nicht ganz passen, und schreibt Grete eine ehrliche Antwort.

Alle Schritte führt ihr **auf dem Server** aus. Jeden Ansatz macht ihr am Ende wieder rückgängig.

## ⭐ Ansatz 1 – Grete in die Abteilungsgruppe

### Schritt 1: Ausgangslage

1. Öffnet eine Shell als `gfrost` und versucht `ls /srv/firma/vertrieb`. Notiert die Meldung. Kehrt mit `exit` zurück.
2. Führt `id gfrost` aus und notiert ihre Gruppen.

### Schritt 2: Grete in den Vertrieb aufnehmen

1. Nehmt Grete in die Gruppe `vertrieb` auf. Achtung: Denkt an Murat Kaya aus T1-05!
2. Prüft mit `id gfrost`: Ist sie in `vertrieb` **und** weiterhin in `geschaeftsfuehrung` und `mitarbeitende`?

### Schritt 3: Testen

Öffnet eine Shell als `gfrost` und testet:

1. `ls -l /srv/firma/vertrieb` – Kann Grete die Dateien sehen?
2. `cat /srv/firma/vertrieb/angebot-2.txt` – Kann sie lesen?
3. `echo "Grete war hier" > /srv/firma/vertrieb/grete.txt` – Kann sie Dateien anlegen?
4. `rm /srv/firma/vertrieb/grete.txt` – Kann sie Dateien löschen?
5. Überlegt **ohne** es auszuprobieren: Könnte Grete auch `angebot-2.txt` löschen? Begründet mit den Rechten des Ordners.

Kehrt mit `exit` zurück.

### Schritt 4: Rückbau

1. Entfernt Grete wieder aus der Gruppe `vertrieb`. Sucht dafür in `man gpasswd` die Option zum Entfernen (*delete*) eines Mitglieds.
2. Prüft mit `id gfrost`, dass sie nur noch in `geschaeftsfuehrung` und `mitarbeitende` ist.

### Schritt 5: Bewertung

Tragt das Ergebnis in diese Tabelle im Logbuch ein. Ihr ergänzt sie in ⭐⭐ und ⭐⭐⭐.

| Ansatz | Grete kann lesen | Grete kann nichts verändern | Andere bleiben draußen | Problem |
|---|---|---|---|---|
| 1: Grete in die Abteilungsgruppe | | | | |
| 2: Rechte für `others` öffnen | | | | |
| 3: Grete als Besitzerin | | | | |

### Abnahmekriterien

- Grete ist wieder **nur** in den Gruppen `geschaeftsfuehrung` und `mitarbeitende`.
- Die Zeile zu Ansatz 1 ist im Logbuch ausgefüllt.

## ⭐⭐ Erweiterung: Ansatz 2 – Rechte für `others` öffnen

Probiert diesen Ansatz am Ordner der **Entwicklung** aus.

1. Gebt `others` am Ordner `/srv/firma/entwicklung` die Rechte `r-x`. Welche Oktalzahl hat der Ordner danach (mit SGID-Bit)?
2. Legt als `jbecker` eine Datei `/srv/firma/entwicklung/roadmap.txt` an.
3. Testet als `gfrost`: Kann Grete den Ordner auflisten, die Roadmap lesen und eine eigene Datei anlegen?
4. Testet dasselbe als `lwagner`. Was fällt auf?
5. Überlegt: Wer gehört noch alles zu `others`? Denkt an das Dienstkonto aus T1-05 und an zukünftige Konten.
6. Rückbau: Setzt den Ordner wieder auf `2770`. Prüft mit `ls -ld`.
7. Ergänzt die Zeile zu Ansatz 2 in der Tabelle.

## ⭐⭐⭐ Profi: Ansatz 3 – Grete als Besitzerin

Ein Trick mit klassischen Rechten: Der Ordner gehört nicht mehr `root`, sondern **Grete**, und die Besitzerrechte sind auf **lesen und betreten** beschränkt. Probiert es am Ordner des **Vertriebs** aus.

### Schritt 1: Umbauen

1. Macht `gfrost` zur Besitzerin von `/srv/firma/vertrieb`. Die Gruppe bleibt `vertrieb`.
2. Setzt die Rechte so, dass
   - die Besitzerin lesen und betreten darf (`r-x`),
   - die Gruppe alles darf (`rwx`, mit SGID-Bit),
   - alle anderen nichts dürfen (`---`).

   Rechnet die Oktalzahl aus (mit SGID-Bit vorne).
3. Prüft mit `ls -ld /srv/firma/vertrieb`. Erwartet wird `dr-xrws--- … gfrost vertrieb`.

### Schritt 2: Testen

Füllt diese Tabelle im Logbuch aus:

| Person | `ls /srv/firma/vertrieb` | `cat …/angebot-2.txt` | `touch …/test.txt` |
|---|---|---|---|
| `gfrost` | | | |
| `lwagner` | | | |
| `jbecker` | | | |

Löscht die Testdateien wieder.

### Schritt 3: Warum funktioniert das?

1. Grete ist **nicht** in der Gruppe `vertrieb`. Welche Rechte gelten also für sie am Ordner?
2. Gedankenexperiment: Wäre Grete **zusätzlich** Mitglied der Gruppe `vertrieb` – dürfte sie dann schreiben? Lest dazu die Erklärung in Hilfekarte 1 und begründet eure Antwort.
3. Mit welcher Rechteklasse liest Grete die Datei `angebot-2.txt`? Schaut euch die Rechte der Datei an.

### Schritt 4: Die Grenzen

1. Lena legt eine vertrauliche Datei an und schränkt sie ein:

   ```bash
   echo "Provision: 12 %" > /srv/firma/vertrieb/provision.txt
   chmod 640 /srv/firma/vertrieb/provision.txt
   ```

   Kann Grete die Datei lesen? Warum nicht?
2. Grete führt **ohne** `sudo` `chmod u+w /srv/firma/vertrieb` aus. Klappt das? Kann sie danach eine Datei anlegen?
3. Grete macht die Änderung wieder rückgängig (`chmod u-w …`).
4. Notiert im Logbuch: Ist Gretes Wunsch „Ich kann nichts verändern“ damit wirklich erfüllt?
5. Ergänzt die Zeile zu Ansatz 3 in der Tabelle.
6. Entscheidet im Team, ob der Vertriebsordner so bleibt oder ob ihr ihn zurückbaut (`root:vertrieb`, `2770`). Notiert die Entscheidung mit Begründung.

## Für alle: Antwort an Grete

Schreibt im Logbuch eine Antwortmail an Grete (4–6 Sätze). Sie ist keine Technikerin. Erklärt:

- warum ihr Wunsch mit den Mitteln des Servers nicht perfekt umzusetzen ist,
- welche Lösung ihr empfehlt (oder warum ihr bewusst keine einrichtet),
- und wie sie bis dahin an die Dateien kommt, die sie braucht.

---

## Hilfekarten

<details>
<summary>🟢 Hilfekarte 1 – Wo steht's?</summary>

- Gruppenmitglieder hinzufügen und entfernen: `man usermod` (`-a`, `-G`) und `man gpasswd` (`-d`)
- Besitzer ändern: `man chown`
- **So prüft Linux die Rechte:** Zuerst wird geschaut, ob die Person die **Besitzerin** ist. Wenn ja, gelten **nur** die Besitzerrechte – Schluss. Wenn nein, wird geschaut, ob sie in der **Gruppe** ist. Wenn ja, gelten **nur** die Gruppenrechte. Sonst gelten die Rechte für **andere**. Es wird immer genau **eine** Rechteklasse angewendet, die Rechte werden nicht addiert.
- Rechte der eigenen Dateien und Ordner darf die Besitzerin bzw. der Besitzer immer ändern – auch die eigenen.

</details>

<details>
<summary>🟡 Hilfekarte 2 – Welche Kommandos?</summary>

```text
sudo usermod -aG vertrieb gfrost
sudo gpasswd -d gfrost vertrieb
id gfrost
sudo chmod o+rx /srv/firma/entwicklung
sudo chmod 2770 /srv/firma/entwicklung
sudo chown gfrost /srv/firma/vertrieb
sudo chmod 2570 /srv/firma/vertrieb
sudo -iu <benutzer>
```

</details>

<details>
<summary>🔴 Hilfekarte 3 – Lösung</summary>

```bash
# ⭐ Ansatz 1
sudo usermod -aG vertrieb gfrost
id gfrost
sudo -iu gfrost
ls -l /srv/firma/vertrieb
cat /srv/firma/vertrieb/angebot-2.txt
echo "Grete war hier" > /srv/firma/vertrieb/grete.txt   # klappt
rm /srv/firma/vertrieb/grete.txt                        # klappt
exit
sudo gpasswd -d gfrost vertrieb
id gfrost

# ⭐⭐ Ansatz 2
sudo chmod o+rx /srv/firma/entwicklung        # ergibt 2775
# … testen …
sudo chmod 2770 /srv/firma/entwicklung

# ⭐⭐⭐ Ansatz 3
sudo chown gfrost /srv/firma/vertrieb
sudo chmod 2570 /srv/firma/vertrieb
ls -ld /srv/firma/vertrieb                     # dr-xrws--- gfrost vertrieb
```

| Ansatz | lesen | nichts verändern | andere draußen | Problem |
|---|---|---|---|---|
| 1: Abteilungsgruppe | ✔ | ✘ | ✔ | Grete hat dieselben Rechte wie die Abteilung, sie kann auch fremde Dateien löschen. |
| 2: `others` öffnen | ✔ | ✔ | ✘ | **Alle** Konten auf dem Server können lesen, auch andere Abteilungen und Dienstkonten. |
| 3: Grete als Besitzerin | ✔ (meist) | ✘ (nur scheinbar) | ✔ | Grete kann sich als Besitzerin jederzeit selbst Schreibrecht geben. Dateien ohne Leserecht für `others` bleiben für sie unlesbar. |

**⭐ Schritt 3:** Grete darf als Gruppenmitglied in einem Ordner mit `rwx` für die Gruppe beliebige Dateien anlegen und löschen – also auch `angebot-2.txt`. Wer `usermod -G` ohne `-a` verwendet hat, hat Grete aus `geschaeftsfuehrung` und `mitarbeitende` entfernt (wie Murat in T1-05).

**⭐⭐:** `2770` + `o+rx` = `2775`. Grete kann lesen, aber nicht schreiben – genau wie gewünscht. Lena kann das aber auch, und jedes neue Konto ebenfalls.

**⭐⭐⭐ Schritt 2:**

| Person | `ls` | `cat` | `touch` |
|---|---|---|---|
| `gfrost` | ✔ | ✔ | ✘ |
| `lwagner` | ✔ | ✔ | ✔ |
| `jbecker` | ✘ | ✘ | ✘ |

**⭐⭐⭐ Schritt 3:** Grete ist Besitzerin, also gelten für sie **nur** die Besitzerrechte `r-x` – auch dann, wenn sie zusätzlich in der Gruppe wäre, deren Rechte `rwx` sind. Die Datei `angebot-2.txt` (`rw-rw-r--`) gehört dagegen Lena und der Gruppe `vertrieb`. Grete ist weder Besitzerin noch in der Gruppe – sie liest also als `others` (`r--`). Alle anderen Personen kommen über den Ordner (`---` für `others`) gar nicht erst an die Datei heran.

**⭐⭐⭐ Schritt 4:** `provision.txt` hat `rw-r-----`, für `others` bleibt nichts – Grete kann sie nicht lesen. Und weil Grete Besitzerin des Ordners ist, darf sie dessen Rechte jederzeit ändern. Der Schutz vor „aus Versehen etwas kaputt machen“ funktioniert also nur, solange sie nicht bewusst `chmod` ausführt.

**Fazit:** Mit den klassischen Rechten hat jede Datei und jedes Verzeichnis genau **eine** Besitzerin oder einen Besitzer und genau **eine** Gruppe. „Die Abteilung schreibt, die Geschäftsführung liest“ braucht aber zwei Gruppen mit unterschiedlichen Rechten. Das lässt sich nur mit **Access Control Lists** (ACLs, Kommandos `setfacl` und `getfacl`) sauber lösen. Sie gehören nicht zum Stoff von Linux Essentials. Eine ehrliche Antwort an Grete könnte deshalb lauten: „Wir richten das sauber ein, sobald wir ACLs kennen. Bis dahin legen euch die Abteilungen wichtige Berichte in den Austauschordner.“

</details>
