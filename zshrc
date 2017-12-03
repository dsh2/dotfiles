# vim: set foldmethod=marker foldlevel=0:

# Prompts {{{
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
precmd() { vcs_info; }

# Main prompt {{{
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u2500:)}'
# LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 0))::\u2500:)}'$'\n'
LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 0))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u257c:)}%{$reset_color%}'
PS1=$LINE_SEPARATOR					# Add horizontal separator line
PS1+='%F{240}%(1j.[%{$fg_no_bold[red]%}%j%F{240}].)'	# Add number of jobs - if any
# PS1+='%F{240}[%F{244}%n%F{240}] '	# Add user name
PS1+='%F{240}[%F{244}(%!)%n%F{240}] '	# Add user name
PS1+='%F{136}%~ '					# Add current directory
PS1+='${vcs_info_msg_0_}'			# Add vcs info
PS1+='%(0?..%F{244}| err=%{$fg_no_bold[red]%}%? )'	# Add exit status of last job
PS1+='%f%# '						# Add user status
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
PS4=PS4:%N:%i:
# }}}
# }}}

# Dircolors {{{
if [ type dircolors > /dev/null 2>&1 ]; then
	eval $(dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)
fi
export LS_COLORS
# }}}

# History {{{
SAVEHIST=999999
HISTSIZE=$SAVEHIST
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"
setopt complete_aliases
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history_time
setopt no_bang_hist
setopt no_hist_ignore_all_dups
setopt no_hist_ignore_dups
# HISTORY_IGNORE="(^[[:space:]]+.*$)"
zshaddhistory() {
	# echo zshaddhistory: checking line \"${1%%$'\n'}\"...
	# if [[ "$1" =~ $HISTORY_IGNORE ]]; then
	# echo zshaddhistory: found match \"$MATCH\"
	# echo zshaddhistory: line skipped
	# return 1
	# fi
	# echo zshaddhistory: line NOT skipped
	print -sr -- ${1%%$'\n'}
	# TODO: Add white or blacklist which path to put zsh_local_history in (e.g. ~/src/*)
	fc -p .zsh_local_history
}
# }}}

# ZLE {{{
zle_highlight=( \
	default:fg=default,bg=default \
	# default:fg=213,bg=red,underline \
	region:underline \
	special:fg=black,bg=red \
	suffix:bold \
	isearch:underline \
	paste:standout \
	)

bindkey -e
bindkey '^[' vi-cmd-mode
bindkey -M viins '^j' vi-cmd-mode
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'

