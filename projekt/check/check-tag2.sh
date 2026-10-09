#!/usr/bin/env bash
#
# check-tag2.sh: Selbstkontrolle für Tag 2 des Projekts "Pinguin GmbH"
#
# Aufruf auf dem Teamserver:
#   sudo bash check-tag2.sh
#
# Das Skript liest nur und verändert nichts am System.
#
# Zum Testen ohne echten Server kann ein alternatives Wurzelverzeichnis
# (mit etc/, home/ und srv/ darin) angegeben werden. Da es hier vor allem
# um Besitzer und Gruppen geht, wird das Testsystem mit fakeroot gebaut
# und auch unter fakeroot geprüft (siehe check/test/testsystem-tag2.sh):
#   fakeroot -i zustand -- env CHECK_ROOT=./testsystem bash check-tag2.sh

wurzel="${CHECK_ROOT:-}"
etc="$wurzel/etc"
hostname="${CHECK_HOSTNAME:-$(hostname)}"

# Alle Mitarbeitenden aus T1-04 und T1-05 (oweber wird in T2-06 gelöscht)
mitarbeitende=(gfrost lwagner mkaya sromano jbecker ademir thoffmann nschulz pkrause elindner oweber mneumann)

abteilungen=(geschaeftsfuehrung vertrieb entwicklung buchhaltung)

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
	printf '  %s[OK]%s %s\n' "$gruen" "$normal" "$1"
}

fehler() {
	gesamt=$((gesamt + 1))
	printf '  %s[FEHLER]%s %s\n' "$rot" "$normal" "$1"
	if [[ -n "$2" ]]; then
		printf '      %sTipp: %s%s\n' "$gelb" "$2" "$normal"
	fi
}

info() {
	printf '  %s[INFO]%s %s\n' "$gelb" "$normal" "$1"
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

# Name zu einer UID bzw. GID, oder die Nummer, wenn es keinen Namen gibt
name_zu() {
	local datei="$1" nummer="$2" name
	name="$(awk -F: -v nr="$nummer" '$3 == nr { print $1; exit }' "$etc/$datei")"
	echo "${name:-$nummer}"
}

# Ist <benutzer> Mitglied von <gruppe>? (zusätzliche oder primäre Gruppe)
in_gruppe() {
	local benutzer="$1" gruppe="$2" mitglieder gid
	mitglieder=",$(feld group "$gruppe" 4),"
	[[ "$mitglieder" == *",$benutzer,"* ]] && return 0
	gid="$(feld group "$gruppe" 3)"
	[[ -n "$gid" && "$(feld passwd "$benutzer" 4)" == "$gid" ]]
}

# Prüft Besitzer, Gruppe und Rechte eines Pfads. Gibt die gefundenen
# Probleme aus (eines pro Zeile), keine Ausgabe bedeutet: alles in Ordnung.
# Ein "-" bei Gruppe oder Rechten überspringt die jeweilige Prüfung.
# Besitzer und Gruppe werden numerisch über $etc/passwd bzw. $etc/group
# verglichen, damit das auch im Testsystem funktioniert.
probleme_pfad() {
	local pfad="$1" besitzer="$2" gruppe="$3" rechte="$4" uid gid modus

	if [[ ! -e "$wurzel$pfad" ]]; then
		echo "existiert nicht"
		return
	fi
	read -r uid gid modus < <(stat -c '%u %g %a' "$wurzel$pfad")

	[[ "$uid" == "$(feld passwd "$besitzer" 3)" ]] ||
		echo "Besitzer ist $(name_zu passwd "$uid") statt $besitzer"
	[[ "$gruppe" == "-" || "$gid" == "$(feld group "$gruppe" 3)" ]] ||
		echo "Gruppe ist $(name_zu group "$gid") statt $gruppe"
	[[ "$rechte" == "-" || "$modus" == "$rechte" ]] ||
		echo "Rechte sind $modus statt $rechte"
}

# Fasst mehrere Zeilen zu "a; b; c" zusammen
zeile() {
	paste -sd ';' | sed 's/;/; /g'
}

rechte_von() {
	stat -c '%a' "$wurzel$1" 2>/dev/null
}

# ---------------------------------------------------------------------------

if [[ -z "$CHECK_ROOT" && $EUID -ne 0 ]]; then
	echo "Bitte mit Root-Rechten ausführen: sudo bash $0" >&2
	exit 1
fi

printf '%sSelbstkontrolle Tag 2, Pinguin GmbH%s\n' "$fett" "$normal"
printf 'Server: %s\n' "$hostname"

# --- T2-01 ------------------------------------------------------------------
ueberschrift "T2-01 Heimatverzeichnisse"

anzahl=0
fehlerhaft=0
for benutzer in "${mitarbeitende[@]}"; do
	existiert passwd "$benutzer" || continue
	anzahl=$((anzahl + 1))
	probleme="$(probleme_pfad "/home/$benutzer" "$benutzer" - 700)"
	if [[ -n "$probleme" ]]; then
		fehlerhaft=$((fehlerhaft + 1))
		fehler "/home/$benutzer: $(zeile <<<"$probleme")" "Heimatverzeichnisse sollen privat bleiben: chmod 700"
	fi
done
if [[ $fehlerhaft -eq 0 ]]; then
	ok "Alle $anzahl Heimatverzeichnisse der Mitarbeitenden haben 700 und gehören der jeweiligen Person"
fi

if existiert passwd htest; then
	info "Profi: Das Testkonto htest existiert noch, bitte mit userdel -r löschen"
fi

# --- T2-02 ------------------------------------------------------------------
ueberschrift "T2-02 Abteilungsordner"

probleme="$(probleme_pfad /srv/firma root root 755)"
if [[ -z "$probleme" ]]; then
	ok "/srv/firma (root:root, 755)"
else
	fehler "/srv/firma: $(zeile <<<"$probleme")"
fi

for abteilung in "${abteilungen[@]}"; do
	pfad="/srv/firma/$abteilung"

	# Ansatz 3 aus T2-04: Grete als Besitzerin des Vertriebsordners
	if [[ $abteilung == vertrieb && -z "$(probleme_pfad "$pfad" gfrost vertrieb 2570)" ]]; then
		ok "$pfad (gfrost:vertrieb, 2570, Ansatz 3 aus T2-04)"
		continue
	fi

	probleme="$(probleme_pfad "$pfad" root "$abteilung" 2770)"
	if [[ -z "$probleme" ]]; then
		ok "$pfad (root:$abteilung, 2770)"
	else
		hinweis=""
		case "$(rechte_von "$pfad")" in
			770) hinweis="SGID-Bit fehlt, neue Dateien gehören sonst der privaten Gruppe" ;;
			2775 | 775) hinweis="others haben Rechte. Rückbau aus T2-04 Erweiterung vergessen?" ;;
		esac
		fehler "$pfad: $(zeile <<<"$probleme")" "$hinweis"
	fi
