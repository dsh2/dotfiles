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
LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 1))::-:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 1))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$((COLUMNS - 0))::\u2500:)}%{$reset_color%}'
# LINE_SEPARATOR=%F{240}$'${(r:$COLUMNS::\u257c:)}%{$reset_color%}'
PS1=$LINE_SEPARATOR					# Add horizontal separator line
# PS1+=$'\r'$'\f'
PS1+=$'\n'
PS1+='%F{240}%(1j.[%{$fg_no_bold[red]%}%j%F{240}].)'	# Add number of jobs - if any
PS1+='(%!) '						# Add number of next shell event
PSVAR+=$SSH_TTY
PS1+='%F{255}[%F{244}%n%'				# Add user name
PS1+='(1V.%{$fg_no_bold[red]%}@%m.)'			# Add host name for ssh connections
PS1+='%F{255}] '	
PS1+='%F{136}%~ '					# Add current directory
PS1+='${vcs_info_msg_0_}'				# Add vcs info
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
type dircolors > /dev/null && DIR_COLORS=dircolors
type gdircolors > /dev/null && DIR_COLORS=gdircolors
if [ -n $DIR_COLORS ]; then
    eval $($DIR_COLORS ~/.dotfiles/colors/dircolors-solarized/dircolors.256dark)
    # eval $($DIR_COLORS ~/.dotfiles/colors/dircolors-solarized/dircolors.ansi-light)
    export LS_COLORS
fi
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
setopt no_inc_append_history_time
setopt no_inc_append_history
setopt share_history
setopt no_bang_hist
setopt no_hist_ignore_all_dups
setopt no_hist_ignore_dups

# TODO: Tidy this mess up: do not log empty lines
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

function repeat_immediately {
    zle up-history
    zle accept-line
}
bindkey_func '^j' repeat_immediately

