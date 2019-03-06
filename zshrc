# vim: set foldmethod=marker foldlevel=0 ts=4 sw=4

[[ $(uname -a) =~ Microsoft ]] && unsetopt bgnice

RUNNING_SHELL=$(readlink /proc/$$/exe)
# TODO: think about run-away loops
while [ -L $SHELL ]; do SHELL=$(readlink $SHELL); done
if [[ $RUNNING_SHELL != $SHELL ]]; then
    echo "WARNING: Fixing shell mismatch (RUNNING_SHELL = \"$RUNNING_SHELL\", SHELL = \"$SHELL)\""
    SHELL=$RUNNING_SHELL
fi

zsh_source() {
  # TODO: check if writeable for others than us
  [[ ! -r $@ ]] && { echo "zsh_source: "$@" not found. "; return; }
  source $@
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

in_array() { (( ${${(P)2}[(i)$1]} <= ${#${(P)2}} )) }

setopt prompt_subst
setopt prompt_cr
setopt prompt_sp
# export PROMPT_EOL_MARK='%{$fg_no_bold[red]%}<< \n missing'
# export PROMPT_EOL_MARK='%{$fg_no_bold[red]%}<< partial line (\n missing)'
export PROMPT_EOL_MARK='%{$fg_no_bold[red]%}<< partial line'
autoload -Uz vcs_info
autoload -U colors && colors
zstyle ':vcs_info:*' actionformats '%%F{136}[%F{240}%b%F{136}|%F{240}%a%F{136}]%f '
zstyle ':vcs_info:*' formats '%F{136}[%F{166}%b%F{136}]%f '
zstyle ':vcs_info:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' disable bzr tla
autoload -U add-zsh-hook
add-zsh-hook precmd vcs_info

# Main prompt {{{
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u2500:)}'
LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 1))::-:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 1))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 0))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u257c:)}%{$reset_color%}'
PS1=$LINE_SEPARATOR					# Add horizontal separator line
# PS1+=$'\r'$'\f'
PS1+=$'\n'
PS1+='%F{240}%(1j.[%{$fg_no_bold[red]%}l=%j%F{240}].)'	# Add number of jobs - if any
PS1+='%F{240}%(2L.[l=%{$fg_no_bold[red]%}%L%F{240}].)'	# Add shell level iff above 1
psvar[1]=$SSH_TTY
PS1+='%F{255}[%F{244}%n%'				# Add user name
PS1+='(1V.%{$fg_no_bold[red]%}@%m.)'			# Add host name for ssh connections
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
PS1+='%(0?..%(2V..%{$fg_bold[red]%}[err=%F{255}%?%{$fg_bold[red]%}])) '	# Add exit status of last job
# PS1+='%(0?..%($ZLE_LINE_ABORTED..%{$fg_bold[red]%}[err=%F{255}%?%{$fg_bold[red]%}])) '	# Add exit status of last job
PS1+='%f%# '						# Add user status
PS1+='(%!) '						# Add number of next shell event
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
PS4+='%(0?.%f.%{$fg_bold[red]%}[err=%F{255}%?%{$fg_bold[red]%}])'
# Make command line start at certain colum
typeset -i ps4_output_column=50
PS4+=$(echo -ne '\033[${ps4_output_column}D\033[${ps4_output_column}C')
# Reset color
# PS4+='%f'
PS4+=' | '
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
setopt no_hist_ignore_all_dups
setopt no_hist_ignore_dups
setopt no_inc_append_history
setopt no_inc_append_history_time
setopt share_history

