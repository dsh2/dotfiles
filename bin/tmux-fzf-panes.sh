#!/usr/bin/env zsh

[[ $1 = "--all" ]] && {
	all="-S -"
	print -u2 "Capturing ALL history of all panes..."
}

typeset -A tmux_pane_commands=(
    $(tmux list-panes -aF '#{pane_id} #{pane_current_command}')
)

me=$(tmux display-message -pF '#{pane_id}')
[[ -z $me ]] && { print -u2 "Failed to find me."; exit 1; }

selection=$(
	foreach pane command in ${(kv)tmux_pane_commands}; do

		# [[ $command =~ "(sudo|nvim|vim|top|htop|r2|ranger)" ]] && {
		# 	print -u2 "\rSkipping pane $pane due to interactive content (\"$command\")"
		# 	continue
		# }

		[[ $pane = $me ]] && {
			# print -u2 "\rSkipping me..."
			continue
		}

		# TODO: tmux occassionally report about valid pane_ids not to be found.
		print -u2 "\rCapturing pane $pane running \"$command\"..."
		tmux capture-pane -pe $=all -t $pane 2> /dev/null |
			awk "{a[NR]=sprintf(\"%s:%s:%.5i: %s\",\"$command\",\"$pane\",NR,\$0)} END {while (NR) print a[NR--]}"
	done |
		fzf --ansi \
			--preview "echo {2..}" \
			--preview-window up:15%:wrap
) || {
	print -u2 "\rAborted..."
	exit 1
}

# set -x

selection=(${(@s|:|)selection})
new_pane=$selection[2]
new_line=$selection[3]

my_height="$(tmux display-message -t $new_pane -pF '#{pane_height}')"
my_history_size="$(tmux display-message -t $new_pane -pF '#{history_size}')"

tmux switch-client -t $new_pane
pane_copy_cmd=(tmux send-keys -t $new_pane -X)
$pane_copy_cmd cancel 2>/dev/null
tmux copy-mode -t $new_pane
[[ -v all ]] && {
	history_line=$(( my_history_size - new_line + 1  ))
	$pane_copy_cmd goto-line $history_line
	new_line=$(( new_line - my_history_size + 2 ))
	(( new_line < 0 )) && new_line=1
}
$pane_copy_cmd top-line
while (( --new_line )); do $pane_copy_cmd cursor-down; done

for _ in $( seq 3 ); do
	$pane_copy_cmd select-line ; sleep 0.09
	$pane_copy_cmd clear-selection ; sleep 0.03
done
$pane_copy_cmd start-of-line
