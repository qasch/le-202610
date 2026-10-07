#!/usr/bin/env bash
#
# testsystem-tag2.sh – baut ein nachgebautes Wurzelverzeichnis (etc/, home/,
# srv/) zum Testen von check-tag2.sh ohne echten Server. Grundlage ist das
# korrekt eingerichtete System von Tag 1 (testsystem-tag1.sh).
#
# Besitzer und Gruppen lassen sich ohne Root-Rechte nicht setzen. Deshalb
# läuft das Skript unter fakeroot, das den Zustand in einer Datei speichert:
#
#   fakeroot -s zustand -- bash testsystem-tag2.sh <zielverzeichnis> <0|1>
#     0 = korrekt eingerichtetes System (erwartet: alle Prüfungen grün)
#     1 = System mit typischen Fehlern (Heimatverzeichnis offen, SGID- und
#         Sticky Bit fehlen, falsche Gruppe nach mv, Grete noch im Vertrieb,
#         Link von root angelegt, Versuchslink übrig, Archiv unvollständig,
#         herrenlose Dateien)
#
# Danach, mit demselben Zustand:
#   fakeroot -i zustand -- env CHECK_ROOT=<zielverzeichnis> bash ../check-tag2.sh
#
# Gelegentlich meldet fakeroot "libfakeroot internal error: payload not
# recognized!". Das ist ein Problem von fakeroot und ändert nichts am Ergebnis.

r="$1"
kaputt="$2"

if [[ -z "$r" || -z "$kaputt" ]]; then
	echo "Aufruf: fakeroot -s zustand -- bash $0 <zielverzeichnis> <0|1>" >&2
	exit 1
fi

if [[ $EUID -ne 0 ]]; then
	echo "Bitte unter fakeroot ausführen: fakeroot -s zustand -- bash $0 $*" >&2
	exit 1
fi

bash "$(dirname "$0")/testsystem-tag1.sh" "$r" 0 || exit 1

uid() { awk -F: -v n="$1" '$1 == n { print $3 }' "$r/etc/passwd"; }
gid() { awk -F: -v n="$1" '$1 == n { print $3 }' "$r/etc/group"; }

# datei <pfad> <besitzer> <gruppe> <rechte> <inhalt>
datei() {
	echo "$5" >"$r$1"
	chown "$(uid "$2"):$(gid "$3")" "$r$1"
	chmod "$4" "$r$1"
}

# ordner <pfad> <besitzer> <gruppe> <rechte>
ordner() {
	mkdir -p "$r$1"
	chown "$(uid "$2"):$(gid "$3")" "$r$1"
	chmod "$4" "$r$1"
}

# --- T2-01: Heimatverzeichnisse ---------------------------------------------
for heim in "$r"/home/*; do
	benutzer="${heim##*/}"
	chown -R "$(uid "$benutzer"):$(gid "$benutzer")" "$heim"
	chmod 700 "$heim"
done
[[ $kaputt == 1 ]] && chmod 711 "$r/home/jbecker"

# --- T2-02: Abteilungsordner ------------------------------------------------
ordner /srv root root 755
ordner /srv/firma root root 755
for abteilung in geschaeftsfuehrung vertrieb entwicklung buchhaltung; do
	ordner "/srv/firma/$abteilung" root "$abteilung" 2770
done
datei /srv/firma/vertrieb/angebot-1.txt lwagner vertrieb 664 "Angebot für Kunde Eisbär AG"
datei /srv/firma/vertrieb/angebot-2.txt lwagner vertrieb 664 "Angebot für Kunde Robbe KG"
datei /srv/firma/entwicklung/sprint.txt nschulz entwicklung 664 "Sprint-Planung"
if [[ $kaputt == 1 ]]; then
	# Achtung: "chmod 770" würde das SGID-Bit eines Verzeichnisses behalten
	chmod g-s "$r/srv/firma/buchhaltung"
	chown "$(uid lwagner):$(gid lwagner)" "$r/srv/firma/vertrieb/angebot-1.txt"
	chmod 2775 "$r/srv/firma/entwicklung"
fi

# --- T2-03: Austauschordner -------------------------------------------------
ordner /srv/firma/austausch root mitarbeitende 3770
datei /srv/firma/austausch/speiseplan.txt lwagner mitarbeitende 664 "Montag: Fischstäbchen"
[[ $kaputt == 1 ]] && chmod 2770 "$r/srv/firma/austausch"

# --- T2-04: Grete -----------------------------------------------------------
if [[ $kaputt == 1 ]]; then
	sed -i '/^vertrieb:/ s/$/,gfrost/' "$r/etc/group"
else
	# Ansatz 3 aus T2-04 ist ebenfalls eine gültige Lösung
	chown "$(uid gfrost)" "$r/srv/firma/vertrieb"
	chmod 2570 "$r/srv/firma/vertrieb"
fi

# --- T2-05: Verknüpfungen ---------------------------------------------------
ln -s /srv/firma/entwicklung "$r/home/nschulz/abteilung"
if [[ $kaputt == 1 ]]; then
	ln -s /srv/firma/entwicklung "$r/home/lwagner/spion"
	chown -h "$(uid lwagner):$(gid lwagner)" "$r/home/lwagner/spion"
else
	chown -h "$(uid nschulz):$(gid nschulz)" "$r/home/nschulz/abteilung"
fi

# --- T2-06: Offboarding -----------------------------------------------------
datei /home/oweber/notizen.txt oweber oweber 664 "Passwort fürs Bankportal: steht im Tresor"
ordner /home/oweber/belege oweber oweber 775
datei /home/oweber/belege/beleg-001.txt oweber oweber 664 "Beleg 001: Büromaterial"
datei /srv/firma/buchhaltung/jahresabschluss-2026.txt oweber buchhaltung 664 "Jahresabschluss 2026 – Entwurf"
datei /srv/firma/austausch/abschied.txt oweber mitarbeitende 664 "Danke für alles! Kuchen am Freitag. Oskar"

if [[ $kaputt == 1 ]]; then
	ordner /srv/archiv root root 755
	tar -czf "$r/srv/archiv/oweber-home.tar.gz" -C "$r" home/oweber/belege
else
	ordner /srv/archiv root root 700
	tar -czf "$r/srv/archiv/oweber-home.tar.gz" -C "$r" home/oweber
	chown "$(uid pkrause)" "$r/srv/firma/buchhaltung/jahresabschluss-2026.txt"
	chown "$(uid pkrause)" "$r/srv/firma/austausch/abschied.txt"
fi

# userdel -r oweber: Konto, private Gruppe, Mitgliedschaften, Heimatverzeichnis
sed -i '/^oweber:/d' "$r/etc/passwd" "$r/etc/shadow" "$r/etc/group"
awk -F: -v OFS=: '{
	n = split($4, m, ","); liste = ""
	for (i = 1; i <= n; i++) if (m[i] != "oweber") liste = liste (liste == "" ? "" : ",") m[i]
	$4 = liste; print
}' "$r/etc/group" >"$r/etc/group.neu" && mv "$r/etc/group.neu" "$r/etc/group"
rm -r "$r/home/oweber"