zshaddhistory() {
	# echo zshaddhistory: checking line \"${1%%$'\n'}\"
	# TODO: try to understand why the following regexp matches 
	# when the empty string ended in c-m, but NOT c-c! BUG?
	if [[ -z $1 || $1 =~ (^[[:space:]]+.*$) ]]; then
		# echo zshaddhistory: line skipped
		return 1
	fi
	# echo zshaddhistory: line NOT skipped
	print -sr -- ${1%%$'\n'}
	# TODO: Add white or blacklist which path to put or NOT to put zsh_local_history in (e.g. ~/src/*, SSH_FS)
	if [[ -w $PWD ]]; then
		if [[ $PWD != $HOME ]]; then
			# print "zshaddhistory: adding to local history in PWD = $PWD"
			fc -p .zsh_local_history
		else
			# print "zshaddhistory: no local history for HOME = $HOME"
		fi
	else
		dir=~/.zsh_local_history_dir${(q)PWD}
		# echo zshaddhistory: Working directory NOT writeable: fc -p $dir/history
		mkdir -p $dir && fc -p $dir/history
	fi
}
# }}}

# ZLE {{{
zle_highlight=( 
    default:fg=default,bg=default
    special:fg=black,bg=red
    region:underline,bg=green
    suffix:bold
    isearch:underline
    paste:underline
)

function bindkey_func {
    zle -N $2
    # bindkey -M command $1 $2
    bindkey $1 $2
}

bindkey -e
bindkey '^[' vi-cmd-mode
bindkey -M viins '^j' vi-cmd-mode
bindkey '^?' undo
bindkey "^x;" describe-key-briefly

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

WORDCHARS='*?_-.[]~&!#$%^(){}<>|'
function backward_kill_default_word() {
    WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' 
    zle backward-kill-word
}
bindkey_func '\e=' backward_kill_default_word   # = is next to backspace

XC=${XC:-/bin/false}
if [[ -n $DISPLAY ]]; then
	if type xclip >/dev/null; then
		XC="xclip -selection clipboard -in"
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
		echo -n $CUTBUFFER | $=XC 2> /dev/null
	fi
}
bindkey_func '^k' kill-line-copy

# Copy last command to xclipboard
function copy_last_command {
	zle up-history
	zle kill-whole-line
	echo -n $CUTBUFFER | $=XC \
		&& zle -M "Copied last command line." \
		|| zle -M "FAILED to copy last command line. (XC=$XC)"
}
bindkey_func '^x^k' copy_last_command

# Copy last command's output to xclipboard
function copy_last_output {
	[[ -z $tmux_log_file || ! -s $tmux_log_file ]] && { zle -M "No output captured."; return }
	cat $tmux_log_file | $=XC \
		&& zle -M "Copied last command's output." \
		|| zle -M "FAILED to copy last command's output. (XC=$XC)"
}
bindkey_func '^x^o' copy_last_output

function page_tmux_pane {
	# zle -M "page_tmux_pane"
	local temp_file=$(mktemp)
	tmux capture-pane -epJS - > $temp_file
	tmux split -vbp 60 vim $temp_file
}
bindkey_func '^x^r' page_tmux_pane

function page_last_output {
	# TODO: Make this work without new tmux pane. 
	[[ -z $tmux_log_file || ! -s $tmux_log_file ]] && { zle -M "No output captured."; return }
	# TODO: Remove hook after select-layout. Add single-shot hooks to tmux?
	# TODO: This crashes tmux much too often. Fix tmux.
	# -c 'autocmd vimrc VimLeave * silent! !tmux set-hook pane-exited "select-layout '$(tmux display-message -pF '#{window_layout}')\" \
	# -c 'StripAnsi' \
	tmux split -vbp 60 vim $tmux_log_file \
		-c 'set buftype=nofile' \
		-c 'AnsiEsc' \
		+normal\ gg
}
bindkey_func '^x^x' page_last_output

# TODO:
# -add mapping to jump to first line of output
# -prefilter for IP, numbers, paths, etc., cf. above.
# -add preview to fzf to show various transformations of current line, i.e. filter IP, numbers, strings, etc and add shortcuts to select them as return value
# -add shortcut to move to or merge previous outputs as well
function filter_last_output {
	[[ -z $tmux_log_file || ! -s $tmux_log_file ]] && { zle -M "No output captured."; return }
	RBUFFER=$( cat $tmux_log_file  | 
		# Print bogus LINE_SEPARATOR to prevent screen line skip
	fzf --tac --multi --no-sort \
		--margin 0,0,1,0 \
		--preview 'echo {} | pygmentize -l zsh' \
		--preview-window 'up:45%:wrap:hidden' \
		| tr '\t\n' '  ' | tr -s ' ')
}
bindkey_func '^o' filter_last_output

