#!/bin/sh
msg() {
	echo i3lock: $* | ts -m '[%F %T]'
	logger --tag i3lock -- $*
}
revert() {
	# TODO: parse output of xset q
	xset dpms 0 0 3600
	~/.dotfiles/herbstluftwm/restartpanels.sh &>/dev/null
	msg "Reverted locking settings."
}

if [ "$1" = "-b" ] && nmcli con show --active | grep -q dsn5; then
	msg "Screenlock deactivated because we are at home."
	exit 0
fi

trap revert HUP INT TERM
pactl set-sink-mute $(pacmd info | sed -nE 's/Default sink name: (.*)/\1/'p) 1
# rfkill block all
xset +dpms dpms 10 10 10
# In single screen setups chose innocuous screen after unlock
[ $(herbstclient list_monitors | wc -l) = 1 ] && herbstclient use log
msg "Locking screen..."
i3lock --nofork --beep --color ff0000 --show-failed-attempts --ignore-empty-password
msg "Screen unlocked."
# TODO:
# -add i3-nag/dmenu to rf unblock / toggle mute
# -re-attach HDMI?
revert
