#!/bin/sh
# TODO: Add mute, rfkill, standard workspace, etc.?
revert() {
  xset dpms 0 0 0
}
trap revert HUP INT TERM
pactl set-sink-mute 0 1
rfkill block all
xset +dpms dpms 5 5 5
i3lock -n -c ff0000 -f -e
# TODO:
# -add i3-nag to rf unblock?
# -re-attach HDMI?
revert
