#!/bin/zsh

msg() {
	echo i3lock: $* | ts '[%F %T]'
	logger --tag i3lock -- $*
}

revert_lock_settings() {
	# TODO: parse output of xset q
	xset -b -c r rate 200 140 dpms 0 0 3600 s off
	setxkbmap -layout us,de -option grp:alt_caps_toggle
	xmodmap -e "keycode 94 = asciitilde asciitilde asciitilde asciitilde" 
	pkill -USR2 dunst
	xmodmap -e "keycode $(xmodmap -pk | awk '/Print/ {print $1}') = Super_L" -e "add mod4 = Super_L" ; echo "PrintScreen remapped to Super_L ; done"
	msg "Reverted locking settings."
	pkill -USR1 dunst
	dunstctl set-paused false
	msg "Screen unlocked."
}

trap revert_lock_settings HUP INT TERM

apply_lock_settings() {
	xset +dpms dpms 10 10 10 
	for s in $(pactl list short sinks | cut -f 1); do pactl set-sink-mute $s 0 ; done
	i3sock=(/run/user/$(id -u)/i3/ipc-socket.*(om[1]))
	[[ -n $i3lock ]] && { i3-msg -s $i3sock workspace BLANK }
	msg $( pstree -ps $$ )
	# rfkill block all
}

apply_lock_settings

msg "Locking screen... (no fork)"
i3oo=(
	nofork
	color=ff0000
	show-failed-attempts
	ignore-empty-password
)
i3oo+=( beep )
i3oo+=( show-keyboard-layout )
echo i3lock ${(@)i3oo/#/--}

revert_lock_settings