done

# Dateien in den Abteilungsordnern, die nicht der Abteilungsgruppe gehören
falsch=()
for abteilung in "${abteilungen[@]}"; do
	[[ -d "$wurzel/srv/firma/$abteilung" ]] || continue
	soll="$(feld group "$abteilung" 3)"
	while read -r gid name; do
		[[ "$gid" == "$soll" ]] || falsch+=("$abteilung/$name ($(name_zu group "$gid"))")
	done < <(find "$wurzel/srv/firma/$abteilung" -mindepth 1 -printf '%G %P\n')
done
if [[ ${#falsch[@]} -eq 0 ]]; then
	ok "Alle Dateien in den Abteilungsordnern gehören der Abteilungsgruppe"
else
	fehler "Falsche Gruppe: ${falsch[*]:0:5}" "chgrp <abteilung> <datei>. Mit mv verschoben statt kopiert?"
fi

# --- T2-03 ------------------------------------------------------------------
ueberschrift "T2-03 Austauschordner"

pfad=/srv/firma/austausch
probleme="$(probleme_pfad "$pfad" root mitarbeitende 3770)"
if [[ -z "$probleme" ]]; then
	ok "$pfad (root:mitarbeitende, 3770)"
else
	hinweis=""
	case "$(rechte_von "$pfad")" in
		2770) hinweis="Sticky Bit fehlt, jede Person kann fremde Dateien löschen" ;;
		1770) hinweis="SGID-Bit fehlt, neue Dateien gehören sonst der privaten Gruppe" ;;
	esac
	fehler "$pfad: $(zeile <<<"$probleme")" "$hinweis"
fi

if [[ -f "$wurzel$pfad/speiseplan.txt" ]]; then
	ok "Der Speiseplan liegt im Austauschordner"
else
	fehler "$pfad/speiseplan.txt fehlt" "Lena legt ihn in Schritt 4 neu an"
fi

# --- T2-04 ------------------------------------------------------------------
ueberschrift "T2-04 Lesezugriff für die Geschäftsführung (Bonus)"

zu_viel=()
zu_wenig=()
for gruppe in vertrieb entwicklung buchhaltung; do
	in_gruppe gfrost "$gruppe" && zu_viel+=("$gruppe")
done
for gruppe in geschaeftsfuehrung mitarbeitende; do
	in_gruppe gfrost "$gruppe" || zu_wenig+=("$gruppe")
done
if [[ ${#zu_viel[@]} -eq 0 && ${#zu_wenig[@]} -eq 0 ]]; then
	ok "gfrost ist nur in geschaeftsfuehrung und mitarbeitende"
elif [[ ${#zu_viel[@]} -gt 0 ]]; then
	fehler "gfrost ist noch in: ${zu_viel[*]}" "Rückbau mit gpasswd -d gfrost <gruppe>"
else
	fehler "gfrost fehlt in: ${zu_wenig[*]}" "usermod -G ohne -a verwendet?"
fi

# --- T2-05 ------------------------------------------------------------------
ueberschrift "T2-05 Verknüpfungen"

link=/home/nschulz/abteilung
if [[ -L "$wurzel$link" ]]; then
	ziel="$(readlink "$wurzel$link")"
	uid="$(stat -c %u "$wurzel$link")"
	if [[ "${ziel%/}" != /srv/firma/entwicklung ]]; then
		fehler "$link zeigt auf $ziel" "erwartet: /srv/firma/entwicklung"
	elif [[ "$uid" != "$(feld passwd nschulz 3)" ]]; then
		fehler "$link gehört $(name_zu passwd "$uid") statt nschulz" "den Link als nschulz anlegen (sudo -iu nschulz)"
	else
		ok "$link -> /srv/firma/entwicklung"
	fi
elif [[ -e "$wurzel$link" ]]; then
	fehler "$link ist kein symbolischer Link" "ln -s <ziel> <linkname>"
else
	fehler "$link fehlt" "ln -s /srv/firma/entwicklung ~/abteilung (als nschulz)"
fi

uebrig=()
for link in /home/lwagner/spion /home/nschulz/tippfehler; do
	[[ -L "$wurzel$link" || -e "$wurzel$link" ]] && uebrig+=("$link")
done
if [[ ${#uebrig[@]} -eq 0 ]]; then
	ok "Die Versuchslinks spion und tippfehler sind gelöscht"
else
	fehler "Noch vorhanden: ${uebrig[*]}" "rm <link>, ohne Schrägstrich am Ende"
fi

# --- T2-06 ------------------------------------------------------------------
ueberschrift "T2-06 Offboarding"

if existiert passwd oweber; then
	fehler "Das Konto oweber existiert noch" "erst Dateien übergeben und archivieren, dann userdel -r"
else
	ok "Das Konto oweber ist gelöscht"
fi

if [[ -e "$wurzel/home/oweber" ]]; then
	fehler "/home/oweber existiert noch" "userdel ohne -r verwendet?"
else
	ok "/home/oweber ist gelöscht"
fi

probleme="$(probleme_pfad /srv/archiv root root 700)"
if [[ -z "$probleme" ]]; then
	ok "/srv/archiv (root:root, 700)"
else
	fehler "/srv/archiv: $(zeile <<<"$probleme")" "Archive enthalten vertrauliche Daten, nur root darf hinein"
fi

archiv=/srv/archiv/oweber-home.tar.gz
if [[ ! -f "$wurzel$archiv" ]]; then
	fehler "$archiv fehlt"
elif ! inhalt="$(tar -tzf "$wurzel$archiv" 2>/dev/null)"; then
	fehler "$archiv ist kein gültiges gzip-komprimiertes tar-Archiv" "Option -z beim Packen vergessen?"
elif grep -Eq '(^|/)home/oweber/notizen\.txt$' <<<"$inhalt"; then
	ok "$archiv enthält das Heimatverzeichnis von oweber"
else
	fehler "$archiv enthält home/oweber/notizen.txt nicht" "tar -tzf $archiv zeigt den Inhalt"
fi

datei=/srv/firma/buchhaltung/jahresabschluss-2026.txt
probleme="$(probleme_pfad "$datei" pkrause buchhaltung -)"
if [[ -z "$probleme" ]]; then
	ok "$datei gehört pkrause:buchhaltung"
else
	fehler "$datei: $(zeile <<<"$probleme")" "sudo chown pkrause <datei>"
fi

# Dateien unter /srv, deren UID zu keinem Konto gehört (wie find -nouser,
# aber über $etc/passwd, damit es auch im Testsystem funktioniert)
declare -A uids
while read -r uid; do
	uids[$uid]=1
done < <(cut -d: -f3 "$etc/passwd")
herrenlos=()
if [[ -d "$wurzel/srv" ]]; then
	while read -r uid name; do
		[[ -n "${uids[$uid]}" ]] || herrenlos+=("/srv/$name (UID $uid)")
	done < <(find "$wurzel/srv" -mindepth 1 -printf '%U %P\n')
fi
if [[ ${#herrenlos[@]} -eq 0 ]]; then
	ok "Unter /srv gibt es keine Dateien ohne existierenden Besitzer"
else
	fehler "Ohne Besitzer: ${herrenlos[*]:0:5}" "sudo find /srv -nouser, dann mit chown übergeben"
fi

for testkonto in utest vtest; do
	existiert passwd "$testkonto" && info "Profi: Das Testkonto $testkonto existiert noch, bitte mit userdel -r löschen"
done
[[ -e "$wurzel/root/wiederherstellung" ]] &&
	info "Erweiterung: /root/wiederherstellung existiert noch, bitte nach Profi löschen"

# --- Ergebnis ---------------------------------------------------------------
echo
if [[ $bestanden -eq $gesamt ]]; then
	printf '%s%s%d von %d Prüfungen bestanden, Tag 2 abgenommen.%s\n' \
		"$fett" "$gruen" "$bestanden" "$gesamt" "$normal"
else
	printf '%s%d von %d Prüfungen bestanden.%s\n' "$fett" "$bestanden" "$gesamt" "$normal"
fi
