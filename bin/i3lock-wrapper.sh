#!/bin/sh
revert() {
	# TODO: parse output of xset q
  xset dpms 0 0 0
}

if [ "$1" = "-b" ] && nmcli con show --active | grep -q dsn5; then
	msg="Screenlock deactivated because we are at home."
	logger $msg
	echo $msg
	exit 0
fi

trap revert HUP INT TERM
pactl set-sink-mute 0 1
# rfkill block all
xset +dpms dpms 10 10 10
[ $(herbstclient list_monitors | wc -l) = 1 ] && herbstclient use log
i3lock --nofork --beep --color ff0000 --show-failed-attempts --ignore-empty-password
# TODO:
# -add i3-nag/dmenu to rf unblock / toggle mute
# -re-attach HDMI?
revert
