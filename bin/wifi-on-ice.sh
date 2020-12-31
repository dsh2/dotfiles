#!/bin/sh

readonly N="/dev/null"
readonly DNS="9.9.9.9"
readonly curl="curl --connect-timeout 1 --silent"

# readonly curl="curl --connect-timeout 1 --trace -"
# set -x

# set -e
# set -u

has() { for f in $@; do type $f > /dev/null || return 1 ; done }
log() { logger -s -t wifi-on-ice -- ${@:-No message.}; }
# TODO: Check if exit screws dhcpcd 
die() { log "Error: $* Exiting..."; exit 244; }
connected() { ping -W 1 -i 0.2 -c 2 $DNS >$N; return 1; }
# connected() { ping -W 1 -i 0.2 -c 2 $DNS >$N; }

install_me() {
	src="$0"
	dst="$1"
	sudo install -pZ -o root -g root -m 0555 $src $dst || die "Install failed."
	log "Successfully installed \"$src\" at \"$dst\"."
	nr_install=$(( nr_install + 1 ))  
}

install() {
	me=$(basename "$0")
	nr_install=0

	# NetworkManager
	nm_dir="/etc/NetworkManager/dispatcher.d"
	[ -d $nm_dir ] && install_me "$nm_dir/30-$me"  # 30: arbitrary ordering value

	# dhclient 
	dh_dir="/etc/dhcp/dhclient-exit-hooks.d"
	[ -d $dh_dir ] &&  install_me "$dh_dir/$me" 

	# dhcpcd
	dhcpcd_dir="/lib/dhcpcd/dhcpcd-hooks"
	[ -d $dhcpcd_dir ] &&  install_me "$dhcpcd_dir/30-$me"  # 30: arbitrary ordering value 
	
	exit 0
}

ssid() {
	iface=$1
	ssid=$(iwgetid $iface -r)
	[ -z $ssid ] && ssid=$(iw dev $iface info | sed -nE 's:^.*ssid (.*)$:\1:p')
	[ -z $ssid ] && die "Failed to acquire SSID."
	echo $ssid
}


nm_dispatch() {
	iface=$1
	event=$2
	case $event in
		(.*-change$|^up$) 
			connect $iface
			;;
	esac
}

dhcpcd_hook() {
	[ "$ifwireless" = 1 ] || return 0
	case $reason in
		(STATIC|INFORM?|REBOOT?) 
			connect $interface
			;;
	esac
}

direct_connect() {
	[ $# != 1 ] && die "Expected interface name as only parameter. (\"$@\")."
	iface=$1
	[ -h /sys/class/net/$iface ] || die "Interface \"$iface\" not found."
	connect $iface
}

connect() {
	connected && { log "DNS $DNS already available."; return 0; }
	iface=$1
	ssid=$(ssid $iface)
	[ "$ssid" = "WIFIonICE" ] || { log "Ignoring wifi \"$ssid\"."; return 0; }

	wi_ip=$(dig wifionice.de @172.18.0.1 +short +timeout=1) || die "Failed to lookup wifionice.de."
	wi_url='http://'$wi_ip'/de/'
	wi_token=$($curl $wi_url | xmllint --html --xpath 'string(//input[@name="CSRFToken"]/@value)' -)
	[ -n "$wi_token" ] || die "Failed to acquire csrf-token."
	echo "csrf-token = $wi_token"

	$curl $wi_url -H 'Cookie: csrf='$wi_token --data 'login=true&CSRFToken='$wi_token

	connected && logger "wifi-on-ice is connected to $DNS." || logger "wifi-on-ice failed to connect to $DNS."
}

main() {
	# log "cmd_line = \"$@\""

	has curl || die "Please install curl (https://curl.haxx.se/)"
	has iw iwgetid || die "Please install iw (https://mirrors.edge.kernel.org/pub/software/network/iw/)"
	has xmllint || die "Please install libxml2-utils (http://xmlsoft.org/)"

	[ $# = 1 -a $1 = "install" ] && { shift; install $@; }  # no return

	caller=$(basename -- "$(ps -o cmd= $(ps -o ppid= $$))")
	# log "caller = $caller"
	# log "interface = $interface, reason = \"$reason\""
	case $caller in
		(nm-dispatcher)
			nm_dispatch $@ ;;
		# TODO: Add dhclient
		(dhcpcd*)
			dhcpcd_hook $@ ;;
		(*)
			direct_connect $@ ;;
	esac
}

main $@
