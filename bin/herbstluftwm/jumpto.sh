#!/usr/bin/env zsh
# cycle through windows or processes matching "$@"

hc() { ${herbstclient_command:-herbstclient} "$@" ;}

# Find potential windows ids by window title
winids=($(wmctrl -l | grep -i "$@" | cut -d\  -f 1 | sed -e 's/0x0/0x/'))

# If no window title matched, find windows ids by matching process names
[ -z "$winids" ] && winids=($(wmctrl -pl | grep $(pidof -s "$@") | cut -d\  -f 1 | sed -e 's/0x0/0x/'
))

# If no process name matched, bail out
[ -z "$winids" ] && { notify-send "No window \"$@\" found..."; exit 1 }

# Find currently focused window within list of windows ids
winid_idx=$(( 1 + ${winids[(i)$(herbstclient attr clients.focus.winid)]} ))
[ $winid_idx -gt $#winids ] && winid_idx=1

hc jumpto $winids[$winid_idx]
