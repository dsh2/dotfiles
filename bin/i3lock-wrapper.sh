#!/bin/sh
revert() {
  xset dpms 0 0 0
}
trap revert HUP INT TERM
pactl set-sink-mute 0 1
rfkill block all
xset +dpms dpms 5 5 5
herbstclient use log
i3lock --nofork --beep --color ff0000 --show-failed-attempts --ignore-empty-password
# TODO:
# -add i3-nag/dmenu to rf unblock?
# -re-attach HDMI?
revert
