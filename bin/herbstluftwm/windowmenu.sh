#!/usr/bin/env bash
set -e

action_list() {
    local a="$1"
    local current_tag=$(herbstclient attr tags.focus.name)
    # "$a" "Close" herbstclient close
    # "$a" "Toggle fullscreen" herbstclient fullscreen toggle
    # "$a" "Toggle pseudotile" herbstclient pseudotile toggle
	herbstclient attr clients.focus | tail --lines=+6 | 
		while IFS=\= read prop val; do 
			"$a" "$prop $val" sh -c "echo $val | xclip -selection clipboard -in"
		done
	# TODO: 
	# -open TERM vim $(xprop)
	# -check xclip instead of parcellite
    for tag in $(herbstclient complete 1 move); do
	if [ "$tag" != "$current_tag" ]; then
	    "$a" "Move to '$tag'" herbstclient move "$tag"
	    "$a" "Move to '$tag' and focus" herbstclient chain I move "$tag" I use "$tag"
	fi
    done
}

exec_entry() {
	if [ "$1" = "$result" ] ; then
		shift
		"$@"
		exit 0
	fi
}

print_menu() {
    echo "$1"
}

title=$(herbstclient attr clients.focus.title)
title=${title//&/&amp;}
winid=$(herbstclient attr clients.focus.winid)
pid=$(herbstclient attr clients.focus.pid)
rofiflags=(
    -p ""
    -mesg "$winid, $pid: $title"
    -columns 1
    # -password
    -location 1
    # -width 33
    -lines 30
    # -fake-transparency
    # -sidebar-mode
    # -fixed-num-lines
    -sidebar-mode
    -no-custom
    -monitor -1
    # -fullscreen
    # -x 1
    # -u 2
    # -normal-window 
    # -theme theme
)
result=$(action_list print_menu | rofi -i -dmenu "${rofiflags[@]}")
[ $? -ne 0 ] && exit 0

action_list exec_entry
