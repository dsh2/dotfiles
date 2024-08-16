#!/bin/sh -x
[ -n "$1" ] && TARGET_TTY="-t $1"
tmux select-pane $TARGET_TTY -P bg=\#$(hexdump -n 3 -e \"%02x\" /dev/urandom | tr abdef 110) 2>/dev/null
exit 0
