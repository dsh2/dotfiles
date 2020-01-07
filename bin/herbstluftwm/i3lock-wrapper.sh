#!/bin/sh
msg() {
	echo i3lock: $* | ts '[%F %T]'
	logger --tag i3lock -- $*
}
revert() {
	# TODO: parse output of xset q
	xset -b -c r rate 200 140 dpms 0 0 3600 s off
	setxkbmap -layout us,de -option grp:alt_caps_toggle
	xmodmap -e "keycode 94 = asciitilde asciitilde asciitilde asciitilde" 
	~/.dotfiles/herbstluftwm/restartpanels.sh &>/dev/null
	pkill -USR2 dunst
	msg "Reverted locking settings."
}

if [ "$1" = "-b" ] && nmcli con show --active | grep -qE '(dsn3|dsn5)'; then
	msg "Screenlock NOT activated because we are at home."
	exit 0
fi

trap revert HUP INT TERM
pactl set-sink-mute $(pacmd info | sed -nE 's/Default sink name: (.*)/\1/'p) 1
# rfkill block all
xset +dpms dpms 10 10 10
# In single screen setups chose innocuous screen after unlock
[ $(herbstclient list_monitors | wc -l) = 1 ] && herbstclient use log
i3-msg workspace 0:log
pkill -USR1 dunst
msg "Locking screen..."
xset +dpms dpms 5 5 5
pstree -ps $$ | logger
i3lock --nofork --beep --color ff0000 --show-failed-attempts --ignore-empty-password
msg "Screen unlocked."
# TODO:
# -add i3-nag/dmenu to rf unblock / toggle mute
# -re-attach HDMI?
revert
