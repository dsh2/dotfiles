# Zplug init
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh
#zplug 'themes/sorin', from:oh-my-zsh, nice:11
zplug 'themes/blinks', from:oh-my-zsh, use:"*.zsh-theme", nice:10
zplug 'themes/jonathan', from:oh-my-zsh, use:"*.zsh-theme", nice:10
zplug check || zplug install
zplug load

# ZLE
bindkey -e
bindkey '^x^z' vi-cmd-mode
bindkey -M viins '^j' vi-cmd-mode
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
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
	zle -U '|&vp'
}
zle -N run-again-in-vp
bindkey '^X^X' run-again-in-vp 

function show-aliases {
	zle up-history
	zle -U '|&vp'
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
_tmux_pane_words() {
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
bindkey '^v^v' tmux-pane-words-prefix
bindkey '^v^V' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
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
  if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)ealiases})\$" ]]; then
    zle _expand_alias
    zle expand-word
  fi
  zle magic-space
}

zle -N _expand-ealias
bindkey ' ' _expand-ealias
bindkey '^ ' magic-space          # control-space to bypass completion
bindkey -M isearch " "  magic-space # normal space during searches

# History
SAVEHIST=999999
HISTSIZE=$SAVEHIST
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"
setopt extended_history
setopt hist_find_no_dups
setopt no_hist_ignore_all_dups
setopt no_hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history_time
setopt complete_aliases

# Completion
fpath=(~/.dotfiles/zsh-completions/ $fpath)
autoload -U compinit && compinit
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M emacs '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^h' backward-char
autoload -U colors && colors
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _prefix _approximate
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' completions 1
zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-dirs-first false
#zstyle ':completion:*' matcher-list ''kk
#zstyle ':completion:*' max-errors 2
#zstyle ':completion:*' substitute 1
zstyle ':completion:*' menu select
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:warnings' format 'No matches for: %d%b'
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
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
