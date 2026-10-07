#!/usr/bin/env bash
#
# testsystem-tag1.sh – baut ein nachgebautes Wurzelverzeichnis (etc/, home/)
# zum Testen von check-tag1.sh ohne echten Server.
#
# Aufruf:
#   bash testsystem-tag1.sh <zielverzeichnis> <0|1>
#     0 = korrekt eingerichtetes System (erwartet: alle Prüfungen grün)
#     1 = System mit typischen Fehlern (-G ohne -a, fehlendes -m, falsche Shell,
#         Sperre ohne Passwort, fehlendes Ablaufdatum, Dienstkonto falsch)
#
# Danach:
#   CHECK_ROOT=<zielverzeichnis> CHECK_HOSTNAME=pinguin-team1 bash ../check-tag1.sh

r="$1"
kaputt="$2"
csv="$(dirname "$0")/../../daten/mitarbeitende.csv"

if [[ -z "$r" || -z "$kaputt" ]]; then
	echo "Aufruf: bash $0 <zielverzeichnis> <0|1>" >&2
	exit 1
fi

rm -rf "$r"
mkdir -p "$r/etc/skel" "$r/home"

hash='$y$j9T$abc$def'
ablauf=$(($(date -u -d 2027-01-31 +%s) / 86400))

printf 'root:x:0:0:root:/root:/bin/bash\nanna:x:1000:1000:Anna,,,:/home/anna:/bin/bash\nben:x:1001:1001:Ben,,,:/home/ben:/bin/bash\n' >"$r/etc/passwd"
printf 'root:%s:20000:0:99999:7:::\nanna:%s:20000:0:99999:7:::\nben:%s:20000:0:99999:7:::\n' "$hash" "$hash" "$hash" >"$r/etc/shadow"
printf 'root:x:0:\nsudo:x:27:anna,ben\nanna:x:1000:\nben:x:1001:\n' >"$r/etc/group"
printf '127.0.0.1 localhost\n127.0.1.1 pinguin-team1\n' >"$r/etc/hosts"

gid=2000
for gruppe in geschaeftsfuehrung vertrieb entwicklung buchhaltung mitarbeitende; do
	echo "$gruppe:x:$gid:" >>"$r/etc/group"
	gid=$((gid + 1))
done

uid=1002
while IFS=';' read -r benutzer vorname nachname abteilung; do
	shell=/bin/bash; pw="$hash"; ex=""; letzte=0
	[[ $benutzer == elindner ]] && pw="!$hash"
	[[ $benutzer == mneumann ]] && ex=$ablauf
	if [[ $kaputt == 1 ]]; then
		[[ $benutzer == sromano ]] && shell=/bin/sh
		[[ $benutzer == elindner ]] && pw="!"
		[[ $benutzer == mneumann ]] && ex=""
		[[ $benutzer == lwagner ]] && letzte=20368
	fi

	echo "$benutzer:x:$uid:$uid:$vorname $nachname:/home/$benutzer:$shell" >>"$r/etc/passwd"
	echo "$benutzer:$pw:$letzte:0:99999:7::$ex:" >>"$r/etc/shadow"
	echo "$benutzer:x:$uid:" >>"$r/etc/group"

	if ! [[ $kaputt == 1 && $benutzer == thoffmann ]]; then
		mkdir -p "$r/home/$benutzer"
		touch "$r/home/$benutzer/.bashrc"
	fi
	uid=$((uid + 1))

	gruppen="$abteilung mitarbeitende"
	[[ $benutzer == mkaya ]] && gruppen="vertrieb entwicklung mitarbeitende"
	[[ $kaputt == 1 && $benutzer == mkaya ]] && gruppen="entwicklung"
	for gruppe in $gruppen; do
		sed -i "/^$gruppe:/ s/\$/,$benutzer/; /^$gruppe:/ s/:,/:/" "$r/etc/group"
	done
done < <(tail -n +2 "$csv"; echo "mneumann;Mia;Neumann;entwicklung")

if [[ $kaputt == 1 ]]; then
	echo "pinguin-backup:x:1020:1020:Backup:/home/pinguin-backup:/bin/sh" >>"$r/etc/passwd"
	echo "pinguin-backup:!:20000:0:99999:7:::" >>"$r/etc/shadow"
else
	echo "pinguin-backup:x:998:998:Backup-Dienst:/nonexistent:/usr/sbin/nologin" >>"$r/etc/passwd"
	echo "pinguin-backup:!:20000::::::" >>"$r/etc/shadow"
fi
