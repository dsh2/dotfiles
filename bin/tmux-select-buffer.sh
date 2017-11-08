#!/bin/sh
TMUX_BUFFER=$(tmux list-buffers | tr : \\t | fzf -n 4 | cut -f 1) 
[ -n "$TMUX_BUFFER" ] && tmux paste-buffer -b$TMUX_BUFFER
exit 0
