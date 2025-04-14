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
	xmodmap -e "keycode $(xmodmap -pk | awk '/Print/ {print $1}') = Super_L" -e "add mod4 = Super_L" ; echo "PrintScreen remapped to Super_L ; done"
	msg "Reverted locking settings."
}

trap revert HUP INT TERM
# pactl set-sink-mute $(pacmd info | sed -nE 's/Default sink name: (.*)/\1/'p) 1
for s in $(pactl list short sinks | cut -f 1); do pactl set-sink-mute $s 0 ; done
# In single screen setups chose innocuous screen after unlock
[ $(herbstclient list_monitors | wc -l) = 1 ] && herbstclient use log
# i3-msg workspace --no-auto-back-and-forth 0:log
# TODO: --no-auto-back-and-forth does not seem to work
# i3-msg workspace 0:log
i3-msg workspace desktop
xset +dpms dpms 10 10 10 
pstree -ps $$ | logger
# rfkill block all
msg "Locking screen... (no fork)"
[ -r /tmp/i3lock.png ] && show_image="-i /tmp/i3lock.png"
i3lock --nofork --beep --color ff0000 --show-failed-attempts --ignore-empty-password $show_image
pkill -USR1 dunst
msg "Screen unlocked."
revert