function diff_last_two_outputs {
	local o1=~/.tmux-log/$(($(print -P '%!')-2))
	local o2=~/.tmux-log/$(($(print -P '%!')-1))
	diff -q $o1 $o2 > /dev/null && { zle -M "Last two outputs do NOT differ."; return }
	tmux new-window vimdiff $o1 $o2
}
bindkey_func '^x^m' diff_last_two_outputs

function run_sudo {
    [[ -z $BUFFER ]] && zle up-history
    zle beginning-of-line
    zle -U 'sudo '
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

# TODO: Instead split vim with new script containing current line and RUN-split
# autoload -z edit-command-line
# bindkey_func "^x^e" edit-command-line

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
# Source: http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
function tmux_pane_words() {
	local expl
	local -a words
	local ignore_pattern="AAA"
	if [[ -z "$TMUX_PANE" ]]; then
		_message "Not running inside tmux!"
		return 1
	fi
	for pane_id in $(tmux list-panes -F '#{pane_id}'); do
	    words+=(${(u)=$(tmux capture-pane -J -p -t $pane_id)})
	done
	# for word in ${(u)=$(tmux capture-pane -J -p -t $pane_id)}; do
	#     (( $#word < 5 )) && continue
	#     [[ $word =~ $ignore_pattern ]] && continue
	#     compadd -Q -- $word
	# done
	_wanted values expl 'words from current tmux window' 
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^v^v' tmux-pane-words-anywhere

zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
# zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
# zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

bindkey -s rq\  "r2 -Nqc '' -"
bindkey -s cl\  'cat $tmux_log_file\t'
bindkey -s vl\  'vim $tmux_log_file\t'
bindkey -s vll\  'vim *(.om[1])\t'

function start_tmux_logging() 
{ 
	tmux_log_file=$HOME/.tmux-log/$(print -P '%!') &&
		# TODO: Add colors to output
	# export ZSH_DEBUG=1
	print -P $LINE_SEPARATOR
	if [[ -n $ZSH_DEBUG ]]; then
		# print -l params = \"$@\"
		print literal = \"$1\"
		# print compact: \"$2\"
		# print full: \"$3\"
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
	tmux pipe-pane "cat > $tmux_log_file"
}

function stop_tmux_logging() 
{
    [ -z $tmux_log_file ] && return
    tmux pipe-pane 
    # HACK: Convert tmux line endings
    # TODO: Check tmux src
    sed -i -e 's,$,,' -e '$ d' $tmux_log_file
}

function set_terminal_title() 
{
    # TODO: 
    # -check esc sequences instead of wmctrl
    # -make this more portable
    # -check for ssh_tty
	if [ -n $DISPLAY ]; then
		if type wmctrl > /dev/null; then
			wmctrl -r :ACTIVE: -N "$*" &>/dev/null
		fi
	fi
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
    zsh_terminal_title "[zsh-ps] $(pwd) [$USER@${HOST}]"
}

function zsh_terminal_title_running() 
{ 
    # TODO: add more sensible stuff here

    zsh_terminal_title "[zsh-run] $(echo $3 | tr '\n\t' '  ' | tr -s ' ' | sed -e 's/^ //') - $(pwd) [$USER@${HOST}]"
}

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
	*) echo -ne "\e]12;darkred\a";;
    esac 
}
echo -ne "\e]12;darkred\a"
zle -N zle-keymap-select

# }}}

