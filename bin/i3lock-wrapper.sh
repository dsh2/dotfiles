#!/bin/zsh

msg() {
	echo i3lock: $* | ts '[%F %T]'
	logger --tag i3lock -- $*
}

revert_lock_settings() {
	dunstctl set-paused false
	xset -b -c r rate 200 140 dpms 0 0 3600 s off
	xmodmap -e "keycode 94 = asciitilde asciitilde asciitilde asciitilde" 
	xmodmap -e "keycode $(xmodmap -pk | awk '/Print/ {print $1}') = Super_L" -e "add mod4 = Super_L" ; echo "PrintScreen remapped to Super_L ; done"
	msg "Reverted locking settings."
	pkill -USR1 dunst
	dunstctl set-paused false
	msg "Screen unlocked."
}

trap revert_lock_settings HUP INT TERM

mute_audio() {
	# TODO: Also mute sources?
	pactl list short sinks | while read serial name driver spec _; do
	[[ $name == *38_18_4C_AE_B3_DA* ]] && {
			echo "Not Muting P3: $name ($serial)"
			continue
		}
		echo "Muting $name ($serial)"
		pactl set-sink-mute $serial 1
	done
}

apply_lock_settings() {
	mute_audio
	dunstctl set-paused true
	xset +dpms dpms 10 10 10 
	# TODO: Understand why sleep is necessary - or how to explicitly switch to us layout
	setxkbmap us; sleep 0.9 ; setxkbmap us,de
	i3sock=(/run/user/$(id -u)/i3/ipc-socket.*(om[1]))
	[[ -n $i3sock ]] && { i3-msg -s $i3sock workspace BLANK-$RANDOM }
	msg $( pstree -ps $$ )
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

i3lock ${(@)i3oo/#/--}
msg "Screen unlocked."

revert_lock_settings
