#!/usr/bin/env bash
#
# aufholen-tag2.sh: stellt auf dem Teamserver den Stand her, den Tag 2
# voraussetzt: die Pflichtteile von T1-03, T1-04 und T1-05.
#
# Aufruf auf dem Teamserver:
#   sudo bash aufholen-tag2.sh
#
# Das Skript ergänzt nur, was fehlt, und repariert, was nicht stimmt. Es
# löscht nichts, was ihr angelegt habt. Jede Aktion wird mit dem Kommando
# und einer Begründung ausgegeben und in /root/aufholen-tag2.log
# festgehalten. Ihr könnt es beliebig oft ausführen. Beim zweiten Mal gibt
# es nichts mehr zu tun.

startpasswort=Pinguin-Start-2026
protokoll=/root/aufholen-tag2.log

# Mitarbeitende aus T1-04 und T1-05: benutzername|vollständiger Name|Abteilung
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
	"mneumann|Mia Neumann|entwicklung"
)

gruppen=(geschaeftsfuehrung vertrieb entwicklung buchhaltung mitarbeitende)

if [[ -t 1 ]]; then
	gelb=$'\e[33m'; fett=$'\e[1m'; normal=$'\e[0m'
else
	gelb=''; fett=''; normal=''
fi

aenderungen=0

# aktion <begründung> <kommando>: zeigt das Kommando, führt es aus und
# protokolliert es
aktion() {
	local grund="$1" kommando="$2"
	printf '  %s> %s%s\n' "$fett" "$kommando" "$normal"
	printf '    # %s\n' "$grund"
	printf '%s  # %s\n' "$kommando" "$grund" >>"$protokoll"
	eval "$kommando"
	aenderungen=$((aenderungen + 1))
}

hinweis() {
	printf '  %s[INFO] %s%s\n' "$gelb" "$1" "$normal"
}

ueberschrift() {
	printf '\n%s%s%s\n' "$fett" "$1" "$normal"
}

in_gruppe() {
	id -nG "$1" 2>/dev/null | tr ' ' '\n' | grep -qx "$2"
}

hash_von() {
	getent shadow "$1" | cut -d: -f2
}

# ---------------------------------------------------------------------------

if [[ $EUID -ne 0 ]]; then
	echo "Bitte mit Root-Rechten ausführen: sudo bash $0" >&2
	exit 1
fi

printf '%sAufholen für Tag 2, Pinguin GmbH%s\n' "$fett" "$normal"
printf '\n# Lauf vom %s\n' "$(date '+%d.%m.%Y %H:%M')" >>"$protokoll"

# --- T1-01: nur Hinweise ------------------------------------------------------
ueberschrift "T1-01 Server (wird nicht verändert)"

if [[ ! "$(hostname)" =~ ^pinguin-team[0-9]+$ ]]; then
	hinweis "Der Hostname lautet $(hostname) statt pinguin-team<N>, siehe T1-01 Schritt 2."
fi
admins=0
for benutzer in $(getent group sudo | cut -d: -f4 | tr ',' ' '); do
	[[ $(id -u "$benutzer" 2>/dev/null || echo 0) -ge 1000 ]] && admins=$((admins + 1))
done
if [[ $admins -lt 2 ]]; then
	hinweis "Nur $admins persönliches Konto in der Gruppe sudo. Jedes Teammitglied braucht eins (T1-01 Schritt 6)."
fi

# --- T1-03: Gruppen -----------------------------------------------------------
ueberschrift "T1-03 Gruppen"

for gruppe in "${gruppen[@]}"; do
	getent group "$gruppe" >/dev/null ||
		aktion "Die Gruppe $gruppe fehlt." "groupadd $gruppe"
done

# --- T1-04 und T1-05: Konten der Mitarbeitenden -------------------------------
ueberschrift "T1-04 und T1-05 Konten der Mitarbeitenden"

