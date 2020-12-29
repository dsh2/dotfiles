#!/bin/bash

readonly curl="curl --connect-timeout 1 --silent"
# readonly curl="curl --connect-timeout 1 --trace -"

# set -x
set -e
set -u

has() { for f in $@; do type $f &> /dev/null || return 1 ; done }
log() { logger -s -t wifi-on-ice -- ${@:-No message.}; }
die() { log "Error: $* Exiting..."; exit 1; }
ssid() { iwgetid $1 -r ; }

install() {
	readonly dst_dir="/etc/NetworkManager/dispatcher.d"
	[ -d $dst_dir ] || die "NetworkManager dispatcher drop-in directory not found. (\"$dst_dir\")"
	readonly dst_path=$dst_dir/$(basename $0)
	sudo cp $0 $dst_path
	sudo chown root:root $dst_path
	log "Successfully installed \"$0\" at \"$dst_path\"."
	exit 0
}

nm_dispatch() {
	readonly iface=$1
	readonly event=$2
	readonly ssid=$(ssid $iface)
	[[ -n $ssid ]] || return 
	[[ $ssid = "WIFIonICE" ]] || { log "Ignoring wifi \"$ssid\"."; exit 0; }
	[[ $event =~ (.*-change$|^up$) ]] && connect
}

connect() {
	wi_ip=$(dig wifionice.de @172.18.0.1 +short +timeout=1) || die "Failed to lookup wifionice.de."
	wi_url='http://'$wi_ip'/de/'
	wi_token=$($curl $wi_url | xmllint --html --xpath 'string(//input[@name="CSRFToken"]/@value)' -)
	[[ -n $wi_token ]] || die "Failed to acquire csrf-token."
	echo "csrf-token = $wi_token"

	$curl $wi_url -H 'Cookie: csrf='$wi_token --data 'login=true&CSRFToken='$wi_token

	ping -W 1 -i 0.2 -c 2 9.9.9.9 && logger "wifi-on-ice is connected to CloudFlare." || logger "wifi-on-ice failed to connect to CloudFlare."
}

main() {
	# log "cmd_line = \"$@\""

	has curl || die "Please install curl (https://curl.haxx.se/)"
	has iw || die "Please install iw (https://mirrors.edge.kernel.org/pub/software/network/iw/)"
	has xmllint || die "Please install libxmls (https://xmlsoft.org/)"
	
	[[ $# = 1 && $1 = "install" ]] && install  # no return

	readonly caller_name=$(basename -- "$(ps -o cmd= $(ps -o ppid= $$))")
	# log "caller = $caller_name"
	case $caller_name in
		("nm-dispatcher")
			nm_dispatch $@ ;;
		(*)
			[[ $# > 0 ]] && log "Ignoring command line (\"$@\")."
			connect ;;
	esac
}

main $@