# Completion {{{
fpath+=~/.dotfiles/zsh/zsh-completions/src/
fpath+=~/.dotfiles/zsh/zsh-hub-completion/
fpath+=~/.dotfiles/zsh/zsh-socat-completion/
fpath+=~/.dotfiles/zsh/zsh-pandoc-completion/
# TODO: add repo to .dotfiles
fpath+=~/.zplug/repos/robbyrussell/oh-my-zsh/plugins/pip/
fpath+=~/.zplug/repos/robbyrussell/oh-my-zsh/plugins/gem/
fpath+=~/src/RE/radare2/doc/zsh

zmodload zsh/complist
autoload -U compinit && compinit
autoload -U zed

# TODO: check fpath vs. source
zsh_source ~/.dotfiles/src/t/etc/t-completion.zsh
compdef _t t
zsh_source /usr/share/zsh/vendor-completions/_awscli
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
compdef _gnu_generic autorandr capinfos fzf lnav lspci pstree pv shuf tee tshark tty wireshark pandoc
# TODO: Add comments what we suppose to achive with all the zstyles
# TODO: Figure out why compdef ls does not show options, but only files
# TODO: Add 'something' which completes the current value when assigning a value
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _prefix _approximate
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
setopt histsubstpattern
stty -ixon

# TODO: Disable TIME_REPORT for INTERACTIVE_COMMANDS
# REPORTTIME=3
# TIMEFMT='REPORTTIME for job "%J": runtime = %E, user = %U, kernel = %S, swapped = %W, shared = %X KiB, unshared = %D KiB, major page = %F, minor page = %R, input = %I, output = %O, recv = %r, sent = %s, waits = %w, switches = %c'

# TODO: Think about if this is a really a safe setup
# TODO: check if DISPLAY and xautolock refert to the same server
# TODO: Check if distros provide appropriate means to archive a safe setup
TMOUT=200
ZSH_LOCK_STATUS="Setting TMOUT=200\n"
[[ -n $DISPLAY ]] && pgrep -u $(id --user) -x xautolock > /dev/null && X_AUTOLOCK=1
if [[ -n $SSH_TTY ]]; then
	ZSH_LOCK_STATUS+="Clearing TMOUT because zsh runs in a secure shell \(ssh\).\n"
	TMOUT=
elif [[ $USER = ec-user || -d /var/lib/cloud/instance/ ]]; then
	ZSH_LOCK_STATUS+="Clearing TMOUT because zsh runs in AWS.\n"
	TMOUT=
elif [[ -n $TMUX ]]; then
	TMUX_LOCK_COMMAND=$(tmux show-options -qgv lock-command)
	if [ -n $TMUX_LOCK_COMMAND ]; then
		if whence $TMUX_LOCK_COMMAND[(w)1] > /dev/null; then
			if [[ $(uname -a) != *Microsoft* ]] && tmux list-clients -F '#{client_tty}' | grep -q '/tty[0-9]'; then
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
(( $TMOUT )) && print -n $ZSH_LOCK_STATUS

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main line brackets)
zsh_source ~/.dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[redirection]='fg=red,underline'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,bold,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey,bold'
# }}}

# Setup aliases {{{
# [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# source aliases shared with bash
zsh_source ~/.aliases

has() {
  local verbose=false
  if [[ $1 == '-v' ]]; then
	verbose=true
	shift
  fi
  for c in "$@"; do c="${c%% *}"
	if ! command -v "$c" &> /dev/null; then
	  [[ "$verbose" == true ]] && err "$c not found"
	  return 1
	fi
  done
}

err() {
  printf '\e[31m%s\e[0m\n' "$*" >&2
}

