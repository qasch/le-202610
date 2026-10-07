#!/usr/bin/env bash
#
# check-tag1.sh – Selbstkontrolle für Tag 1 des Projekts "Pinguin GmbH"
#
# Aufruf auf dem Teamserver:
#   sudo bash check-tag1.sh
#
# Das Skript liest nur und verändert nichts am System.
#
# Zum Testen ohne echten Server kann ein alternatives Wurzelverzeichnis
# (mit etc/ und home/ darin) angegeben werden:
#   CHECK_ROOT=./testsystem CHECK_HOSTNAME=pinguin-team1 bash check-tag1.sh

wurzel="${CHECK_ROOT:-}"
etc="$wurzel/etc"
hostname="${CHECK_HOSTNAME:-$(hostname)}"

# Mitarbeitende aus T1-04: benutzername|vollständiger Name|Abteilung
mitarbeitende=(
	"gfrost|Grete Frost|geschaeftsfuehrung"
	"lwagner|Lena Wagner|vertrieb"
	"mkaya|Murat Kaya|vertrieb"
	"sromano|Sofia Romano|vertrieb"
	"jbecker|Jonas Becker|entwicklung"
	"ademir|Aylin Demir|entwicklung"
	"thoffmann|Tim Hoffmann|entwicklung"
	"nschulz|Nina Schulz|entwicklung"
	"pkrause|Peter Krause|buchhaltung"
	"elindner|Eva Lindner|buchhaltung"
	"oweber|Oskar Weber|buchhaltung"
)

gruppen=(geschaeftsfuehrung vertrieb entwicklung buchhaltung mitarbeitende)

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

existiert() {
	local datei="$1" name="$2"
	awk -F: -v name="$name" '$1 == name { gefunden = 1 } END { exit !gefunden }' "$etc/$datei"
}

# Ist <benutzer> Mitglied von <gruppe>? (zusätzliche oder primäre Gruppe)
in_gruppe() {
	local benutzer="$1" gruppe="$2" mitglieder gid
	mitglieder=",$(feld group "$gruppe" 4),"
	[[ "$mitglieder" == *",$benutzer,"* ]] && return 0
	gid="$(feld group "$gruppe" 3)"
	[[ -n "$gid" && "$(feld passwd "$benutzer" 4)" == "$gid" ]]
}

# Prüft ein Konto gegen die Richtlinien der IT. Gibt die gefundenen
# Probleme aus (eines pro Zeile) – keine Ausgabe bedeutet: alles in Ordnung.
probleme_konto() {
	local benutzer="$1" name="$2" abteilung="$3"
	local heim shell kommentar hash

	if ! existiert passwd "$benutzer"; then
		echo "Konto existiert nicht"
		return
	fi

	heim="$(feld passwd "$benutzer" 6)"
	shell="$(feld passwd "$benutzer" 7)"
	kommentar="$(feld passwd "$benutzer" 5)"
	hash="$(feld shadow "$benutzer" 2)"

	if [[ "$heim" != "/home/$benutzer" ]]; then
		echo "Heimatverzeichnis in /etc/passwd ist '$heim' statt '/home/$benutzer'"
	elif [[ ! -d "$wurzel$heim" ]]; then
		echo "Heimatverzeichnis $heim fehlt (Option für das Anlegen vergessen?)"
	else
		# Numerisch vergleichen, da stat Namen über das echte /etc/passwd auflöst
		[[ -n "$CHECK_ROOT" || "$(stat -c %u "$wurzel$heim" 2>/dev/null)" == "$(feld passwd "$benutzer" 3)" ]] ||
			echo "Heimatverzeichnis gehört nicht $benutzer"
		[[ -e "$wurzel$heim/.bashrc" ]] ||
			echo "Standarddateien aus /etc/skel fehlen im Heimatverzeichnis"
	fi

	[[ "$shell" == "/bin/bash" || "$shell" == "/usr/bin/bash" ]] ||
		echo "Login-Shell ist '${shell:-leer}' statt /bin/bash"

	[[ "${kommentar%%,*}" == "$name" ]] ||
		echo "Kommentarfeld ist '$kommentar' statt '$name'"

	in_gruppe "$benutzer" "$abteilung" ||
		echo "nicht in Gruppe $abteilung"
	in_gruppe "$benutzer" mitarbeitende ||
		echo "nicht in Gruppe mitarbeitende"

	# Ein gesperrtes Konto (führendes "!") zählt als "Passwort gesetzt"
	[[ "${hash#!}" == \$* ]] ||
		echo "kein Passwort gesetzt"
}

