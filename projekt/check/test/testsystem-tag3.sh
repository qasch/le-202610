#!/usr/bin/env bash
#
# testsystem-tag3.sh – baut ein nachgebautes Wurzelverzeichnis zum Testen von
# check-tag3.sh ohne echten Server. Grundlage ist das korrekt eingerichtete
# System von Tag 2 (testsystem-tag2.sh). Läuft wie dieses unter fakeroot:
#
#   fakeroot -s zustand -- bash testsystem-tag3.sh <zielverzeichnis> <0|1>
#     0 = korrekt eingerichtetes System (erwartet: alle Prüfungen grün)
#     1 = System mit typischen Fehlern (Steckbrief ohne SGID-Gruppe und mit >
#         statt >>, Sicherungsordner offen, falscher Ordner gesichert,
#         Angebot von root neu angelegt, Skript ohne Shebang und für die
#         Gruppe beschreibbar)
#
# Danach, mit demselben Zustand:
#   fakeroot -i zustand -- env CHECK_ROOT=<zielverzeichnis> CHECK_HOSTNAME=pinguin-team1 bash ../check-tag3.sh

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

bash "$(dirname "$0")/testsystem-tag2.sh" "$r" 0 || exit 1

uid() { awk -F: -v n="$1" '$1 == n { print $3 }' "$r/etc/passwd"; }
gid() { awk -F: -v n="$1" '$1 == n { print $3 }' "$r/etc/group"; }

# --- T3-01: Steckbrief ------------------------------------------------------
steckbrief="$r/srv/firma/geschaeftsfuehrung/server-steckbrief.txt"
cat >"$steckbrief" <<'EOF'
Steckbrief des Servers pinguin-team1, erstellt am 08.10.2026 10:15

== Distribution ==
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"

== Arbeitsspeicher ==
               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       312Mi       1.4Gi       1.0Mi       312Mi       1.6Gi
Swap:          975Mi          0B       975Mi

== Netzwerk ==
default via 192.168.56.1 dev enp0s3
nameserver 192.168.56.1
EOF
chown "0:$(gid geschaeftsfuehrung)" "$steckbrief"
chmod 644 "$steckbrief"
if [[ $kaputt == 1 ]]; then
	# Mit > statt >> überschrieben, und ohne SGID-Gruppe abgelegt
	echo "nameserver 192.168.56.1" >"$steckbrief"
	chown 0:0 "$steckbrief"
fi

# --- T3-04: Datensicherung --------------------------------------------------
mkdir -p "$r/srv/backup"
chown 0:0 "$r/srv/backup"
if [[ $kaputt == 1 ]]; then
	chmod 755 "$r/srv/backup"
	tar -czf "$r/srv/backup/firma-2026-10-08.tar.gz" -C "$r" srv/firma/entwicklung
	# Angebot gelöscht und von root neu angelegt statt aus der Sicherung geholt
	rm "$r/srv/firma/vertrieb/angebot-1.txt"
	echo "Angebot für Kunde Eisbär AG" >"$r/srv/firma/vertrieb/angebot-1.txt"
	chown 0:0 "$r/srv/firma/vertrieb/angebot-1.txt"
else
	chmod 700 "$r/srv/backup"
	tar -czf "$r/srv/backup/firma-2026-10-08.tar.gz" -C "$r" srv/firma
	tar -czf "$r/srv/backup/firma-2026-10-08_1430.tar.gz" -C "$r" srv/firma
fi

# --- T3-05: Skript ------------------------------------------------------------
mkdir -p "$r/usr/local/sbin"
skript="$r/usr/local/sbin/firma-backup"
cat >"$skript" <<'EOF'
#!/bin/bash
# firma-backup – sichert die Firmenordner nach /srv/backup

QUELLE=/srv/firma
ZIEL=/srv/backup
DATEI="$ZIEL/firma-$(date +%F_%H%M).tar.gz"

tar -czf "$DATEI" "$QUELLE"
ls -lh "$DATEI"
EOF
if [[ $kaputt == 1 ]]; then
	sed -i '1d' "$skript"
	chown "$(uid ademir):$(gid ademir)" "$skript"
	chmod 775 "$skript"
else
	chown 0:0 "$skript"
	chmod 755 "$skript"
fi
