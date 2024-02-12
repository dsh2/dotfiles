# vim: set foldmethod=marker foldlevel=0 ts=4 sw=4
# set -x

autoload -Uz add-zsh-hook
[[ $(uname -a) =~ Microsoft ]] && { unsetopt bgnice; umask 077; }

RUNNING_SHELL=$(readlink /proc/$$/exe)
# TODO: Think about run-away loops
while [ -L $SHELL ]; do SHELL=$(readlink $SHELL); done
if [[ $RUNNING_SHELL != $SHELL ]]; then
    echo "WARNING: Fixing shell mismatch (RUNNING_SHELL = \"$RUNNING_SHELL\", SHELL = \"$SHELL)\""
    SHELL=$RUNNING_SHELL
fi

zsh_source()
{
	# TODO: check if writeable for others than us
	local quiet
	[[ $1 = -q ]] && { quiet=1; shift; }
	[[ ! -r $@ ]] && { (( quiet )) || "zsh_source: "$@" not found. "; return 1; }
	source $@
}

has() {
  local verbose=false
  if [[ $1 == '-v' ]]; then
	verbose=true
	shift
  fi
  for c in "$@"; do 
	c="${c%% *}"
	if ! command -v "$c" &> /dev/null; then
	  [[ "$verbose" == true ]] && err "$c not found"
	  return 1
	fi
  done
}

bash_source() {
  alias shopt=':'
  alias _expand=_bash_expand
  alias _complete=_bash_comp
  emulate -L sh
  setopt kshglob noshglob braceexpand
  # TODO: check if writeable for others than us
  [[ ! -r $@ ]] && return
  source "$@"
}
# bash_source ~/lib/azure-cli/az.completion
# bash_source ~/.dotfiles/zsh/uftrace-completion.sh
# export pip_zsh_cache="~/.pip.zsh"
# [[ -r $pip_zsh_cache ]] || pip completion --zsh > $pip_zsh_cache
# TODO: What is wrong with redirection to filename coming from variables
[[ -r ~/.pip.zsh ]] || pip completion --zsh > ~/.pip.zsh
eval "$(cat ~/.pip.zsh)"

in_array() { (( ${${(P)2}[(i)$1]} <= ${#${(P)2}} )) }

setopt prompt_subst
setopt prompt_cr
# TODO: try to understand why SP outputs term seqs even when no partial line is present
setopt noprompt_sp
# setopt prompt_sp
# export PROMPT_EOL_MARK='%{$fg_no_bold[red]%}<< \n missing'
# export PROMPT_EOL_MARK='%{$fg_no_bold[red]%}<< partial line (\n missing)'
# incomplete line
export PROMPT_EOL_MARK='%{$fg_no_bold[red]%}<< partial line'
unset PROMPT_EOL_MARK
autoload -Uz vcs_info
autoload -U colors && colors
zstyle ':vcs_info:*' actionformats '%%F{136}[%F{240}%b%F{136}|%F{240}%a%F{136}]%f '
zstyle ':vcs_info:*' formats '%F{136}[%F{166}%b%F{136}]%f '
zstyle ':vcs_info:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' disable bzr tla
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info

# Main prompt {{{
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u2500:)}'
LINE_SEPARATOR=%F{211}$'${(r:$((COLUMNS - 1))::-:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{179}$'${(r:$((COLUMNS - 1))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 0))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u257c:)}%{$reset_color%}'

PS1=''
# PS1+='​'
PS1+=$LINE_SEPARATOR					# Add horizontal separator line
# PS1+=$'\r'$'\f'
PS1+=$'\n'
PS1+='%F{240}%(1j.[%{$fg_no_bold[red]%}J=%j%F{240}].)'	# Add number of jobs - if any
PS1+='%F{240}%(2L.[l=%{$fg_no_bold[red]%}%L%F{240}].)'	# Add shell level iff above 1
psvar[1]=$SSH_TTY
PS1+='%F{255}[%F{244}'
PS1+='%(!.$fg_no_bold[red]ROOT%F{255}.%n)'		# Add user name
PS1+='%(1V.%{$fg_no_bold[red]%}@%m.)'			# Add host name for ssh connections
PS1+='%F{255}] '
PS1+='%F{136}%~ '					# Add current directory
PS1+='${vcs_info_msg_0_}'				# Add vcs info

zle_check_send_break() {
  # psvar[2]=$(( $zsh_preexec ? "" : "break" ))
  if (($zsh_preexec)); then
    psvar[2]=
    zsh_preexec=0
  else
    psvar[2]=break
  fi
}
add-zsh-hook precmd zle_check_send_break
zle_prepare_send_break_check() { zsh_preexec=1 }
add-zsh-hook preexec zle_prepare_send_break_check
PSVAR+=$ZLE_LINE_ABORTED
PS1+='%(0?..%(2V..%{$fg_bold[red]%}[err=%F{255}%?%{$fg_bold[red]%}] ))'	# Add exit status of last job
# PS1+='%(0?..%($ZLE_LINE_ABORTED..%{$fg_bold[red]%}[err=%F{255}%?%{$fg_bold[red]%}])) '	# Add exit status of last job
[[ -n $ns ]] && psvar[3]=$ns

PS1+='%(3V.%F{255}[%{$fg_no_bold[red]%}$ns%F{255}] .)'  # Add netns
# PS1+='😎 '						    # Add user status
# PS1+='💙 '						    # Add user status
# PS1+='❤️ '						    # Add user status
# PS1+='🤮 '						    # Add user status
# PS1+=' '
# PS1+='​'
      
# PS1+='(%!) '						# Add number of next shell event
# PS1='%F{5}${fg[green]}[%F{2}%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%f%# '
# PS1="%{$fg_bold[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%# "
# }}}

# Right prompt {{{
# ZLE_RPROMPT_INDENT=0
# RPS1=[%{$fg_no_bold[yellow]%}			# Set beginning of right prompt
# RPS1+=%(0?.ok.err=%{$fg_no_bold[red]%}%?)		# Add exit status of last job
# RPS1+=%(1j.%{$fg_no_bold[red]%}%j.0) # Add number of jobs - if any
# RPS1+=%{$reset_color%}]				# End of right prompt
# }}}
# Trace prompt {{{
PS4="%f%u"
# Add event history number
# PS4+=%!
# Add timestamp
# PS4+='(%D{%3.})'
# PS4+='(%T)'
PS4+='%D{%H:%M:%S.%.}'
# Add source and absolute and relative source line
PS4+='%F{255}['
PS4+='%F{136}%N%F{255}:%F{255}%I%F{240}(%F{100}%i%F{240})'
PS4+='%F{255}] '
# Add parser state
# PS4+="( %_ ) "
# Add exit status of last job
# PS4+='%(0?.%f.%{$fg_bold[red]%}[err=%F{255}%?%{$fg_bold[red]%}])'
# Make command line start at certain colum
# typeset -i ps4_output_column=50
# PS4+=$(echo -ne '\033[${ps4_output_column}D\033[${ps4_output_column}C')
# Reset color
PS4+='%f'
PS4+=' | '
export PS4
# }}}
# }}}

# Dircolors {{{
type dircolors > /dev/null && DIR_COLORS=dircolors
type gdircolors > /dev/null && DIR_COLORS=gdircolors
if [ -n $DIR_COLORS ]; then
    eval $($DIR_COLORS ~/.dotfiles/colors/dircolors-solarized/dircolors.256dark)
    # eval $($DIR_COLORS ~/.dotfiles/colors/dircolors-solarized/dircolors.ansi-light)
fi
# }}}

# History {{{
SAVEHIST=999999
HISTSIZE=$SAVEHIST
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

setopt append_history
setopt complete_aliases
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt no_bang_hist
setopt no_hup
setopt no_hist_ignore_all_dups
setopt no_hist_ignore_dups
setopt no_inc_append_history
setopt no_inc_append_history_time
setopt share_history

