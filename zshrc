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
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>='
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

function run-again-in-fzf {
	zle up-history
	zle -U '|&fzf'
}
zle -N run-again-in-fzf
bindkey '^X^F' run-again-in-fzf 

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

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

bindkey ' '    _expand-ealias
bindkey '^ '   magic-space          # control-space to bypass completion
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
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
autoload -U colors && colors
#zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _prefix
zstyle ':completion:*' completer _oldlist _expand _complete 
#zstyle ':completion:*' completions 1
zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' verbose true
zstyle ':completion:*' list-dirs-first true
#zstyle ':completion:*' matcher-list ''
#zstyle ':completion:*' max-errors 2
#zstyle ':completion:*' substitute 1
zstyle ':completion:*' menu select
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:warnings' format 'No matches for: %d%b'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
setopt menu_complete 

setopt autocd
setopt cdablevars
setopt prompt_subst

autoload run-help

#eval $(dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)

source ~/.environment
source ~/.fzf.zsh
source ~/.fzfrc

stty -ixon
