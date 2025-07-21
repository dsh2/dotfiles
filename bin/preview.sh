#!/bin/zsh

# set -x

[[ $# != 2 ]] && { print "Usage: preview.sh output_dir query"; exit 1; }

# print "cmd_line: $@"
# printenv | \grep --color FZF

cd $1 || { print "Output directory \"$1\" not accessible"; exit 1; }

print -r "COMMAND: $( grep --color=always "$2" command_oneline )"
{ 
	declare -a tmux=()
	tmux+=$( < tmux_session_name )
	tmux+=$( < tmux_window_name ) 
	tmux+=$( < tmux_pane_title ) 
	tmux+=$( < tmux_pane_id ) 
	print "TMUX: ${(j./.)tmux}" 
} 2>/dev/null
print "exit code: $( < exit_code )" 
print "zsh_history_id: $( < zsh_history_id )" 
declare output=$1/output.gz
[[ -r $output ]] || { print "OUTPUT: No output captured." ; exit 0 ; }
width=${FZF_PREVIEW_COLUMNS:-${COLUMNS:-80}}
typeset -p width
printf '%*s\n' "$width" '' | tr ' ' '-'
[[ -s $output ]] && zcat $output