zsh_local_history_blacklist="(/mnt|~/mnt|^/tmp|~/src/HC/)"
zshaddhistory() {
	# Skip empty lines
	[[ -z $1 || $1 =~ (^[[:space:]]+.*$) ]] && return

	# Save line in global history
	local history_line=${1%$'\n'}
	print -sr -- $history_line

	# Save line in local history
	local local_history_dir=~/.zsh_local_history_dir/${(q)PWD}
	local local_history=$local_history_dir/history
	[[ -d $local_history_dir ]] || {
		print -- "zshaddhistory: Creating new directory to local history \"$local_history_dir\"."
		mkdir -p $local_history_dir
	}
	fc -p $local_history

	# set -x
	# Make local history visible in local directory
	# [[ -w $PWD ]]
	local local_history_link=$PWD/.zsh_local_history 
	if [[ -f $local_history_link ]]; then
		if [[ -h $local_history_link ]]; then
			# Check if directory was renamed after last update
			local target=$(stat +link $local_history_link)
			if [[ $target != $local_history ]]; then
				print -- "zshaddhistory: Updating symlink to local history \"$local_history\"."
				ln -vsfT $local_history $local_history_link
				ln -vsfT $PWD $local_history_dir/current_target
				ls -al $target
				print -- "$( date '+%F%t%T' )\t$PWD" >> $local_history_dir/targets
			fi
			# print "$( date '+%F%t%T' )\t$PWD" > $local_history_dir/targets
		else
			# TODO: Add case for regular files to move them into zsh_local_history_dir
			# print "zshaddhistory: WARNING: Local history is NOT a symlink."
			# ls -l $local_history_link
		fi
	else
		if [[ $PWD =~ $zsh_local_history_blacklist ]]; then
			print "zshaddhistory: Not creating link to local history because \"$PWD\" matches blacklist \"$zsh_local_history_blacklist\"."
		else
			print "zshaddhistory: Creating new link to local history \"$local_history\"."
			ln -vsT $local_history $local_history_link
			# Force link as link might point to a paste dir with the same name which was removed
			ln -vsfT $PWD $local_history_dir/current_target
			print "$( date '+%F%t%T' )\t$PWD" > $local_history_dir/targets
			ls -l $local_history_dir
		fi 
	fi
	# TODO: Fossil commit

	set +x

}
# }}}

PP() {
    local file=${1:-/dev/stdin}
    curl --data-binary @${file} https://paste.rs | tr -d \\n | $=XC
}

alias PPd='curl -X DELETE '

# ZLE {{{
zle_highlight=(
    default:fg=default,bg=default
    special:fg=black,bg=red
    region:standout,fg=green
    suffix:bold
    isearch:underline
    paste:underline
	comment:fg=white
)

function bindkey_func {
    zle -N $2
    # bindkey -M command $1 $2
    bindkey $1 $2
}

bindkey -e
bindkey '^[' vi-cmd-mode
bindkey -M viins '^j' vi-cmd-mode
bindkey -M vicmd '^[x' execute-named-cmd
bindkey '^?' undo
bindkey '^xr' redo
bindkey "^x;" describe-key-briefly
bindkey "^[;" set-mark-command

