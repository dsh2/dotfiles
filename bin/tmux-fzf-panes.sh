#!/usr/bin/env zsh

[[ $1 = "--all" ]] && {
	all="-S -"
	# print -u2 "Capturing ALL history of all panes..."
}

tmux_pane_commands=( ${(f)"$(tmux list-panes -aF ' #{pane_id} #{session_name} #{window_name} #{pane_current_command} ')"} )

me=$(tmux display-message -pF '#{pane_id}')
[[ -z $me ]] && { print -u2 "Failed to find me."; exit 1; }

fzf=$(
	for id session window cmd in ${(z)tmux_pane_commands}; do

		[[ $id = $me ]] && continue

		# [[ $cmd =~ "(sudo|nvim|vim|top|htop|r2|ranger)" ]] && {
		# 	print -u2 "\rSkipping pane $pane due to interactive content (\"$command\")"
		# 	continue
		# }

		# print -u2 "\rCapturing pane $pane running \"$command\"..."
		# apt-get install --fix-missing -y colorized-logs
		# sed -e 's/\x1b\[[0-9;]*m//g' |
		# ansi2txt |
		tmux capture-pane -p $=all -t $id |
			awk "{a[NR] = sprintf( \"%s\t%s\t%s\t%s\t%.5i\t%s\", \"$session\", \"$window\", \"$cmd\", \"$id\", NR, \$0 ) } END {while (NR) print a[NR--]}"
	done |
		fzf \
			--preview "echo {6..}" \
			--preview-window up:15%:wrap
) || {
	print -u2 "\rAborted..."
	exit 1
}

# set -x

typeset -p fzf
fzf=(${(s|	|)fzf})
typeset -p fzf
new_pane=$fzf[4]
new_line=$fzf[5]

# Swtich to selected pane
tmux switch-client -t $new_pane

# Go to selected line
pane_copy_cmd() { tmux send-keys -t $new_pane -X $* }
pane_copy_cmd cancel
tmux copy-mode -t $new_pane

history_size=$( tmux display-message -t $new_pane -pF '#{history_size}' )
height=$( tmux display-message -t $new_pane -pF '#{pane_height}' )

[[ -v all ]] && 
	new_line=$(( history_size - new_line + 1 )) ||
	new_line=$(( height - new_line ))
pane_copy_cmd goto-line $new_line
pane_copy_cmd top-line
pane_copy_cmd scroll-middle

# exit 12
for _ in $( seq 5 ); do
	pane_copy_cmd select-line ; sleep 0.2
	pane_copy_cmd clear-selection ; sleep 0.06
done
pane_copy_cmd start-of-line