for eintrag in "${mitarbeitende[@]}"; do
	IFS='|' read -r benutzer name abteilung <<<"$eintrag"

	if ! id "$benutzer" &>/dev/null; then
		aktion "Das Konto von $name fehlt." \
			"useradd -m -c '$name' -s /bin/bash -G $abteilung,mitarbeitende $benutzer"
		aktion "Startpasswort setzen." "echo '$benutzer:$startpasswort' | chpasswd"
		aktion "Passwortänderung bei der ersten Anmeldung erzwingen." "chage -d 0 $benutzer"
		continue
	fi

	shell="$(getent passwd "$benutzer" | cut -d: -f7)"
	[[ "$shell" == /bin/bash || "$shell" == /usr/bin/bash ]] ||
		aktion "Login-Shell von $benutzer ist '$shell' statt /bin/bash." "usermod -s /bin/bash $benutzer"

	kommentar="$(getent passwd "$benutzer" | cut -d: -f5)"
	[[ "${kommentar%%,*}" == "$name" ]] ||
		aktion "Im Kommentarfeld von $benutzer steht '$kommentar' statt '$name'." "usermod -c '$name' $benutzer"

	for gruppe in "$abteilung" mitarbeitende; do
		in_gruppe "$benutzer" "$gruppe" ||
			aktion "$benutzer fehlt in der Gruppe $gruppe." "usermod -aG $gruppe $benutzer"
	done

	heim="$(getent passwd "$benutzer" | cut -d: -f6)"
	if [[ "$heim" != "/home/$benutzer" ]]; then
		aktion "Heimatverzeichnis von $benutzer ist in /etc/passwd '$heim' statt /home/$benutzer." \
			"usermod -d /home/$benutzer $benutzer"
	fi
	if [[ ! -d "/home/$benutzer" ]]; then
		aktion "Das Heimatverzeichnis von $benutzer fehlt (Option -m vergessen?)." "mkhomedir_helper $benutzer"
		aktion "Heimatverzeichnisse sind privat (wie bei useradd -m)." "chmod 700 /home/$benutzer"
	fi

	# Ein Passwort ist gesetzt, wenn ein Hash ($…) vorhanden ist, auch hinter
	# dem "!" eines gesperrten Kontos
	hash="$(hash_von "$benutzer")"
	if [[ "${hash#!}" != \$* ]]; then
		aktion "$benutzer hat kein Passwort." "echo '$benutzer:$startpasswort' | chpasswd"
		aktion "Passwortänderung bei der ersten Anmeldung erzwingen." "chage -d 0 $benutzer"
	fi
done

# --- T1-05: Sonderfälle -------------------------------------------------------
ueberschrift "T1-05 Sonderfälle"

ablauf_soll=$(($(date -u -d 2027-01-31 +%s) / 86400))
ablauf_ist="$(getent shadow mneumann | cut -d: -f8)"
[[ "$ablauf_ist" == "$ablauf_soll" ]] ||
	aktion "Das Praktikum von Mia Neumann endet am 31.01.2027." "chage -E 2027-01-31 mneumann"

in_gruppe mkaya entwicklung ||
	aktion "Murat Kaya unterstützt auch die Entwicklung." "usermod -aG entwicklung mkaya"

[[ "$(hash_von elindner)" == '!'* ]] ||
	aktion "Eva Lindner ist in Elternzeit, ihr Konto wird gesperrt." "usermod -L elindner"

if id pinguin-backup &>/dev/null && [[ $(id -u pinguin-backup) -ge 1000 ]]; then
	aktion "pinguin-backup ist kein Systemkonto (UID $(id -u pinguin-backup)), neu anlegen, Option -r." \
		"userdel pinguin-backup"
fi
if ! id pinguin-backup &>/dev/null; then
	aktion "Das Dienstkonto für die Datensicherung fehlt." \
		"useradd -r -s /usr/sbin/nologin -c 'Backup-Dienst' pinguin-backup"
else
	shell="$(getent passwd pinguin-backup | cut -d: -f7)"
	[[ "$shell" == */nologin || "$shell" == */false ]] ||
		aktion "Mit pinguin-backup soll sich niemand anmelden können." "usermod -s /usr/sbin/nologin pinguin-backup"
	[[ "$(hash_von pinguin-backup)" != *'$'* ]] ||
		aktion "pinguin-backup braucht kein Passwort." "usermod -p '!' pinguin-backup"
fi

# --- Ergebnis -----------------------------------------------------------------
echo
if [[ $aenderungen -eq 0 ]]; then
	printf '%sNichts zu tun, euer Server hat bereits den Stand für Tag 2.%s\n' "$fett" "$normal"
else
	printf '%s%d Änderungen vorgenommen.%s Sie stehen auch in %s.\n' "$fett" "$aenderungen" "$normal" "$protokoll"
	echo "Sucht euch drei Zeilen aus und erklärt sie im Logbuch: Was tut das Kommando, und in welchem Ticket hättet ihr es gebraucht?"
fi
echo "Zur Kontrolle: sudo bash check-tag1.sh"