function repeat_immediately {
	[[ $#BUFFER -eq 0 ]] || { zle -M "Command line not empty."; return }
	# TODO: && think about something useful
	zle up-history
	zle accept-line
}
bindkey_func '^j' repeat_immediately

debug_trace_file=
[[ $debug_trace_file =~ /dev/(pts|tty)/ ]] &&  clear > $debug_trace_file
trace() { [[ -n $debug_trace_file ]] && print $$: $@ > $debug_trace_file }

typeset -i zle_old_histno=$HISTNO
function down-line-or-history-no-duplicate {
	(( zle_old_histno )) || zle_old_histno=$HISTNO
	local old_buffer=$BUFFER
	while  [[ $old_buffer == $BUFFER ]]; do
		zle down-history || break
		(( HISTNO >= zle_old_histno )) && break
	done
	local old_cursor=$zle_history_point[$HISTNO]
	[[ -n $old_cursor ]] && CURSOR=old_cursor
}
bindkey_func '^n' down-line-or-history-no-duplicate

function up-line-or-history-no-duplicate {
	(( zle_old_histno )) || zle_old_histno=$HISTNO
	local old_buffer=$BUFFER
	while (( HISTNO > 1 )) && [[ $old_buffer == $BUFFER ]]; do
		zle up-history || break
	done
	local old_cursor=$zle_history_point[$HISTNO]
	[[ -n $old_cursor ]] && CURSOR=old_cursor
}
bindkey_func '^p' up-line-or-history-no-duplicate

typeset -A zle_history_point
function accept-line-record-point {
	(( zle_old_histno )) || zle_old_histno=$HISTNO
	zle_history_point[$zle_old_histno]=$CURSOR
	zle_old_histno=0
	zle accept-line
}
bindkey_func '^m' accept-line-record-point

function repeat_immediately_second_previous {
	(( $#BUFFER )) && { zle backward-char ; return ; }
	zle up-history
	local old_buffer=$BUFFER
	while (( HISTNO > 1 )) && [[ $old_buffer == $BUFFER ]]; do
		zle up-history || return
	done
	zle accept-line
}
bindkey_func '^b' repeat_immediately_second_previous

function focus_backgroud {
    (( $#jobstates )) || { zle -M "No background jobs."; return }
    [[ $#BUFFER -eq 0 ]] || { zle -M "Command line not empty."; return }
    # TODO: Think about something useful in this case
    [[ $#BUFFER -eq 0 ]] && fg
    # TODO: Second time c-z does not work. fg in zle seems to hang / have closed input?
}
bindkey_func '^z' focus_backgroud

WORDCHARS=':*?_-.[]~=/&;!#$%^(){}<>|'
function backward_kill_default_word() {
    WORDCHARS='*?-.[]~&!#$%^(){}<>|'
    zle backward-kill-word
}
bindkey_func '\e=' backward_kill_default_word   # = is next to backspace
bindkey_func '\e-' backward_kill_default_word   # - is next to =

XP=${XP:-cat}
if pidof copyq >/dev/null; then
	XP="copyq read 0"
elif type xclip >/dev/null; then
	XP="xclip -rmlastnl -selection clipboard -out"
elif type powershell.exe > /dev/null; then
	XP="powershell.exe -command Get-Clipboard"
fi

XC=${XC:-/bin/false}
if [[ -n $DISPLAY ]]; then
	if type xclip >/dev/null; then
		XC="xclip -rmlastnl -selection clipboard -in"
	elif type xsel >/dev/null; then
		XC="xsel --clipboard --input"
	fi
else
	if type clip.exe > /dev/null; then
		XC="clip.exe"
	elif [[ -n $TMUX ]]; then
		XC="tmux load-buffer -"
	fi
fi

function kill-line-copy {
	if [[ -z $RBUFFER ]]; then
		filter_last_output
	else
		zle kill-line
		print -r -n -- $CUTBUFFER | $=XC 2> /dev/null
		zle -M "Copied content from (C-k): \"$CUTBUFFER\"" 
		
	fi
}
bindkey_func '^k' kill-line-copy

# Copy last command to xclipboard
function copy_last_command {
	zle up-history
	zle kill-whole-line
	print -r -n -- $CUTBUFFER | $=XC \
		&& zle -M "Copied last command line." \
		|| zle -M "FAILED to copy last command line. (XC=$XC)"
}
# bindkey_func '^x^k' copy_last_command
bindkey '^x^k' up-line
bindkey '^x^j' down-line

# Copy last command's output to xclipboard WITH ansi escape sequences
function copy_last_output {
	check_output $XC || return
	[[ -z $tmux_log_file || ! -s $tmux_log_file ]] && { zle -M "No output captured."; return }
	cat $tmux_log_file | $=XC \
		&& zle -M "Copied last command's output WITH ansi escape sequences." \
		|| zle -M "FAILED to copy last command's output. (XC=$XC)"
}
bindkey_func '^x^o' copy_last_output

# Copy last command's output to xclipboard WITHOUT ansi escape sequences
function copy_last_output_stripped {
	check_output $XC || return
	[[ -z $tmux_log_file || ! -s $tmux_log_file ]] && { zle -M "No output captured."; return }
	has strip-ansi ||{ zle -M "strip-ansi NOT available."; return }
	cat $tmux_log_file | strip-ansi | $=XC \
		&& zle -M "Copied last command's output WITHOUT ansi escape sequences." \
		|| zle -M "FAILED to copy last command's output. (XC=$XC)"
}
bindkey_func '^xo' copy_last_output_stripped

function page_tmux_pane {
	# zle -M "page_tmux_pane"
	local temp_file=$(mktemp)
	tmux capture-pane -epJS - > $temp_file
	tmux split -vbp 60 $EDITOR $temp_file
}
bindkey_func '^x^r' page_tmux_pane

min_version() {
	local current_version=$1
	local min_version=$2
	[ $(print -rl -- $current_version $min_version | sort -V | head -1) = $min_version ]
}

if has nvim && min_version ${${$(nvim --version):1:1}##v} 0.3; then
	export VISUAL=nvim
else
	if has vimx; then
		export VISUAL=vimx
	else
		export VISUAL=vi
	fi
fi
export EDITOR=$VISUAL

# vimp="$VISUAL -c AnsiEsc -c \"s/\%xd//\" -c go1"
vimp="$VISUAL +AnsiEsc"
function page_last_output_fullscreen {
	check_output vp || return
	tmux new-window -n "log-${tmux_log_file##*/}" $=vimp $tmux_log_file
}
bindkey_func '^xx' page_last_output_fullscreen

function page_last_output_split {
	check_output vp || return
	tmux split -hp 50 $=vimp $tmux_log_file
}
bindkey_func '^xl' page_last_output_split

function page_last_output {
	check_output vp || return
	# TODO: Remove hook after select-layout. Add single-shot hooks to tmux?
	# TODO: This crashes tmux much too often. Fix tmux.
	# -c 'autocmd vimrc VimLeave * silent! !tmux set-hook pane-exited "select-layout '$(tmux display-message -pF '#{window_layout}')\" \
	# -c 'StripAnsi' \
	tmux split -vbp 60 $=vimp $tmux_log_file
}
bindkey_func '^x^x' page_last_output

function check_output {
	[[ -z $tmux_log_file || ! -s $tmux_log_file ]] || return 0
	zle -M "No output captured (tmux_log_file = \"$tmux_log_file\")."
	zle up-history
	zle end-of-line
	zle -U " | $1"
	return 1
}

# TODO:
# -add mapping to jump to first line of output
# -prefilter for IP, numbers, paths, etc., cf. above.
# -add preview to fzf to show various transformations of current line, i.e. filter IP, numbers, strings, etc and add shortcuts to select them as return value
# -add shortcut to move to or merge previous outputs as well
function filter_last_output {
	check_output vp || return
	RBUFFER=$( cat $tmux_log_file |
		# Print bogus LINE_SEPARATOR to prevent screen line skip
	fzf --tac --multi --no-sort \
		--margin 0,0,1,0 \
		--preview '(pygmentize -l zsh <(echo {}) || cat <(echo {})) 2> /dev/null' \
		--preview-window 'up:45%:wrap:hidden' \
		| ( has dos2unix && dos2unix || cat) \
		| tr -d '\n'
	)
		# | tr '\t\n' '  ' | tr -s ' ')
}
bindkey_func '^o' filter_last_output

function unify_whitespace() {
    BUFFER=${BUFFER:s:	: ::fs:  : ::fs:# :::fs: %::}
	# BUFFER=${BUFFER:fs:  : ::fs:# :::fs: %::}
	# BUFFER=${BUFFER::s  : ::fs:  : ::s:# :::s: %::}
}
bindkey_func '^x^ ' unify_whitespace

function diff_last_two_outputs {
	# TODO: better derive event numbers from internal shell history
	local o1=~/.tmux-log/$(($(print -P '%!')-2))
	local o2=~/.tmux-log/$(($(print -P '%!')-1))
	[[ -e $o1 ]] || zle -M "Output \"$o1\" not found."
	[[ -e $o2 ]] || zle -M "Output \"$o2\" not found."
	[[ -s $o1 ]] || zle -M "Output \"$o1\" is empty."
	[[ -s $o2 ]] || zle -M "Output \"$o2\" is empty."
	diff -q $o1 $o2 > /dev/null && { zle -M "Last two outputs do NOT differ."; return }
	tmux new-window "cd ~/.tmux-log/; vimdiff $o1 $o2"
}
bindkey_func '^x^m' diff_last_two_outputs

function run_ab {
	[[ -z $zsh_a && -z $zsh_b ]] && { zle -M -- "zsh_a and zsh_b are not set."; return }
	[[ $zsh_a = $zsh_b ]] && { zle -M -- "zsh_a and zsh_b are equal. (\"$zsh_a\")"; return }
	[[ -z $BUFFER ]] && zle up-history
	# TODO: try to find in zsh docs which modifier to use to make search pattern to be eval
	# BUFFER="$($BUFFER:s:$zsh_a:$zsh_b:)"
	local zsh_c=1_zsh_deadbeef  # TODO: zip zsh_a and zsh_b?
	BUFFER=$(<<< $BUFFER sed -e "s:$zsh_a:$zsh_c:g" -e "s:$zsh_b:$zsh_a:g" -e "s:$zsh_c:$zsh_b:g")
}
bindkey_func '^x^f' run_ab

function run_prepend {
	if [[ -z $zsh_prepend ]]; then
		if [[ $PWD/ = (#b)$HOME/mnt/(*)/* ]]; then
			zsh_prepend="ssh ${match[1]%%/*}"
		else
			local -r ssh_history="$HOME/.ssh/host_history"
			[ -e $ssh_history ] && zsh_prepend="ssh $(
				sed -nE '$s|^.* (.*)@(.*):(.*)|-p \3 \1@\2|p' ~/.ssh/host_history
			)"
			[ -n $zsh_prepend ] || { zle -M -- 'zsh_prepend is not set.';  return; }
		fi
	fi
	while [[ -z $BUFFER || $BUFFER = zsh_prepend=* ]];  do zle up-history; done
	BUFFER="$zsh_prepend $BUFFER"
	CURSOR=$[$#zsh_prepend+1]
}
bindkey_func '^x^p' run_prepend

prepend_volla_22() { zsh_prepend='ssh mtk ANDROID_SERIAL=GS5CTP209140' ; run_prepend ; }; bindkey_func '^xp1' prepend_volla_22
prepend_giga_gx4() { zsh_prepend='ssh mtk ANDROID_SERIAL=GX4CTPC01794' ; run_prepend ; } ; bindkey_func '^xp2' prepend_giga_gx4
prepend_volla_x23() { zsh_prepend='ssh mtk ANDROID_SERIAL=GX4CTR201011' ; run_prepend ; } ; bindkey_func '^xp3' prepend_volla_x23

function run_subshell {
	if [[ -n $BUFFER ]]; then
		local current_buffer=$BUFFER
		if (( CURSOR )); then
			zle up-history
			integer new_cursor=$((CURSOR + $#BUFFER + 3))
			BUFFER="$current_buffer \$($BUFFER)"
			CURSOR=new_cursor
		else
			BUFFER=" \$($current_buffer)"
		fi
	else
		zle up-history
		BUFFER=" \$($BUFFER)"
		CURSOR=0
	fi
}
bindkey_func '^x^b' run_subshell

function run_sudo {
	[[ -z $BUFFER ]] && zle up-history
	[[ -n $SUDO_TARGET_USER ]] && BUFFER="-u $SUDO_TARGET_USER $BUFFER"
	BUFFER="sudo $BUFFER"
	CURSOR=5
}
bindkey_func '^x^s' run_sudo

# TODO: Factor out as general inline zle substituion function
# TODO: Re-write using ${aliases}
# TODO: Add initial query to fzf with left word
function select_aliases {
    OLD_BUFFER_LEN=$#BUFFER
    MARK=CURSOR
    BUFFER=$LBUFFER$(builtin alias | sed -e "s/\([^=]*\)=[' ]*\([^']*\)[']*/\1\t\2/ " | fzf --tabstop=28 --tac | cut -f 2 )$RBUFFER
    CURSOR+=$(($#BUFFER - $OLD_BUFFER_LEN))
    REGION_ACTIVE=1
    zle redisplay
}
bindkey_func '^x^a' select_aliases

zle_die() {
	local message=${1:-"FAILED"}
	zle -M $message
	# TODO: Find some kind of zle_exit
}

# TODO: Instead split vim with new script containing current line and RUN-split
function edit_command_line() {
	[[ -z $BUFFER ]] && zle up-history
	local old_buffer="$BUFFER"
	zle kill-whole-line
	zle -M "Enter script suffix for \"$old_buffer\"."
	zle recursive-edit || { zle -M "Aborted." ; return; }
	local run_file=$HOME/bin/tmp-$(nn)${BUFFER:+\-${(q)BUFFER}}.sh
	# TODO: Merge next line into previous.
	run_file=${(q)run_file}
	zle kill-whole-line
	local editor=${${VISUAL:-${EDITOR:-vi}}}
	print -l -- '#!'$SHELL $'' "$old_buffer" | tee /tmp/some_file > $run_file || { zle_die "Failed to create \"$run_file\""; return; }
	echo $old_buffer | tee /tmp/some_file >> $run_file
	chmod a+x $run_file || { zle_die "Failed to make \"$run_file\" executable"; return; }
	if [[ -n $TMUX ]]; then
		tmux split -vbp 80 $SHELL -ic "$editor $run_file; $SHELL -i "
		zle -U "RUN -tcsv $run_file"
  	else
		# TODO: Try something new when running out of tmux
	fi
}
bindkey_func "^xq" edit_command_line
bindkey_func "^x^q" edit_command_line
autoload -z edit-command-line
zle -N edit-command-line
bindkey_func "^x^v" edit-command-line

#
# Open man in tmux pane if possible
# TODO: Strip obvious cruft like like sudo and paths
if [ -z "$TMUX" ]; then
    bindkey '^[H' run-help
else
    run-help-tmux() {
	for command in ${(Oaz)LBUFFER} ${(Oaz)RBUFFER}; do
	    if [[ ! $command =~ ([-~|][[:alpha:]]*) ]]; then
		tmux split -vbp 80 $SHELL -ic "vimman $command"
		break
	    fi
	done
	zle redisplay
    }
    bindkey_func '^[H' run-help-tmux
fi

# complete words from tmux pane(s)
function tmux_word_valid() { (( $#1 > 3 )) && [[ ! $1 =~ ------ ]] }
function tmux_pane_words() {
	[[ -z "$TMUX_PANE" ]] && { zle -M "tmux_pane_words: \$TMUX empty."; return 1; }
	local expl
	local -a compl_curr_pane

	for word in ${(u)=$(tmux capture-pane -J -p)}; do
		tmux_word_valid $word || continue
		compl_curr_pane+=$word
	done
	_wanted tmux_words expl 'words from current tmux pane' compadd -Qa compl_curr_pane

	local -a compl_other_panes
	local current_pane_id=$(tmux display-message -pF '#{pane_id}')
	for pane_id in $(tmux list-panes -F '#{pane_id}'); do
		[[ $pane_id = $current_pane_id ]] && continue
		for word in ${(uo)=$(tmux capture-pane -J -p -t $pane_id)}; do
			tmux_word_valid $word || continue
			compl_other_panes+=$word
		done
	done
	_wanted tmux_word_other expl 'words from other tmux panes' compadd -Qa compl_other_panes
}

zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^v^v' tmux-pane-words-anywhere

zstyle ':completion:tmux-pane-words-anywhere:*' completer tmux_pane_words
zstyle ':completion:tmux-pane-words-anywhere:*' ignore-line current

bindkey -s pslc\  "psl -c ''"
bindkey -s psll\  'psl -c ""'
bindkey -s rq\  "r2 -Nqc ''  -"
bindkey -s EE\  "noglob echo ''  | openai_pipe"
bindkey -s r22\  "rax2 -s  hx"
# bindkey -s AD\  "adbk ''"
bindkey -s AT\  "a''t "
bindkey -s ATi\  "a''t !"
bindkey -s ATii\  "a''t !=?"
bindkey -s ATp\  "a''t ^"
bindkey -s cl\  'c $tmux_log_file\t '
bindkey -s cj\  'c $tmux_log_file\t | jq '
bindkey -s cjq\  'c $tmux_log_file\t | jq '
bindkey -s cvd\  'c $tmux_log_file\t | vd -t tsv '
bindkey -s clj\  'c $tmux_log_file\t | jq '
bindkey -s clq\  'c $tmux_log_file\t | jq '
bindkey -s cql\  "c $tmux_log_file\t | jq '.[]'"
bindkey -s sd\  'systemd-'
bindkey -s vl\   "$EDITOR $tmux_log_file\\t"
bindkey -s vll\  "$EDITOR *(.om[1])\\t"
bindkey -s Dh\  '~/*(.om[1])\t'
bindkey -s DL\  '~/INCOMING/*(.om[1])\t'
bindkey -s Sl\  '/SNAPSHOTS/h*(om[1])\t'
bindkey -s Pw\  '$( pwd )\t'
bindkey -s Ts\  'torsocks\t'
bindkey -s Cl\  '~/CQ/*(.om[1])\t'
bindkey -s Dl\  '~/INCOMING/*(.om[1])\t'
bindkey -s Dlp\  '~/INCOMING-db/*(.om[1])\t'
bindkey -s DPl\  '~/INCOMING-db/*(.om[1])\t'
bindkey -s mdl\  'mv ~/INCOMING/*(.om[1])\t .'
bindkey -s mvdl\  'mv ~/INCOMING/*(.om[1])\t .'
bindkey -s mvl\  'mv ~/INCOMING/*(.om[1])\t .'
bindkey -s Dl3\  '~/P3-INCOMING/*(.om[1])\t'
bindkey -s D3l\  '~/P3-INCOMING/*(.om[1])\t'
bindkey -s d3l\  '~/P3-INCOMING/*(.om[1])\t'
bindkey -s LD\  '*(/om[1])\t'
bindkey -s LF\  '*(.om[1])\t'
bindkey -s Pp\  'postgresql'
bindkey -s PJ\  'postgres'

function start_tmux_logging()
{
	# set -x
	zsh_history_id=$(print -P '%!')
	tmux_log_ts=$( date +%s%N )
	tmux_log_file=$HOME/.tmux-log/$(print -P '%!')
	# ZSH_DEBUG=1
	print -P -- $LINE_SEPARATOR
	if [[ -n $ZSH_DEBUG ]]; then
		print literal = \"$1\"
		print compact: \"$2\"
		print full: \"$3\"
		# print full-oneline: \"${3:gs,\\n, ,:gfs,  ,\0x20,}\"
		print full-oneline: \"$(echo $3 | tr "\n\t" "  " | tr -s " " | sed -e "s/^  *//")\"
		print time: $(n)
		print event id: ${$(echo $3 | sha1sum)[1]}
		print tmux_log_file: $tmux_log_file
		print -P $LINE_SEPARATOR
	fi
	# TODO: Do not log for INTERACTIVE_COMMANDS
	# TODO: Add logging (probably best in directories) for
	# -exit code
	# -directory (in case .zsh_local_history is not possible)
	# -environment
	# -literal and full command
	# -report times
	# -name of tmux session name
	# -create log_file_name from cmdline contents and timestamp as history event
	#  number does not seem to be stable enough
	# TODO: save hostname to merge log among different hosts
	if has dos2unix; then
	    tmux pipe-pane "dos2unix -f > $tmux_log_file"
	else
	    tmux pipe-pane "cat> $tmux_log_file"
	fi
	set +x
}

function stop_tmux_logging()
{
	[ -z $tmux_log_file ] && return
	tmux pipe-pane  # close current shell-pipe
	# TODO: Check if inotifywait is available
	[[ -r $tmux_log_file ]] || inotifywait -t 1 -qqe create ${tmux_log_file:h}
	# TODO: fossil commit
}

function set_terminal_title()
{
    # TODO:
    # -make this more portable
    # -check for ssh_tty
	# has kitty && timeout 1 kitty @ set-window-title "$*" 2>/dev/null
}

function zsh_terminal_title()
{
    # set -x
    # (( $ZSH_TERMINAL_TITLE_WORKER )) && kill $ZSH_TERMINAL_TITLE_WORKER
    export ZSH_TERMINAL_TITLE="${*:-NO TITLE}"
    # ( sleep 0.3 ; set_terminal_title $ZSH_TERMINAL_TITLE ) 2>&1 >/dev/null &
    set_terminal_title $ZSH_TERMINAL_TITLE
    # ZSH_TERMINAL_TITLE_WORKER=$$
}

function zsh_terminal_title_prompt()
{
    # TODO: add more sensible stuff here
	zsh_terminal_title "[$(tty) zsh-ps] $(pwd) [$USER@${HOST}]"
}

function zsh_terminal_title_running()
{
    # TODO: add more sensible stuff here

	zsh_terminal_title "[$(tty) zsh-run] $(echo $3 | tr '\n\t' '  ' | tr -s ' ' | sed -e 's/^ //') - $(pwd) [$USER@${HOST}]"
}

# WIP
function zsh_detect_display()
{
	return
	client_name=$( tmux display-message -p -F '#{client_termname}' )
	[[ -z $client_name ]] && return
	export DISPLAY
	
	[[ $client_name = *xterm* ]] && DISPLAY=$( pgrep -x -a --uid=$(id -u) Xorg | sed -nE 's|.*(:[0-9]+).*|\1|p' ) || {
		2>/dev/null lsof -P -i4 -a -p $(pgrep -u $(id -u) -x sshd ) -sTCP:LISTEN, |
		sed -nE 's/.*(60[0-9][0-9]).*/\1/p' | while read port; do 
			DISPLAY=:$port
			echo "Trying DISPLAY=$DISPLAY"
			xset q 2>/dev/null && break
		done
	}
}

# add-zsh-hook preexec zsh_detect_display
add-zsh-hook precmd zsh_terminal_title_prompt
add-zsh-hook preexec zsh_terminal_title_running

if whence tmux > /dev/null \
    && [[ -n $TMUX ]] \
    && tmux has-session >& /dev/null \
    && mkdir -p ~/.tmux-log ;
then
    add-zsh-hook preexec start_tmux_logging
    add-zsh-hook precmd stop_tmux_logging
fi

function preexec_ssh()
{
	[[ -v remote_host ]] || return
	cmd=$3
	[[ -n $cmd ]] || echo "$0: cmd empty"
	[[ $cmd = "unset remote_host" ]] && { eval $cmd; echo "Stopping $0."; return }
	: ${remote_shell:=zsh}
	[[ -n $remote_host ]] || echo "$0: remote_host empty"
	print "==========[ Redirecting to \"$remote_shell\" on remote host \"$remote_host\": \"${(q)cmd}\" ]=========="
	ssh -T $remote_host $remote_shell <<< $cmd
	kill -INT $$
}
add-zsh-hook preexec preexec_ssh

function precmd_ssh()
{
	[[ -v remote_host ]] || return
	: ${remote_shell:=zsh}
	print "==========[ Redirecting next command to \"$remote_shell\" on remote host \"$remote_host\" ]=========="
}
add-zsh-hook precmd precmd_ssh

function showbuffers()
{
    local nl=$'\n' kr
    typeset -T kr KR $'\n'
    KR=($killring)
    typeset +g -a buffers
    buffers+="     Pre: ${PREBUFFER:-$nl}"
    buffers+="  Buffer: $BUFFER$nl"
    buffers+="     Cut: $CUTBUFFER$nl"
    buffers+="       L: $LBUFFER$nl"
    buffers+="       R: $RBUFFER$nl"
    buffers+="Killring:$nl$nl$kr"
    zle -M "$buffers"
}
bindkey_func "^[o" showbuffers

# Change cursor when switching to vicmd
zle-keymap-select() {
    case $KEYMAP in
	vicmd) echo -ne "\e]12;darkgreen\a";;
	vioop) echo -ne "\e]12;yellow\a";;
	visual) echo -ne "\e]12;darkyellow\a";;
	# *) echo -ne "\e]12;darkred\a";;
	*) echo -ne "\e]12;yellow\a";;
    esac
}
echo -ne "\e]12;darkred\a"
zle -N zle-keymap-select

zle-line-init() { [[ $zle_keymap = vi ]] && zle -K vicmd || zle -K emacs }
zle -N zle-line-init
KEYTIMEOUT=23 # prevent delay when entering vi-mode
# Check: https://www.reddit.com/r/vim/comments/60jl7h/zsh_vimode_no_delay_entering_normal_mode/

zle-toggle-keymap() { [[ $zle_keymap = vi ]] && zle_keymap=emacs || zle_keymap=vi ; zle-line-init }
bindkey_func '^]^]' zle-toggle-keymap

# }}}

# Completion {{{
# zsh_source ~/.dotfiles/zsh/completion/zchee/src/zsh/zsh-completions.plugin.zsh
fpath+=~/.dotfiles/zsh/completion/misc
fpath+=~/.dotfiles/zsh/completion/zsh-users/src
fpath+=~/.dotfiles/zsh/completion/zchee/src/zsh
fpath+=~/.dotfiles/zsh/completion/zchee/src/go
fpath+=~/src/radare2/doc/zsh
fpath+=~/src/autorandr/contrib/zsh_completion/_autorandr

zmodload zsh/complist
autoload -U compinit && compinit -i
autoload -U zed

# TODO: check fpath vs. source
zsh_source ~/.dotfiles/src/t/etc/t-completion.zsh
compdef _t t
zsh_source -q /usr/share/zsh/vendor-completions/_awscli
zsh_source -q /usr/share/zsh/site-functions/_awscli
zsh_source ~/.dotfiles/colors/dynamic-colors/completions/dynamic-colors.zsh

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^f' forward-word
bindkey -M menuselect '^b' backward-word
bindkey -M menuselect '^ ' accept-and-hold
bindkey -M menuselect '^o' accept-and-infer-next-history
# TODO: Add infer-next-history-or-accept
# bindkey -M menuselect '^m' accept-and-infer-next-history
bindkey -M menuselect '^n' vi-forward-blank-word
# TODO:
# -patch zsh to support custom widgets
# -patch zsh to support vi-backward-blank-word-first natively
# vi-backward-blank-word-first() {
#     zle vi-backward-blank-word
#     zle vi-backward-blank-word
#     zle vi-forward-blank-word
# }
# zle -N vi-backward-blank-word-first
bindkey -M menuselect '^p' vi-backward-blank-word
bindkey -M menuselect '/' vi-insert

# TODO: Figure out how to compdef _gnu_generic in case the is no completer for a command
compdef _gnu_generic  alsactl autorandr autossh bmon capinfos circo criu ctags dot fdp findmnt frida fzf iftop iperf iperf3 lnav lspci mausezahn mmcli ncat neato netcat netcat nmap nping nsenter osage pandoc patchwork pstree pv qmicli qrencode sfdp shuf speedometer speedtest-cli tc teamd teamdctl teamnl tee tshark tty twopi uuidgen virt-filesystems winedbg wireshark xbacklight zbarimg logger virt-builder scanelf ncdu sqlitebrowser tabs prlimit archivemount csvsql xpra virt-install dracut zbarcam variety lpa leg icomera_scraper vd rofi legd btrbk grubby fwknopd fwknop ipcalc
# TODO: Add comments what we suppose to achive with all the zstyles
# TODO: Figure out why compdef ls does not show options, but only files
# TODO: Add 'something' which completes the current value when assigning a value
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _prefix _approximate tmux_pane_words
# zstyle ':completion:*' completer _complete
zstyle ':completion:*:approximate:::' max-errors 6 numeric
zstyle ':completion:*:matches' group yes
zstyle ':completion:*' group-name '' # Show each type of match in its own group
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' list-separator "--"
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%Slines=%l matches=%m (%p)%s'
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}" # Use same colors as GNU ls in lists
# TODO: Think about ma, hi, du markers
zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:parameter' list-colors '=*=1;31' # TODO: Make this work
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
# zstyle ':completion:*:options' list-colors '=(#b)(*)(--)(*)=34=7=1'
zstyle ':completion:*:options' auto-description 'Specify %d'
# zstyle ':completion:*:options' description yes
# zstyle ':completion:*:options' complete-options yes
zstyle ':completion:*' format '[%UCompleting %d%u]'
# zstyle ':completion:*' show-completer
# zstyle ':completion:*' show-ambiguity
# zstyle ':completion:*' single-ignored menu
zstyle ':completion:*' strip-comments
zstyle ':completion:*:messages' format $'\e[01;35m -- Message: %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No matches for: %d%b \e[0m--'
zstyle ':completion:*:descriptions' format $'\e[01;32m -- %d --\e[0m'

setopt menu_complete
# }}}

# Shell options {{{
autoload zmv
autoload run-help
setopt interactivecomments
setopt autocd
setopt autopushd
set push
setopt cdablevars
# setopt autonamedirs
setopt histsubstpattern
# setopt noclobber
stty -ixon

# TODO: Think about if this is a really a safe setup
# TODO: check if DISPLAY and xautolock refert to the same server
# TODO: Check if distros provide appropriate means to archive a safe setup
TMOUT=200

# set -x
ZSH_LOCK_STATUS="Setting TMOUT=200\n"
[[ -n $DISPLAY ]] && pgrep -u $(id --user) -x xautolock > /dev/null && X_AUTOLOCK=1
if [[ -n $SSH_TTY ]]; then
	ZSH_LOCK_STATUS+="Clearing TMOUT because zsh runs in a secure shell (ssh).\n"
	TMOUT=
elif [[ $USER = ec-user || -d /var/lib/cloud/instance/ ]]; then
	ZSH_LOCK_STATUS+="Clearing TMOUT because zsh runs in as cloud instance.\n"
	TMOUT=
elif [[ -n $TMUX ]]; then
	TMUX_LOCK_COMMAND=$(tmux show-options -qgv lock-command)
	if [ -n $TMUX_LOCK_COMMAND ]; then
		if whence $TMUX_LOCK_COMMAND[(w)1] > /dev/null; then
			if [[ $(uname -a) != *Microsoft* ]] && tmux list-clients -F '#{client_tty}' | grep -q '/tty[0-9]'; then
				ZSH_LOCK_STATUS+="Setting tmux lock-after-time because at least one tmux client runs on a unprotected ttyp.\n"
				tmux set-option -g lock-after-time $TMOUT
			else
				ZSH_LOCK_STATUS+="Clearing tmux lock-after-time because all tmux clients run under protected X servers.\n"
				tmux set-option -g lock-after-time 0
			fi
			ZSH_LOCK_STATUS+="Clearing TMOUT because zsh runs under a protected tmux server.\n"
			TMOUT=
		else
			echo WARNING: tmux lock-command not found.
		fi
	fi
elif [[ -n $X_AUTOLOCK ]]; then
	ZSH_LOCK_STATUS+="Clearing TMOUT because zsh runs under a protected X server.\n"
	TMOUT=
fi
(( $TMOUT )) && print -n -- $ZSH_LOCK_STATUS
# set +x

# # Try to save tmux from OOM
# if [[ -n $TMUX && ! $(uname -a) =~ Microsoft ]]; then
#     local tmux_pid=${$(ps -o pid,cmd --ppid 1 | command grep tmux)[1]}
#     if [[ -n $tmux_pid ]]; then
# 	if [[ "$(cat /proc/$tmux_pid/oom_adj)" != "-17" ]]; then
# 	    local oom_save="echo '-17' | sudo tee /proc/$tmux_pid/oom_adj"
# 	    print -l -- "WARNING: tmux server is not save from out of memory killer (OOM)." $oom_save
# 	    # TODO: find some zle redirection for $oom_save
# 	fi
#     else
# 	print "WARNING: No process for tmux server found, but \"\$TMUX=$TMUX\"."
#     fi
# fi

if zsh_source -q ~/.dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main line brackets)
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=red,underline'
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue'
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=yellow'
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,bold,underline'
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey,bold'
elif zsh_source $HOME/.dotfiles/zsh/syntax-highlighting/fast-syntax-highlighting.plugin.zsh; then
	# fast-theme default
	FAST_HIGHLIGHT[use_async]=1
fi
# }}}

# Setup aliases {{{
# [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

pathprepend() {
	local path_element=$1
	[[ -z $path_element || ! -d $path_element ]] && return
	[[ -n $2 ]] && { print ERROR: only 'path' is supported; return }
	# local path_env_name=${2:-path}
	# path=($path_element $path)
	path=($path_element $path)
}
zsh_source ~/.environment

# source aliases shared with bash
alias fcn='prl ${(ko)functions}'
compdef _pids cdp
p() { grep --color=always -e "${*:s- -.\*-}" =( ps -w -w -e -O user,ppid,start_time ) }
jobs_wait() { max_jobs=${1:=4}; [ $max_jobs > 0 ] || max_jobs=1; while [ $( jobs | wc -l) -ge $max_jobs ]; do sleep 0.1; done; }
faketty() { script -qfc "$(printf "%q " "$@")"; }
cdo() { parallel -i $SHELL -c "cd {}; $* | sed -e 's|^|'{}':\t|'" -- *(/) }
# nsdo() { parallel -i $SHELL -c "sudo ip netns exec {} $* | sed -e 's|^|'{}':\t|'" -- $(ip netns list) }
nsdo() { for ns in $(sudo ip netns list | cut -d\  -f 1); do sudo ip netns exec $ns $* | sed -e 's|^|'$ns':\t|'; done; }
nsrm() { for ns in $(sudo ip netns list | cut -d\  -f 1); do echo "Deleting netns \"$ns\"..."; sudo ip netns delete $ns ; done; }
alias nsls='sudo ip netns list'
alias ipe='sudo ip netns exec $ns'
alias nse='sudo ip netns exec $ns'
# alias nsee='sudo ip netns exec $1 sudo -E -u \#${SUDO_UID:-$(id -u)} -g \#${SUDO_GID:-$(id -g)} -- $SHELL'
nsee() {
	[[ -f /var/run/netns/$1 ]] || { print usage: $0 netns; ls -1 /var/run/netns/; return; }
	sudo ns=$1 -E ip netns exec $1 sudo -E -u \#${SUDO_UID:-$(id -u)} -g \#${SUDO_GID:-$(id -g)} -- $SHELL
}
pp() {
	if [[ -z $* ]]; then
		sudo --preserve-env=HOME,TMUX $EDITOR +ProcessTree
	else
		sudo --preserve-env=HOME,TMUX $EDITOR +ProcessTree "+/${*:s, ,.\*,}" "+FzfLines $*"
	fi
}
ut2nt() { date -d@$1 '+%F %T'}
D() { set -x; $*; set +x; }
curl-tesseract() { curl --silent --output - "$@" | tesseract -l eng -l deu - - ; }
compdef _man vimman
compdef _ps pf
compdef _ps pidof

typeset -A tmux_dirs=(right R left L above U top U up U below D down D)

tmux_neighbor() {
	if tmux select-pane -${tmux_dirs[$1]}; then
		shift
		tmux display-message -p "$*"
		tmux select-pane -l
	fi
}

tmux_neighbor_pane() {
	tmux_neighbor $1 '#{pane_id}'
}

tmux_neighbor_tty() {
	tmux_neighbor $1 '#{pane_tty}'
}

tmux_neighbor_pid() {
	tmux_neighbor $1 '#{pane_pid}'
}

print_tty() {
	tty=$1
	shift
	print -- $* >> $tty
}

tmux_print_tty_right() { print_tty $(tmux_neighbor_tty right) $* }
tmux_print_tty_left() { print_tty $(tmux_neighbor_tty left) $* }
tmux_print_tty_above() { print_tty $(tmux_neighbor_tty above) $* }
tmux_print_tty_below() { print_tty $(tmux_neighbor_tty below) $* }

alias Pr=tmux_print_tty_right
alias Pl=tmux_print_tty_left
alias Pa=tmux_print_tty_above
alias Pb=tmux_print_tty_below

tmux_send_keys_right() { tmux send-keys -t $(tmux_neighbor_pane right) $* }
tmux_send_keys_left() { tmux send-keys -t $(tmux_neighbor_pane left) $* }
tmux_send_keys_above() { tmux send-keys -t $(tmux_neighbor_pane above) $* }
tmux_send_keys_below() { tmux send-keys -t $(tmux_neighbor_pane below) $* }

alias Kr=tmux_send_keys_right
alias Kl=tmux_send_keys_left
alias Ka=tmux_send_keys_above
alias Kb=tmux_send_keys_below

tmux_send_line_right() { tmux send-keys -t $(tmux_neighbor_pane right) "$*" $'\n' }
tmux_send_line_left() { tmux send-keys -t $(tmux_neighbor_pane left) "$*" $'\n'}
tmux_send_line_above() { tmux send-keys -t $(tmux_neighbor_pane above) "$*" $'\n' }
tmux_send_line_below() { tmux send-keys -t $(tmux_neighbor_pane below) "$*" $'\n' }

alias Lr=tmux_send_line_right
alias Ll=tmux_send_line_left
alias La=tmux_send_line_above
alias Lb=tmux_send_line_below


cdp() {
	CD_PIDS=(${=$(pidof "$*")})
	if [ -n "$CD_PIDS[1]" ]; then
		cd /proc/${CD_PIDS[1]}
		if [ -n "$CD_PIDS[2]" ]; then
			echo CD_PIDS = $CD_PIDS
		fi
	else
		echo no process matched \"$*\". Changing to proc root...
		cd /proc/
		fi
	}

cd() {
	if ! builtin cd $* 2>/dev/null; then
		if [ -e $* ]; then
			local dir=$(dirname $*)
			if [ $dir = "." ]; then
				print WARNING: no directory change
			else
				builtin cd $dir
			fi
		else
			echo Cannot change to \"$*\"
		fi
	fi
}


GG_w() {
	(
	while true; do
		print -P $LINE_SEPARATOR
		print "[$(n)] Launching \"$*\""
		print -P $LINE_SEPARATOR
		G $*
		print -P $LINE_SEPARATOR
		print "Restarting gdbserver"
		sleep 1
	done
	) &
	while true; do
		read
		print "Killing gdbserver"
		kill $(pidof gdbserver)
		kill ${${(v)jobstates##*:*:}%=*}
		return
		sleep 1
	done
}

cloc() {
	locate --existing --basename --null .zsh_local_history |
		xargs -0 grep --color=always --line-number -F "$*" 2>/dev/null |
		grep -vE '\<clocd?\>' |
		sed 's:/.zsh_local_history: :'
	}

clocd() {
	locate --existing --basename --null .zsh_local_history |
		xargs -0 grep --files-with-matches -F "$*" |
		grep -vE '\<clocd?\>' |
		sort -u
	}

clocdf() { cd $(clocd $* | fzf --preview " grep --color=always -e "$*" {} ") }

zloc_file() {
	local -r file=.zsh_local_history
	[[ -r $file ]] && { echo -n $file ; return }
	echo -n ~/.zsh_local_history_dir${(q)PWD}/history
}

zloc() {
	fc -p $(zloc_file)
}

alias -g 0,="| perl -pe 's:\0:, :g'"
# alias -g 000='0.0.0.0/0'
# alias -g 00='0.0.0.0'
alias -g 0m='| tr \\0 \\n'
alias -g 0s0='::1/0'
alias -g 0s='::1'
alias -g BB='| base64'
alias -g BBD='| base64 -d -i | hexdump -C | LESS= less'
alias -g CC="| cat"
alias -g C,="| column -nts,"
alias -g C="| column -t"
alias -g CD="| column -t | vd --header 0 -f fixed"
alias -g Cv="| vd --header 0 -f fixed"
alias -g SV="| vd"
alias -g TSV="| vd"
alias -g CVS="| vd"
alias -g VD="| vd -f json "
alias -g Cc="| column -nts,"
alias -g Cs="| column -n"
alias -g Ct="| column -ts $'\t'"
alias -g DA='| sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"' # Delete ANSI (mostly)
alias -g DH="| sed -e 's/<[^>]*>//g'" # Delete XML/HTML - very basic
alias -g DN2="2> /dev/null"
alias -g 2dn="2> /dev/null"
alias -g dnn="2> /dev/null"
alias -g DN="> /dev/null"
alias -g DNN="> /dev/null 2>&1"
alias -g DW="| tr '\a\b\f\n\r\t\v[:cntrl:]' ' ' | sed -e 's:  +: :' -e 's:^ :: ' -e 's: $::' " # Delete and squeeze whitespace, i.e. make one-liners
alias -g DX="| sed -e 's/<[^>]*>//g'" # Delete XML/HTML - very basic
alias -g E2='2>&1 '
alias -g E@='2>&1 '
alias -g GE="|& grep -i -E '^'"
alias -g J="| jq '.[]'"
alias -g JQ="| jq '.[]'"
alias -g LQ='|& lnav -t'
alias -g FF=' | file -kbz -'
alias -g QQ='-nographic -nodefaults -kernel kernel -initrd initrd -drive file=root,index=0,media=disk,format=raw -serial stdio -append "console=ttyS0 root=/dev/sda"'
alias -g S='| sort'
alias -g SD2T="|sed -re 's/ - /\t/'"
alias -g SE="2>&1"
alias -g SN='| sort -n'
alias -g SS2C="|sed -re 's/[[:space:]]+/,/g'"
alias -g SS2S="|sed -re 's/\s+/ /g'"
alias -g SS2T="|sed -re 's/[[:space:]]+/\t/g'"
alias -g SS2TT="|sed -re 's/[[:space:]]{2,}/\t/g'"
alias -g SS='| strings -t x -e S | LESS= less'
alias -g SUU='| sort | uniq'
alias -g TS="|& ts -m '[%F %T]'"
alias -g TTT='| tesseract - - | strings'
alias -g UU='| sort | uniq'
alias -g WL='| wc -l'
alias -g WH='| tr -d "[:space:]" | tr "[:upper:]" "[:lower:]" ; echo'
alias -g WLD='| sort | uniq -d | wc -l'
alias -g WLU='| sort | uniq | wc -l'
alias -g X='| xargs -r'
alias -g X1='| xargs -rn 1'
# alias -g X0='| xargs -r0'
alias -g XP='| xargs -rP $(nproc)'
alias -g XZ='| xargs -rP $(nproc) -0'
alias -g XP0='| xargs -rP $(nproc) -0'
# alias -g gg='|& grep -i -- ' # TODO: use rg with rust regex instead
alias -g gg='| grep -i -- ' # TODO: use rg with rust regex instead
alias -g ggg='|& grep -i -- ' # TODO: use rg with rust regex instead
alias -g ggs='| strings | grep -i --'
alias -g ggv='| grep -v -- '
alias -g ggvv='|& grep -v -- '
alias -g ff='| file -z'
alias -g hh='| hexdump -Cv | less'
alias -g hs="| hexdump -v -e '1/1 \"%02x:\"' | sed -e 's,:$,\n,'"
if has hexa; then
	alias -g hx='| heksa -f hex,asc -o dec,hex -w $[ COLUMNS / 5 ] | less'
else
	alias -g hx='| hexdump -C | LESS= less'
	alias -g hx='| heksa -f hex,asc -o dec,hex -w $[ COLUMNS / 5 ] | less'
fi
alias -g lqq='|& lnav -q'
alias -g lqtt='|& lnav -qt'
alias -g ll='|& less'
alias -g LL='|& less'
alias -g Ll='| leg '
alias -g LLL='| leg --processDataTime --lifesign'
alias -g xr='| xxd -r -p'
alias -g PR='| sed -s "s|^|"$(eval $PRE)"\\t|"'
alias -g SF='| sed -s "s|$|"\\t$(eval $PRE)"|"'
PRE='echo $RANDOM'
alias -g AI=' | openai_pipe'
alias -g SP="| sponge $f"
alias -g SPP="| sponge -a $f"
alias -g XC=" | $XC "

err() {
  printf '\e[31m%s\e[0m\n' "$*" >&2
}

die() {
  (( $# > 0 )) && err "$*"
}

# set +x
if has trash; then
	alias rm='trash --'
	alias rmm='\rm -rf --'
	tl() {'cd $(trash-list|sort|fzf --tac|cut -d\  -f 3); restore-trash; cd -'}
else
	tl() { err "trash-cli NOT installed." }
fi
alias rm='\rm -rf -v --'

visudo_append() {
	has -v sudo || { die; return }
	[[ -v visudo_tmp ]] && { die "Variable visudo_tmp in use."; return }
	[[ $# = 0 ]] && { die "Usage: ${0:t} line"; return }
	local line=$@
	visudo_tmp=$(mktemp tmp.${0:t}.XXXXXXXX ) || { die "mktemp failed."; return }
	setopt localtraps
	trap 'sudo \rm -rf $visudo_tmp; unset visudo_tmp' EXIT
	sudo cp -a /etc/sudoers $visudo_tmp
	sudo grep -q $line $visudo_tmp && { die "Line \"$line\" already contained in sudoers"; return }
	print -- $line | sudo tee --append $visudo_tmp > /dev/null
	sudo visudo --check --file=$visudo_tmp > /dev/null && sudo mv $visudo_tmp /etc/sudoers
	chown 0:0 /etc/sudoers
}
alias VaT='sudo true && visudo_append Defaults timestamp_timeout=240'
alias VaY='sudo true && visudo_append Defaults !tty_tickets'
alias VaP='sudo true && visudo_append Defaults use_pty'

if has apt; then
	alias pi='sudo -E apt-get install --fix-missing -y '
	alias pii='sudo -E apt install --fix-missing -y $(apt-cache dump | \grep --color "^[Pp]ackage: " | cut -c 10- |&fzf --ansi --multi --preview-window=top:50% --query="!:i386$ " --preview "apt-cache show {}"); rehash'
	alias agr='sudo -E apt remove $(dpkg-query --show --showformat="\${Package}\\t\${db:Status-Abbrev} \${Version} (\${Installed-Size})\t\${binary:Summary}\n" | fzf --tabstop=40 --sort --multi --preview-window=top:50% --preview "apt-cache show {1}" | cut -f 1)'
	alias dps='dpkg -S'
	alias dnp='noglob apt-file search'
	dpl() { apt-cache show $* && dpkg -L $*}
	compdef _deb_packages dpl
	dpL() { dpl $(dps $(whh $*) 1>&2 | cut -d: -f 1) }
	compdef _command_names dpL
	PL() { apt-cache show $* && dpkg -L $*}
	compdef _deb_packages PL
	PS() { dpl $(dps $(whh $*) 1>&2 | cut -d: -f 1) }
	compdef _command_names PS
elif has yum; then
	alias pi='sudo -E yum -y install '
	# alias pii='sudo yum -C -y install $(sudo yum list -C | fzf --ansi --multi --preview-window=top:50% --preview "yum info {1}; rpm -ql {1}" | cut -f 1 -d\  ); rehash'
	alias pii='sudo -E yum -y install $(sudo yum list | fzf --ansi --multi --preview-window=top:50% --preview "yum info {1}; rpm -ql {1}" | cut -f 1 -d\  ); rehash'
	alias agr='sudo dnf remove $( dnf list --installed | fzf -m | cut -f1 -d" " )'
	alias dps='rpm -qf'
	alias dpl='rpm -qvli'
	alias dnp='noglob dnf provides */'
	dpL() { rpm -qli $(rpm -qf $(whh $*) ) }
	PS() { PL $(rpm -qf $(whh $*)) }
	compdef _command_names PS
elif has port; then
	alias pii='sudo port install -v $(port list | fzf --multi --sort --preview-window=top:50%:wrap --preview "port info {1}" --bind "ctrl-g:execute(port gohome {1})" | cut -f 1)'
fi

has kitty && kitty +complete setup zsh | source /dev/stdin

has grc && tf_alias='command grc'
tf_file=/var/log/messages
[[ -e $tf_file ]] || tf_file=/var/log/syslog
if [[ -e $tf_file ]]; then
	[[ -r $tf_file ]] || tf_alias="sudo true && sudo $tf_alias"
	alias tf="$tf_alias tail -f $tf_file &"
else
	alias tf='err("syslog NOT found")'
fi

if has lnav; then
	alias tff="sudo true && cd $tf_file:h && sudo lnav $tf_file:t "
else
	alias tff='err("lnav not found")'
fi

c() {
	[[ $# = 0 ]] && { die "usage: c files_and_directories"; return }
	cc() { [[ -d $1 ]] && ls -al $1 || cat $1 }
	[[ $# = 1 ]] && { cc $1; return }
	for f in $@; do
		cc $f | sed "s|^|$f:\t|"
	done
}

typeset -a expand_ealias_skip
expand_ealias_skip=(ls)
expand_ealias() {
	# zle -M "1 = \"${LBUFFER:0:1}\", CURSOR = $CURSOR, LBUFFER = \"$LBUFFER\", RBUFFER = \"$RBUFFER\""
	[[ ${RBUFFER:0:1} = "\\" ]] && return
	[[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)expand_ealias_skip})$" ]] || zle _expand_alias
	# zle expand-word
	zle magic-space
}
bindkey_func ' ' expand_ealias
bindkey -M isearch ' '  magic-space # normal space during searches

setopt extendedglob # Only enable after definition of expand_ealias

function space_prepend {
    zle -U ' '
}
bindkey_func '^ ' space_prepend

function zle_mkdir {
    zle -M "owi: $BUFFER "
    zle -M "owii: ${${(Oaz)BUFFER}[1]} "
}
bindkey_func '^xd' zle_mkdir

# TODO
# -Add fzf-bindings for copy-key, copy-value, copy-value-quoted, etc.
env_vars() {
	REPORTTIME=-1
	LBUFFER="$LBUFFER$(print_variables |
	fzf \
		--tac --multi \
		--preview 'typeset -p {1}; echo {} | pygmentize -l zsh' \
		--preview-window up:45%:wrap | cut -d\  -f1 | tr $'\n' ' ')"
}
bindkey_func '^x^e' env_vars
# }}}

print_variables() {
	zparseopts -D -A opts h
	show_hidden=$+opts[-h]
	vars=(${*:-${(ko)parameters}})
	for var in $vars; do
	type=${(tP)var}
	print -n -- $var \($type, ${(P)#var}\)
	if [[ $type = *hideval* && $show_hidden = 0 ]]; then
		print  \ = VALUE HIDDEN
		continue
	fi
	if [[ $type = *assoc* ]]; then
	    print -n : \(
	    for k v in ${(kvP)var}; do
			print -n -- "$k: $v, "
	    done
	    print \)
	else
		print -- \ = ${(P)var} | tr \\n\\t ' ' | tr -s ' '; print
	    # print -- \ = "${(P)var}"
	fi
    done
}
compdef _parameter print_variables

have() {
  unset have
  (( ${+commands[$1]} )) && have=yes
}

watch=notme
WATCHFMT="User %n from %M has %a at tty%l on %T %W"
logcheck=30

# Source external ressource files {{{
zsh_source ~/.fzf.zsh
zsh_source ~/.fzfrc

nmn() {
	targets=()
	excludes=()
	for if in $(command ls -1 /sys/class/net); do
		if [ $if != "lo" -a $(cat /sys/class/net/$if/operstate) = "up" ]; then
			targets+=$(ifdata -pN $if)/24
			excludes+=$(ifdata -pa $if)
		fi
	done
	print_variables targets excludes
	nmap -PS2222 -p- -oA ~/.logs/nmap/log-$(nn) --exclude ${(j-,-)excludes} ${(j- -)targets}
}

_at() {
	cmd=$*
	[[ ${cmd:0:2} = "at" ]] && cmd=${cmd:2}
	print at $cmd | sudo socat - /dev/modem,crnl
}
alias AT='noglob _at'
alias at='noglob _at'
alias atp='noglob _at +'

# type keychain > /dev/null && eval $(keychain --eval --timeout 3600 --quiet)
# type keychain > /dev/null && eval $(keychain --eval --quiet)
# export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# export GPG_TTY="$(tty)"
# gpg-connect-agent updatestartuptty /bye > /dev/null

# TODO: Think about a way how to select umask for sudo
umask 002
# }}}
zstyle ':completion:*:processes' command 'ps -ea --forest -o pid,%cpu,tty,cputime,cmd'
zmodload zsh/stat
[[ $(stat -L +size -- $HISTFILE) -lt 10000 ]] && {
	print "WARNING: size of zsh history $HISTFILE is suspiciously low ($(cat $HISTFILE | wc -l) lines)."
	sleep 3
}
rnd() {(($[RANDOM%${1:-2}]>${2:-0}))}
# fz() { [ -f $1 -a -r $1 ] && mkdir -p $1.DIR && fuse-zip $1 $1.DIR && cd $1.DIR }
fz() { [ -f $1 -a -r $1 ] && mkdir -p $1:t.DIR && archivemount $1 $1:t.DIR && cd $1:t.DIR && $EDITOR . }
fU() { [ -d $1 ] && fusermount -u $1 && rmdir $1 }
compdef _files fz
compdef _directories fU

gcdd() {
	if git rev-parse -q --is-inside-work-tree > /dev/null 2>&1; then
		cd $(git rev-parse --git-dir)
	else
		echo "Not in git work tree."
	fi
}

gcd() {
	if git rev-parse -q --is-inside-work-tree > /dev/null 2>&1; then
		cd $(git rev-parse --show-toplevel)
	else
		echo "Not in git work tree."
	fi
}

mount_dev() {
	set -x
	# [[ $1 == /dev/* ]] || { echo "usage: $0 dev_with_partitions_to_mount"; return; }
	sudo sfdisk -J $1  |
		jq -r '.partitiontable.partitions[].node' |
		while read dev; do 
			mnt=mnt/${dev#/dev/}
			mkdir -p $mnt && sudo mount -v $dev $mnt
		done
}
compdef _mount mount_dev
alias uma='sudo umount mnt/*'

mount_img() {
	[[ -r $1 ]] || { echo "usage: $0 image"; return; }
	set -x
	img=$1
	sfdisk -J $img |
		jq -r '.partitiontable.partitions[] | ["mnt/"+.node, .start * 512] | @tsv' |
		while read node offset; do
			dev=$(sudo losetup --show -J --verbose --find --offset $offset $img) &&
			mkdir -p $node &&
			sudo mount -o ro $dev $node &&
			echo "Mounted $node ($dev)"
		done
}
	
mvA() {
    mv $* "$(echo -n $* |tr --complement '[[:alnum:]/.]' '_' )"
}
zsh_source -q  ~/.android/current_serial
p2x() { plistutil -i $1 -o $1.xml }
cx() { r2 -c "e hex.cols = $[COLUMNS /5]" -cV $1 }
ch() { r2 -c "e hex.cols = $[COLUMNS /5]" -cV $1 }
proc_loaded() { (( $#jobtexts > ${1:-$(nproc)} )) }
sigint() { trap 'done=1' INT; }
autoload zargs

zmodload zsh/mathfunc
# TODO: Is this a good idea? How do sparse files relate to ulimit?
# limit coredumpsize 10m maxproc 9000 filesize $(( int(0.1 * $(findmnt -bno AVAIL -T $HOME))))

autoload zcalc
# leg_db query
# tabs 55; zargs -P $(nproc) **/*.bin -- leg --no-lifesign-check -p dir -p filename -k --trainPISBodyCustTrainNum | sort -uk 3

rand_int() { echo $(( $(od -v -An -tu -N 4 /dev/urandom ) % ${1:=10} )) }
rand_geom() {
	eval $(xdpyinfo | sed -nE '/dimensions/s|^.* ([0-9]+)x([0-9]+) pixels.*$|x=\1 y=\2|p')
	echo "-geometry $(rand_int $x)x$(rand_int $y)+$(rand_int $x)+$(rand_int $y)"
}
rand_color() { od -v -An -tx1 -N 3 /dev/urandom | tr -d '[:space:]' }

leafnode() { z=($REPLY/*(N/)) ; return $#z } 

(( #env_local )) && source $env_local
pre() { sed "s|^|${${*/|/\\|}/\\/\\\\}|"; }
pree() { pre "$* " }
# pret() { pre "$*'$\t'" }
post() { sed "s|\$|$*|"; }
rsz() {
	local IFS='[;' escape geometry x y
	print -n '\e7\e[r\e[999;999H\e[6n\e8'
	read -sd R escape geometry
	x=${geometry##*;} y=${geometry%%;*}
	if [[ ${COLUMNS} -eq ${x} && ${LINES} -eq ${y} ]];then
		print "${TERM} ${x}x${y}"
	else
		print "${COLUMNS}x${LINES} -> ${x}x${y}"
		stty cols ${x} rows ${y}
	fi
}
set +x

sponge2() {
	local dst=$1
	[[ -n $dst ]] || { print -u2 "sponge: no dst"; return 1; }
	local T=$(mktemp)
	>$T
	[[ $dst = *.json ]] && has jd && jd $dst $T
	diff -u $dst $T || mv $T $dst
	rm -f $T
}

seq_pairs() {
	local a=($@)
	local b=(${a:1})
	# b+=${a[1]}
	for a b in ${a:^b}; do
		print $a $b
	done
}

env_local=(~/.environment.d/*(N)) 2>/dev/null
[ -e ~/.environment.local ] && source ~/.environment.local

zsh_source ~/.aliases
test -r /home/dsh2/.opam/opam-init/init.zsh && . /home/dsh2/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# source ~/.dotfiles/zsh/completion/docker-zsh-completion/docker-zsh-completion.plugin.zsh
compdef _docker docker
autoload /home-0/dsh2/.dotfiles/zsh/completion/docker-zsh-completion/repos/docker/cli/master/contrib/completion/zsh/_docker 

adbfs_mnts() { for mnt in ~/mnt/ADBFS/*; do mountpoint -q $mnt && echo $mnt; done; }

lo=127.0.0.1

now_epoch() { date '+%s' ; } 
now_epoch_ms() { date '+%s000' ; } 

set +x
