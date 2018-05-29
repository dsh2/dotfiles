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

# Sort winids according to last usage time
typeset -A timed_winids
for winid in $winids; do 
    timed_winids+=( $(xprop -id $winid _NET_WM_USER_TIME 2>/dev/null) $winid)
done
# HACK: It seems zsh cannot sort associative arrays on its own... 
for k v ("${(@kv)timed_winids}") combined_timed_winids+=($k$'\n'$v)
echo -ne N:; print -rl -- $combined_timed_winids
combined_timed_winids=(${${(@On)combined_timed_winids}#*$'\n'})
echo -ne S:; print -rl -- $combined_timed_winids

# Find currently focused window within list of windows ids
winid_idx=${combined_timed_winids[(i)$(herbstclient attr clients.focus.winid)]} 
print i: $winid_idx
[ $winid_idx -gt $#combined_timed_winids ] && winid_idx=1
print i: $winid_idx

# hc jumpto $combined_timed_winids[$winid_idx]
