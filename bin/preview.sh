#!/bin/zsh

# set -x

[[ $# != 2 ]] && { print "Usage: preview.sh output_dir query"; exit 1; }

# print "cmd_line: $@"
# printenv | \grep --color FZF

[ -z $1 ] || cd $1 || { print "Output directory \"$1\" not accessible"; exit 1; }

[ -r command_oneline ] || {
	print "No command found in \"$1\". (pwd=$( pwd ))"
	ls -al
	exit 1
}

{ 
	declare -a tmux=()
	tmux+=$( < tmux_session_name )
	tmux+=$( < tmux_window_name ) 
	tmux+=$( < tmux_pane_title ) 
	tmux+=$( < tmux_pane_id ) 
	print "TMUX: ${(j./.)tmux}" 
} 2>/dev/null
print -r "COMMAND: $( grep --color=always --fixed-strings -- ${(q)2} command_oneline )"
print -r "COMMAND: $( cat command_oneline )"
ecat() { print -n "$1: " ; if [ -r $1 ]; then cat $1; else print "[NO $1]"; fi }
ecat exit_code
ecat zsh_history_id
declare output=$1/output.gz
[[ -r $output ]] || { print "OUTPUT: No output captured." ; exit 0 ; }
width=${FZF_PREVIEW_COLUMNS:-${COLUMNS:-80}}
# typeset -p width
[[ -s $output ]]  || exit 0
printf '%*s\n' "$width" '' | tr ' ' '-'
zcat $output
