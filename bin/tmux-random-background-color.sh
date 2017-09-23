#!/bin/sh
tmux select-pane -P bg=\#$(hexdump -n 3 -e \"%02x\" /dev/urandom | tr abdef 110)