function _backward_kill_default_word() {
	WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
bindkey '^?' undo

zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e=' backward-kill-default-word   # = is next to backspace

function run-again-sudo {
	zle up-history
	zle beginning-of-line
	zle -U 'sudo '
}
zle -N run-again-sudo
bindkey '^X^S' run-again-sudo

function xo-command {
	zle up-history
	zle -U ' | xc'
}
zle -N xo-command
bindkey '^X^O' xo-command

function xp-command {
	zle up-history
	zle beginning-of-line
	zle -U 'xp '
}
zle -N xp-command
bindkey '^X^P' xp-command

function last-output-vp {
	# zle up-history
	# less ~/.tmux-log/$(($(print -P '%!')-1))
	# TODO: Make this work without tmux. Read man zshzle!
	# TODO(zsh): Somehow use (%)-flag 
	tmux split -bp 75 vim ~/.tmux-log/$(($(print -P '%!')-1)) +AnsiEsc
	tmux resize-pane -Z
}
zle -N last-output-vp
bindkey '^X^X' last-output-vp

function last-output-fzf {
	zle up-history
	# zle -U ' |&fzf --ansi --multi'
	cat ~/.tmux-log/$(($(print -P '%!')-1)) | fzf --tac --multi --no-sort
}
zle -N last-output-fzf
bindkey '^X^F' last-output-fzf

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Open man in tmux pane if possible
# TODO: Strip obvious cruft like like sudo and paths
if [ -z "$TMUX" ]; then
    bindkey '^[H' run-help
else
run-help-tmux() {
    COMMANDS=("${=LBUFFER}")
    # tmux split -vbp 80 vim -R -c "Man ${COMMANDS[1]}" -c "bdelete 1" -c "setlocal nomodifiable"
    tmux split -vbp 80 $SHELL -ic "vimman ${COMMANDS[1]}"
    zle redisplay
}
zle -N run-help-tmux
bindkey '^[H' run-help-tmux
fi

# complete words from tmux pane(s)
# Source: http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
function tmux_pane_words() {
	local expl
	local -a w
	if [[ -z "$TMUX_PANE" ]]; then
		_message "not running inside tmux!"
		return 1
	fi
	# capture current pane first
	w=( ${(u)=$(tmux capture-pane -J -p)} )
	for i in $(tmux list-panes -F '#P'); do
		# skip current pane (handled above)
		[[ "$TMUX_PANE" = "$i" ]] && continue
		w+=( ${(u)=$(tmux capture-pane -J -p -t $i)} )
	done
	_wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^v^V' tmux-pane-words-prefix
bindkey '^v^v' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

function _start_tmux_logging() 
{ 
    # TODO: Add colors to output
    print -P $LINE_SEPARATOR
    print literal:  $1
    # print compact command = \"$2\"
    print full: $3
    print -P $LINE_SEPARATOR
    # TODO: Do not log for
    # -vim, hop
    # TODO: Add logging for
    # -exit code
    # -directory (in case .zsh_local_history is not possible)
    # -environment
    # -literal and full command
    # -report times
    # -name of tmux session name
    whence tmux > /dev/null && 
	tmux has-session >& /dev/null && 
	mkdir -p ~/.tmux-log && 
	tmux pipe-pane 'cat > ~/.tmux-log/'$(print -P '%!')
}

function _stop_tmux_logging() 
{ 
    whence tmux > /dev/null && 
	tmux has-session >& /dev/null && 
	tmux pipe-pane 
}

autoload -U add-zsh-hook
add-zsh-hook preexec _start_tmux_logging
add-zsh-hook precmd _stop_tmux_logging

function _showbuffers()
{
	local nl=$'\n' kr
	typeset -T kr KR $'\n'
	KR=($killring)
	typeset +g -a buffers
	buffers+="      Pre: ${PREBUFFER:-$nl}"
	buffers+="  Buffer: $BUFFER$nl"
	buffers+="     Cut: $CUTBUFFER$nl"
	buffers+="       L: $LBUFFER$nl"
	buffers+="       R: $RBUFFER$nl"
	buffers+="Killring:$nl$nl$kr"
	zle -M "$buffers"
}
zle -N showbuffers _showbuffers
bindkey "^[o" showbuffers

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
fpath+=~/.dotfiles/zsh/zsh-completions-org/src/
fpath+=~/.dotfiles/zsh/zsh-hub-completion/
fpath+=~/.dotfiles/zsh/zsh-socat-completion/
fpath+=~/.dotfiles/zsh/zsh-completions/src
fpath+=~/.zplug/repos/robbyrussell/oh-my-zsh/plugins/pip/
fpath+=~/.zplug/repos/robbyrussell/oh-my-zsh/plugins/gem/

autoload -U compinit && compinit
zmodload zsh/complist

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^h' backward-char

# TODO: Add comments what we suppose to achive with all the zstyles
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _prefix _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' list-dirs-first false
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-separator "--"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No matches for: %d%b --\e[0m'

setopt nomenu_complete
setopt auto_list
setopt auto_menu
setopt list_ambiguous
# }}}

# Shell options {{{
autoload run-help
setopt interactivecomments
setopt autocd
setopt autopushd
set push
setopt cdablevars
stty -ixon

REPORTTIME=3
TIMEFMT='REPORTTIME for job "%J": runtime = %E, user = %U, kernel = %S, swapped = %W, shared = %X KiB, unshared = %D KiB, major page = %F, minor page = %R, input = %I, output = %O, recv = %r, sent = %s, waits = %w, switches = %c'

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main line brackets)
source ~/.dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[redirection]='fg=red,underline'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,bold,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey,bold'
# }}}

# Setup aliases {{{
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
source ~/.aliases
typeset -a ealiases
ealiases=($(alias | sed -e s/=.\*// -e /l/d -e /ls/d))

_expand-ealias() {
# TODO: add blacklist for specific aliases not to be expanded
if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)ealiases})\$" ]]; then
    zle _expand_alias
    zle expand-word
fi
zle magic-space
}
_expand-ealias-and-execute() {
    _expand-ealias
    zle accept-line
}

zle -N _expand-ealias
zle -N _expand-ealias-and-execute
bindkey ' ' _expand-ealias
bindkey -M isearch ' '  magic-space # normal space during searches

function space-prepend {
    zle -U ' '
}
zle -N space-prepend
bindkey '^ ' space-prepend
# }}}

pathprepend() {
    local path_element=$1
    [ -z $path_element ] && return
    local -l path_env=${2:-path}
    integer path_index=${${(P)path_env}[(i)$1]}
    (($path_index <= ${#${(P)path_env}})) && eval "${path_env}[$path_index]=()"
    eval "${path_env}=($path_element ${(P)path_env})"
}
# External ressource files {{{
source ~/.environment
source ~/.fzf.zsh
source ~/.fzfrc
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
# }}}