pruefe_konto() {
	local benutzer="$1" name="$2" abteilung="$3" probleme
	probleme="$(probleme_konto "$benutzer" "$name" "$abteilung")"
	if [[ -z "$probleme" ]]; then
		ok "$benutzer ($name)"
	else
		fehler "$benutzer ($name)" "$(paste -sd ';' <<<"$probleme" | sed 's/;/; /g')"
	fi
}

# ---------------------------------------------------------------------------

if [[ -z "$CHECK_ROOT" && $EUID -ne 0 ]]; then
	echo "Bitte mit Root-Rechten ausführen: sudo bash $0" >&2
	exit 1
fi

if [[ ! -r "$etc/shadow" ]]; then
	echo "$etc/shadow ist nicht lesbar – bitte mit Root-Rechten ausführen." >&2
	exit 1
fi

printf '%sSelbstkontrolle Tag 1 – Pinguin GmbH%s\n' "$fett" "$normal"
printf 'Server: %s\n' "$hostname"

# --- T1-01 ------------------------------------------------------------------
ueberschrift "T1-01 Server in Betrieb nehmen"

if [[ "$hostname" =~ ^pinguin-team[0-9]+$ ]]; then
	ok "Hostname lautet $hostname"
else
	fehler "Hostname lautet '$hostname'" "erwartet wird pinguin-team<N>"
fi

if grep -qw -- "$hostname" "$etc/hosts" 2>/dev/null; then
	ok "Hostname ist in /etc/hosts eingetragen"
else
	fehler "Hostname fehlt in /etc/hosts" "sonst meldet sudo 'unable to resolve host'"
fi

if [[ -n "$CHECK_ROOT" ]]; then
	info "Testmodus: Prüfung von SSH-Dienst und sudo-Paket übersprungen"
else
	if systemctl is-active --quiet ssh 2>/dev/null; then
		ok "SSH-Dienst läuft"
	else
		fehler "SSH-Dienst läuft nicht" "Paket openssh-server installiert? systemctl status ssh"
	fi

	if command -v sudo >/dev/null; then
		ok "sudo ist installiert"
	else
		fehler "sudo ist nicht installiert"
	fi
fi

# Persönliche Admin-Konten: Mitglieder von "sudo" mit UID >= 1000,
# die nicht zur Firma gehören
admins=()
IFS=',' read -ra sudo_mitglieder <<<"$(feld group sudo 4)"
for benutzer in "${sudo_mitglieder[@]}"; do
	uid="$(feld passwd "$benutzer" 3)"
	[[ -n "$uid" && "$uid" -ge 1000 ]] || continue
	firma=0
	for eintrag in "${mitarbeitende[@]}" "mneumann||"; do
		[[ "${eintrag%%|*}" == "$benutzer" ]] && firma=1
	done
	[[ $firma -eq 0 ]] && admins+=("$benutzer")
done

