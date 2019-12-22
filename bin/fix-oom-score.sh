#!/usr/bin/zsh

for pid in /proc/[0-9]*; do
    local prog=$(cat $pid/comm) || continue
    pid=${pid##/proc/}
    local n=0
    case "$prog" in
	chrome)
	    n=300 ;;
	zsh|sh|bash|dos2unix|xsel)
	    n=100 ;;
	dunst|vim|nvim)
	    n=-200 ;;
	tmux:\ server|sshd|systemd-*)
	    n=-1000 ;;
    esac
    if (( n != 0 )); then
	echo -n "$prog: "
	choom -n $n -p $pid
    else
	echo Skipping \"$prog\"
    fi
done