die() {
  (( $# > 0 )) && err "$*"
}

if has trash; then
	alias rm='trash -v --'
	alias rmm='\rm'
	alias tl='cd $(trash-list|sort|fzf --tac|cut -d\  -f 3); restore-trash; cd -'
else
	tl() { err trash-cli NOT installed. }
fi

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
	print $line | sudo tee --append $visudo_tmp > /dev/null
	sudo visudo --check --file=$visudo_tmp > /dev/null && sudo mv $visudo_tmp /etc/sudoers
	chown 0:0 /etc/sudoers
}
alias VaT='visudo_append Defaults timestamp_timeout=240'

if has apt; then
	alias PI='sudo apt-get install --fix-missing -y '
	alias PII='sudo apt install --fix-missing -y $(apt-cache dump | \grep --color "^Package: " | cut -c 10- |&fzf --ansi --multi --preview-window=top:50% --query="!:i386$ " --preview "apt-cache show {}"); rehash'
	alias agr='sudo apt remove $(dpkg-query --show --showformat="\${Package}\\t\${db:Status-Abbrev} \${Version} (\${Installed-Size})\t\${binary:Summary}\n" | fzf --tabstop=40 --sort --multi --preview-window=top:50% --preview "apt-cache show {1}" | cut -f 1)'
	PL() { apt-cache show $* && dpkg -L $*}
	compdef _deb_packages PL
	PS() { dpl $(dps $(whh $*) 1>&2 | cut -d: -f 1) }
	compdef _command_names PS
elif has yum; then
	alias PI='sudo yum -y install '
	alias PII='yum list | fzf --ansi --multi --preview-window=top:50% --preview "yum info {1}; rpm -ql {1}"; rehash'
	PL() { yum info $* && rpm -lq $*}
	# compdef _some_rpm_func PL
	PS() { PL $(rpm -qf $(whh $*)) }
	compdef _command_names PS
elif has port; then
	alias PII='sudo port install -v $(port list | fzf --multi --sort --preview-window=top:50%:wrap --preview "port info {1}" --bind "ctrl-g:execute(port gohome {1})" | cut -f 1)'
fi

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
	alias tff='(cd /var/log; sudo lnav syslog auth.log fail2ban.log audit/audit.log)'
else
	alias tff='err("lnav not found")'
fi

typeset -a ealiases
set_ealiases() {ealiases=($(alias | sed \
    -e s/=.\*// \
    -e s/\\./\\\\./g \
    -e /^l$/d \
    -e /^ls$/d \
    -e /^pst$/d \
    -e /^agii$/d \
    -e /^v$/d \
    # -e /^vl$/d \
))}; set_ealiases; alias sa=set_ealiases

expand_ealias() {
	if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)ealiases})$" ]]; then
		# print MATCH: $MATCH $MBEGIN $MEND
		zle _expand_alias
		# zle expand-word
	fi
	zle magic-space
}
bindkey_func ' ' expand_ealias
bindkey -M isearch ' '  magic-space # normal space during searches

setopt extendedglob # Only enable after definition of expand_ealias

function space_prepend {
    zle -U ' '
}
bindkey_func '^ ' space_prepend

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
			print -n -- $k: $v,\ 
	    done
	    print \)
	else
		print -- \ = ${(P)var} | tr \\n\\t ' ' | tr -s ' '; print
	    # print -- \ = "${(P)var}" 
	fi
    done 
}
compdef _parameter print_variables

pathprepend() {
    local path_element=$1
    [[ -z $path_element || ! -d $path_element ]] && return
    [[ -n $2 ]] && { print ERROR: only 'path' is supported; return }
    # local path_env_name=${2:-path}
    # path=($path_element $path)
    path=($path_element $path)
}

have() {
  unset have
  (( ${+commands[$1]} )) && have=yes
}

watch=notme
WATCHFMT="User %n from %M has %a at tty%l on %T %W"
logcheck=30

# Source external ressource files {{{
zsh_source ~/.environment
zsh_source ~/.fzf.zsh
zsh_source ~/.fzfrc

# type keychain > /dev/null && eval $(keychain --eval --timeout 3600 --quiet)
type keychain > /dev/null && eval $(keychain --eval --quiet)

# TODO: Think about a way how to select umask for sudo
# umask 027
# }}}
zstyle ':completion:*:processes' command 'ps --forest -o pid,%cpu,tty,cputime,cmd'
zmodload zsh/stat
[[ $(stat -L +size -- $HISTFILE) -lt 1000 ]] && print "WARNING: size of zsh history $HISTFILE is suspiciously low ($(cat $HISTFILE | wc -l) lines)." 
