#!/usr/bin/env bash
#
# check-tag3.sh – Selbstkontrolle für Tag 3 des Projekts "Pinguin GmbH"
#
# Aufruf auf dem Teamserver:
#   sudo bash check-tag3.sh
#
# Das Skript liest nur und verändert nichts am System.
#
# Zum Testen ohne echten Server (siehe check/test/testsystem-tag3.sh):
#   fakeroot -i zustand -- env CHECK_ROOT=./testsystem CHECK_HOSTNAME=pinguin-team1 bash check-tag3.sh

wurzel="${CHECK_ROOT:-}"
etc="$wurzel/etc"
hostname="${CHECK_HOSTNAME:-$(hostname)}"

# Farben nur, wenn die Ausgabe ein Terminal ist
if [[ -t 1 ]]; then
	gruen=$'\e[32m'; rot=$'\e[31m'; gelb=$'\e[33m'; fett=$'\e[1m'; normal=$'\e[0m'
else
	gruen=''; rot=''; gelb=''; fett=''; normal=''
fi

bestanden=0
gesamt=0

ok() {
	bestanden=$((bestanden + 1))
	gesamt=$((gesamt + 1))
	printf '  %s✔%s %s\n' "$gruen" "$normal" "$1"
}

fehler() {
	gesamt=$((gesamt + 1))
	printf '  %s✘%s %s\n' "$rot" "$normal" "$1"
	if [[ -n "$2" ]]; then
		printf '      %s→ %s%s\n' "$gelb" "$2" "$normal"
	fi
}

info() {
	printf '  %sℹ%s %s\n' "$gelb" "$normal" "$1"
}

ueberschrift() {
	printf '\n%s%s%s\n' "$fett" "$1" "$normal"
}

# Feld <nr> der Zeile von <name> aus einer Datei im Stil von /etc/passwd
feld() {
	local datei="$1" name="$2" nr="$3"
	awk -F: -v name="$name" -v nr="$nr" '$1 == name { print $nr; exit }' "$etc/$datei"
}

# Name zu einer UID bzw. GID – oder die Nummer, wenn es keinen Namen gibt
name_zu() {
	local datei="$1" nummer="$2" name
	name="$(awk -F: -v nr="$nummer" '$3 == nr { print $1; exit }' "$etc/$datei")"
	echo "${name:-$nummer}"
}

# Prüft Besitzer, Gruppe und Rechte eines Pfads (wie in check-tag2.sh).
# Ein "-" bei Besitzer, Gruppe oder Rechten überspringt die jeweilige Prüfung.
probleme_pfad() {
	local pfad="$1" besitzer="$2" gruppe="$3" rechte="$4" uid gid modus

	if [[ ! -e "$wurzel$pfad" ]]; then
		echo "existiert nicht"
		return
	fi
	read -r uid gid modus < <(stat -c '%u %g %a' "$wurzel$pfad")

	[[ "$besitzer" == "-" || "$uid" == "$(feld passwd "$besitzer" 3)" ]] ||
		echo "Besitzer ist $(name_zu passwd "$uid") statt $besitzer"
	[[ "$gruppe" == "-" || "$gid" == "$(feld group "$gruppe" 3)" ]] ||
		echo "Gruppe ist $(name_zu group "$gid") statt $gruppe"
	[[ "$rechte" == "-" || "$modus" == "$rechte" ]] ||
		echo "Rechte sind $modus statt $rechte"
}

zeile() {
	paste -sd ';' | sed 's/;/; /g'
}

# ---------------------------------------------------------------------------

if [[ -z "$CHECK_ROOT" && $EUID -ne 0 ]]; then
	echo "Bitte mit Root-Rechten ausführen: sudo bash $0" >&2
	exit 1
fi

printf '%sSelbstkontrolle Tag 3 – Pinguin GmbH%s\n' "$fett" "$normal"
printf 'Server: %s\n' "$hostname"

# --- T3-01 ------------------------------------------------------------------
ueberschrift "T3-01 Server-Steckbrief"

steckbrief=/srv/firma/geschaeftsfuehrung/server-steckbrief.txt
if [[ ! -f "$wurzel$steckbrief" ]]; then
	fehler "$steckbrief fehlt" "sudo cp ~/steckbrief.txt $steckbrief"
