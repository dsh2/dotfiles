#!/usr/bin/env zsh

typeset -A tmux_pane_commands=(
    $(tmux list-panes -aF '#{pane_id} #{pane_current_command}')
)
typeset -R 5 pane 
foreach pane command in ${(kv)tmux_pane_commands}; do 
    if [[ ! $command =~ "(sudo|vim|lnav|htop|r2|ranger)" ]]; then
	# TODO: tmux occassionally report about valid pane_ids not to be found. Fix that.
	tmux capture-pane -peJS - -t $pane 2> /dev/null \
	| awk "{a[NR]=sprintf(\"%s(%s):%.5i:%s\",\"$pane\",\"$command\",NR,\$0)}
		END {while (NR) print a[NR--]}" 
    fi
done \
    | fzf --ansi 
