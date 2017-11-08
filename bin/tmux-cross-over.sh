#!/usr/bin/env zsh

SESSIONS=(${=$(tmux list-sessions -F "#{session_name}")})
CLIENTS=(${=$(tmux list-clients -F "#{client_name}")})

if [ ${#SESSIONS} != 2 -o ${#CLIENTS} != 2 ]; then
    if [ $1 != "--force" ]; then
	print error: Need exaclty two tmux clients and two tmux sessions. Add --force to override.
	exit
    fi
fi

SWITCH=(1 2)
tmux list-clients -F "#{client_session}" | head -1 | grep -q $SESSIONS[1] && SWITCH=(2 1)

tmux switch-client -c $CLIENTS[1] -t $SESSIONS[SWITCH[1]]
tmux switch-client -c $CLIENTS[2] -t $SESSIONS[SWITCH[2]]