function focus_backgroud {
    [[ $#BUFFER -eq 0 ]] && fg
    # TODO: || think about something other useful
}
bindkey_func '^z' focus_backgroud

WORDCHARS='*?_-.[]~=&!#$%^(){}<>|'
function backward_kill_default_word() {
    WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' 
    zle backward-kill-word
}
bindkey_func '\e=' backward_kill_default_word   # = is next to backspace

function kill-line-xclip {
    zle kill-line
    echo $CUTBUFFER | xclip -selection clipboard -in
}
bindkey_func '^k' kill-line-xclip

# Copy last command to xclipboard
function copy_last_command {
	zle up-history
	zle kill-whole-line
	echo $CUTBUFFER | xclip -selection clipboard -in
}
bindkey_func '^x^k' copy_last_command

# Copy last command's output to xclipboard
function copy_last_output {
    [ -z $tmux_log_file ] && return
    echo LOG: $tmux_log_file 
    cat $tmux_log_file | xclip -selection clipboard -in
}
bindkey_func '^x^o' copy_last_output

function page_last_output {
	# less ~/.tmux-log/$(($(print -P '%!')-1))
	# TODO: Make this work without tmux. Read man zshzle!
	# TODO(zsh): Somehow use (%)-flag 
	tmux split -bp 80 vim ~/.tmux-log/$(($(print -P '%!')-1)) '+set buftype=nofile' +AnsiEsc '+set ff=unix' 
	# tmux resize-pane -Z
}
bindkey_func '^x^x' page_last_output

function filter_last_output {
    RBUFFER=$(
	(cat ~/.tmux-log/$(($(print -P '%!')-1)) | 
	    sed -e 's,$,,' -e '$ d' ;
	    print -P $LINE_SEPARATOR )|
	    fzf --tac --multi --no-sort
	    # TODO: Add preview to show various transformations of 
	    # current line, i.e. filter IP, numbers, strings, etc
	    # and add shortcuts to select them as return value
    )
    zle redisplay
}
# bindkey_func '^l^l' filter_last_output
bindkey_func '^o' filter_last_output

function diff_last_two_outputs {
    tmux new-window vimdiff \
	~/.tmux-log/$(($(print -P '%!')-2)) \
	~/.tmux-log/$(($(print -P '%!')-1)) \
	"+ map q Q"
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

bindkey -s rq "r2 -Nqc '' -"

function start_tmux_logging() 
{ 
    tmux_log_file=$HOME/.tmux-log/$(print -P '%!') &&
    # TODO: Add colors to output
    export ZSH_DEBUG=1
    print -P $LINE_SEPARATOR
    if [[ -v $ZSH_DEBUG ]]; then
	# print -l params = \"$@\"
	print literal = \"$1\"
	# print compact: \"$2\"
	print full: \"$3\"
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
    # -add more sensible stuff here
    # -check esc sequences instead of wmctrl
    # -move seq to term_title alias
    wmctrl -r :ACTIVE: -N "$(pwd) [$USER@${HOST}]"
    return 0
}

autoload -U add-zsh-hook
add-zsh-hook precmd set_terminal_title

if whence tmux > /dev/null \
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
fpath+=~/.dotfiles/zsh/zsh-completions-org/src/
fpath+=~/.dotfiles/zsh/zsh-completions-org/src/
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
source ~/.dotfiles/src/t/etc/t-completion.zsh
compdef _t t
source ~/.dotfiles/colors/dynamic-colors/completions/dynamic-colors.zsh

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^l^l' forward-char
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
# [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
source ~/.aliases
typeset -a ealiases
ealiases=($(alias | sed \
    -e s/=.\*// \
    -e s/\\./\\\\./g \
    -e /^l$/d \
    -e /^ls$/d \
    -e /^pst$/d \
    # -e /^vl$/d \
))

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

function space_prepend {
    zle -U ' '
}
bindkey_func '^ ' space_prepend

env_vars() {
    LBUFFER="$LBUFFER$(print_variables |
	fzf \
	    --tac --multi \
	    --preview 'typeset -p {1}; echo {} | pygmentize -l zsh' \
    LBUFFER="$LBUFFER echo $( typeset | fzf | cut -d= -f1 | sed -e 's,^,$,' )"
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
	    print -- \ = ${(P)var}
	fi
    done 
}
compdef _parameter print_variables

pathprepend() {
    local path_element=$1
    [ -z $path_element ] && return
    local path_env_name=${2:-path}
    # print_variables path_env_name path_element
    # echo -n typeset:
    # typeset $path_env_name
    if [[ -n ${(P)path_env_name} ]]; then
	# print NOT empty
	integer path_element_index=${${(P)path_env_name}[(i)$1]}
	if (($path_element_index <= ${#${(P)path_env_name}})) then
	    eval "${path_env_name}[$path_element_index]=()"
	fi
	eval "${path_env_name}=($path_element ${(P)path_env_name})"
    else
	# print EMPTY
	eval "${path_env_name}=($path_element)"
    fi
    # echo -n typeset:
    # typeset $path_env_name
    # echo path: ${(P)path_env_name}
    # HACK: rework this whole thing!
    eval "${path_env_name}=($path_element ${(P)path_env_name})"
}

bash_source() {
  alias shopt=':'
  alias _expand=_bash_expand
  alias _complete=_bash_comp
  emulate -L sh
  setopt kshglob noshglob braceexpand
  source "$@"
}

have() {
  unset have
  (( ${+commands[$1]} )) && have=yes
}

watch=notme
WATCHFMT="User %n from %M has %a at tty%l on %T %W"
logcheck=30

# External ressource files {{{
source ~/.environment
source ~/.fzf.zsh
source ~/.fzfrc

type keychain > /dev/null && eval $(keychain --eval --timeout 360 --quiet)

# TODO: Think about a way how to select umask for sudo
# umask 027

# TODO: Implement this
function in_array() {
    prl $1 $2
    prl ${1[(i)$2]} 
    prl ${#2}
    [[ ${1[(i)$2]} -gt 0 ]]
    prl ret = $?
    return $?
}

# }}}
