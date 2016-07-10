export ZSH=/Users/dsh0/.dotfiles/oh-my-zsh
source $ZSH/oh-my-zsh.sh

zstyle ':dotzsh:load' timing 'yes'
zstyle ':dotzsh:module:*' timing 'yes'

# History
SAVEHIST=999999
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history_time
setopt complete_aliases

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle ':completion:*:default' list-colors  ${(s.:.)LS_COLORS}
zstyle ':completion:*:warnings' format 'No matches for: %d%b'

autoload run-help
eval $(gdircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)

source ~/.aliases
source ~/.environment
source ~/.fzfrc
source ~/.dotfiles/zsh-prompt-garrett/prompt_garrett_setup
bindkey -s '^l' 'clear\n'