else
	probleme="$(probleme_pfad "$steckbrief" - geschaeftsfuehrung -)"
	if [[ -z "$probleme" ]]; then
		ok "$steckbrief gehört der Gruppe geschaeftsfuehrung"
	else
		fehler "$steckbrief: $(zeile <<<"$probleme")" "fehlt das SGID-Bit am Ordner? sudo chgrp geschaeftsfuehrung <datei>"
	fi

	# Grete liest über die Gruppe geschaeftsfuehrung oder über die Rechte für andere
	read -r gid modus < <(stat -c '%g %a' "$wurzel$steckbrief")
	if [[ "$gid" == "$(feld group geschaeftsfuehrung 3)" ]] && ((8#$modus & 8#040)) || ((8#$modus & 8#004)); then
		ok "Grete kann den Steckbrief lesen"
	else
		fehler "Grete kann den Steckbrief nicht lesen (Rechte $modus)" "Leserecht für die Gruppe geschaeftsfuehrung: chmod g+r"
	fi

	fehlend=()
	grep -qw -- "$hostname" "$wurzel$steckbrief" || fehlend+=("Hostname $hostname")
	grep -q '^PRETTY_NAME=' "$wurzel$steckbrief" || fehlend+=("PRETTY_NAME")
	grep -q '^Mem:' "$wurzel$steckbrief" || fehlend+=("Mem: (free -h)")
	grep -q 'default via' "$wurzel$steckbrief" || fehlend+=("default via (ip route)")
	grep -q '^nameserver' "$wurzel$steckbrief" || fehlend+=("nameserver")
	if [[ ${#fehlend[@]} -eq 0 ]]; then
		ok "Der Steckbrief enthält Hostname, Distribution, Arbeitsspeicher, Gateway und DNS-Server"
	else
		fehler "Im Steckbrief fehlt: $(IFS=';'; echo "${fehlend[*]}" | sed 's/;/, /g')" \
			"aus Versehen > statt >> verwendet?"
	fi
fi

# --- T3-04 ------------------------------------------------------------------
ueberschrift "T3-04 Datensicherung"

probleme="$(probleme_pfad /srv/backup root root 700)"
if [[ -z "$probleme" ]]; then
	ok "/srv/backup (root:root, 700)"
else
	fehler "/srv/backup: $(zeile <<<"$probleme")" "Sicherungen enthalten alle Abteilungen – nur root darf hinein"
fi

archive=()
if [[ -d "$wurzel/srv/backup" ]]; then
	mapfile -t archive < <(find "$wurzel/srv/backup" -maxdepth 1 -type f -name 'firma-*.tar.gz' | sort)
fi
if [[ ${#archive[@]} -eq 0 ]]; then
	fehler "Keine Sicherung firma-<datum>.tar.gz in /srv/backup" \
		"sudo tar -czf /srv/backup/firma-\$(date +%F).tar.gz /srv/firma"
else
	gefunden=""
	for archiv in "${archive[@]}"; do
		if tar -tzf "$archiv" 2>/dev/null | grep -qx 'srv/firma/vertrieb/angebot-1\.txt'; then
			gefunden="${archiv##*/}"
		fi
	done
	if [[ -n "$gefunden" ]]; then
		ok "${#archive[@]} Sicherung(en) in /srv/backup, $gefunden enthält srv/firma/vertrieb/angebot-1.txt"
	else
		fehler "Keine Sicherung enthält srv/firma/vertrieb/angebot-1.txt" \
			"ganz /srv/firma sichern; Inhalt prüfen mit tar -tzf <archiv>"
	fi
fi

probleme="$(probleme_pfad /srv/firma/vertrieb/angebot-1.txt lwagner vertrieb -)"
if [[ -z "$probleme" ]]; then
	ok "angebot-1.txt ist wiederhergestellt (lwagner:vertrieb)"
else
	fehler "/srv/firma/vertrieb/angebot-1.txt: $(zeile <<<"$probleme")" \
		"mit sudo aus der Sicherung auspacken: tar -xzf <archiv> -C / srv/firma/vertrieb/angebot-1.txt"
fi

# --- T3-05 ------------------------------------------------------------------
ueberschrift "T3-05 Das erste Skript"

skript=/usr/local/sbin/firma-backup
if [[ ! -f "$wurzel$skript" ]]; then
	fehler "$skript fehlt" "sudo cp ~/firma-backup $skript"
else
	probleme="$(probleme_pfad "$skript" root root 755)"
	if [[ -z "$probleme" ]]; then
		ok "$skript (root:root, 755)"
	else
		hinweis="sudo chown root:root $skript; sudo chmod 755 $skript"
		((8#$(stat -c '%a' "$wurzel$skript") & 8#022)) &&
			hinweis="GEFÄHRLICH: andere können das Skript ändern, das als root läuft – $hinweis"
		fehler "$skript: $(zeile <<<"$probleme")" "$hinweis"
	fi

	erste_zeile="$(head -n 1 "$wurzel$skript")"
	if [[ "$erste_zeile" =~ ^#!.*bash ]]; then
		ok "Die erste Zeile ist der Shebang ($erste_zeile)"
	else
		fehler "Die erste Zeile ist '$erste_zeile'" "die erste Zeile muss #!/bin/bash lauten"
	fi

	grep -q 'tar ' "$wurzel$skript" ||
		info "Im Skript kommt kein tar-Aufruf vor – sichert es wirklich etwas?"
fi

# --- Ergebnis ---------------------------------------------------------------
echo
if [[ $bestanden -eq $gesamt ]]; then
	printf '%s%s🎉 %d von %d Prüfungen bestanden – Tag 3 abgenommen!%s\n' \
		"$fett" "$gruen" "$bestanden" "$gesamt" "$normal"
else
	printf '%s%d von %d Prüfungen bestanden.%s\n' "$fett" "$bestanden" "$gesamt" "$normal"
fi
