# Prompt
autoload -Uz vcs_info
autoload -U colors && colors
zstyle ':vcs_info:*' actionformats '%%F{136}[%F{240}%b%F{136}|%F{240}%a%F{136}]%f '
zstyle ':vcs_info:*' formats '%F{136}[%F{166}%b%F{136}]%f '
zstyle ':vcs_info:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' disable bzr tla
precmd() { vcs_info;  }
# PS1='%F{5}${fg[green]}[%F{2}%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%f%# '
# PS1="%{$fg_bold[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%# "
setopt PROMPT_SUBST 
PS4=PS4:%N:%i:
RPS1="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
PS1='%F{240}[%F{244}%n%F{240}] %F{136}%~ ${vcs_info_msg_0_}%f%# '
PS1=%F{240}$'${(r:$COLUMNS::\u2500:)}'$PS1

if [ type dircolors > /dev/null 2>&1 ]; then
		eval $(dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)
fi
export LS_COLORS

# ZLE
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
bindkey '^x^z' vi-cmd-mode
bindkey '^[' vi-cmd-mode
bindkey -M viins '^j' vi-cmd-mode
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'
function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e=' backward-kill-default-word   # = is next to backspace

function run-again-sudo {
	zle up-history
	zle beginning-of-line
	zle -U 'sudo '
}
zle -N run-again-sudo
bindkey '^X^S' run-again-sudo 

function run-again-in-lnav {
	zle up-history
	zle -U '|&lnav'
}
zle -N run-again-in-lnav
bindkey '^X^L' run-again-in-lnav 

function run-again-in-vp {
	zle up-history
	zle -U ' |&vp'
}
zle -N run-again-in-vp
bindkey '^X^X' run-again-in-vp 
function run-again-in-fzf {
	zle up-history
	zle -U '|&fzf'
}
zle -N run-again-in-fzf
bindkey '^X^F' run-again-in-fzf 

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# complete words from tmux pane(s) {{{1
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
# }}}

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

# Aliases
source ~/.aliases
typeset -a ealiases
ealiases=(`alias | sed -e 's/=.*//'`)

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
# bindkey '^M' _expand-ealias-and-execute
bindkey '^ ' magic-space          # control-space to bypass completion
bindkey -M isearch " "  magic-space # normal space during searches

# History
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
zshaddhistory() {
	print -sr -- ${1%%$'\n'}
	# TODO: Add white or blacklist which path to put zsh_local_history in (e.g. ~/src/*)
	fc -p .zsh_local_history
}

# Completion
fpath=(~/.dotfiles/zsh-completions/ $fpath)
fpath=(~/.dotfiles/zsh/zsh-completions/src $fpath)
autoload -U compinit && compinit
zmodload zsh/complist

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M emacs '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^h' backward-char

#zstyle ':completion:*' completions 1
#zstyle ':completion:*' glob 1
#zstyle ':completion:*' matcher-list ''kk
#zstyle ':completion:*' max-errors 2
#zstyle ':completion:*' substitute 1
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
setopt interactivecomments
setopt autocd
setopt cdablevars
setopt prompt_subst

REPORTTIME=10

autoload run-help

#eval $(dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)

source ~/.environment
source ~/.fzf.zsh
source ~/.fzfrc

stty -ixon
source ~/.dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