if [[ ${#admins[@]} -ge 2 ]]; then
	ok "${#admins[@]} persönliche Admin-Konten in der Gruppe sudo: ${admins[*]}"
else
	fehler "nur ${#admins[@]} persönliche Admin-Konten in der Gruppe sudo" \
		"jedes Teammitglied braucht ein eigenes Konto in der Gruppe sudo"
fi

# --- T1-03 ------------------------------------------------------------------
ueberschrift "T1-03 Abteilungen vorbereiten"

for gruppe in "${gruppen[@]}"; do
	if existiert group "$gruppe"; then
		ok "Gruppe $gruppe existiert (GID $(feld group "$gruppe" 3))"
	else
		fehler "Gruppe $gruppe fehlt"
	fi
done

if [[ -e "$etc/skel/WILLKOMMEN.txt" ]]; then
	info "⭐⭐ /etc/skel/WILLKOMMEN.txt ist vorhanden"
fi

# --- T1-04 ------------------------------------------------------------------
ueberschrift "T1-04 Onboarding"

for eintrag in "${mitarbeitende[@]}"; do
	IFS='|' read -r benutzer name abteilung <<<"$eintrag"
	pruefe_konto "$benutzer" "$name" "$abteilung"
done

# Passwortänderung bei erster Anmeldung: nur informativ, da sich nach dem
# ersten Login das Datum der letzten Änderung ändert
offen=()
for eintrag in "${mitarbeitende[@]}" "mneumann||"; do
	benutzer="${eintrag%%|*}"
	existiert shadow "$benutzer" || continue
	[[ "$(feld shadow "$benutzer" 3)" == "0" ]] || offen+=("$benutzer")
done
if [[ ${#offen[@]} -gt 0 ]]; then
	info "Ohne erzwungene Passwortänderung (oder bereits angemeldet): ${offen[*]}"
fi

# --- T1-05 ------------------------------------------------------------------
ueberschrift "T1-05 Sonderfälle"

pruefe_konto mneumann "Mia Neumann" entwicklung

if existiert shadow mneumann; then
	ablauf="$(feld shadow mneumann 8)"
	soll=$(($(date -u -d 2027-01-31 +%s) / 86400))
	if [[ -n "$ablauf" && "$ablauf" -ge $((soll - 1)) && "$ablauf" -le $((soll + 1)) ]]; then
		ok "Konto mneumann läuft am 31.01.2027 ab"
	elif [[ -z "$ablauf" ]]; then
		fehler "Konto mneumann hat kein Ablaufdatum"
	else
		fehler "Konto mneumann läuft am $(date -u -d "@$((ablauf * 86400))" +%d.%m.%Y) ab" \
			"erwartet: 31.01.2027"
	fi
fi

fehlende=()
for gruppe in vertrieb entwicklung mitarbeitende; do
	in_gruppe mkaya "$gruppe" || fehlende+=("$gruppe")
done
if [[ ${#fehlende[@]} -eq 0 ]]; then
	ok "mkaya ist in vertrieb, entwicklung und mitarbeitende"
else
	fehler "mkaya fehlt in: ${fehlende[*]}" "usermod -G ersetzt alle zusätzlichen Gruppen – was macht -a?"
fi

hash="$(feld shadow elindner 2)"
if [[ "$hash" == '!$'* ]]; then
	ok "Konto elindner ist gesperrt, das Passwort bleibt erhalten"
elif [[ "$hash" == '!'* || -z "$hash" ]]; then
	fehler "elindner ist gesperrt, hat aber kein Passwort" "erst Passwort setzen, dann sperren"
else
	fehler "Konto elindner ist nicht gesperrt"
fi

if existiert passwd pinguin-backup; then
	uid="$(feld passwd pinguin-backup 3)"
	shell="$(feld passwd pinguin-backup 7)"
	hash="$(feld shadow pinguin-backup 2)"
	probleme=()
	[[ "$uid" -lt 1000 ]] || probleme+=("UID $uid ist kein Systemkonto")
	[[ "$shell" == */nologin || "$shell" == */false ]] || probleme+=("Login-Shell ist '$shell'")
	[[ "$hash" != *'$'* ]] || probleme+=("hat ein Passwort")
	if [[ ${#probleme[@]} -eq 0 ]]; then
		ok "Dienstkonto pinguin-backup (UID $uid, Shell $shell)"
	else
		fehler "Dienstkonto pinguin-backup" "$(IFS=';'; echo "${probleme[*]}" | sed 's/;/; /g')"
	fi
else
	fehler "Dienstkonto pinguin-backup existiert nicht"
fi

# --- Ergebnis ---------------------------------------------------------------
echo
if [[ $bestanden -eq $gesamt ]]; then
	printf '%s%s🎉 %d von %d Prüfungen bestanden – Tag 1 abgenommen!%s\n' \
		"$fett" "$gruen" "$bestanden" "$gesamt" "$normal"
else
	printf '%s%d von %d Prüfungen bestanden.%s\n' "$fett" "$bestanden" "$gesamt" "$normal"
fi
