export ZSH=/Users/dsh0/.dotfiles/oh-my-zsh


ZSH_THEME="bureau"

zstyle ':dotzsh:load' timing 'yes'
zstyle ':dotzsh:module:*' timing 'yes'

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"

#
# Options
#

# History
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

plugins=(adb osx)

export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:/Users/dsh0/src/android-sdk/platform-tools:/Users/dsh0/src/android-sdk/tools:/opt/local/share/luarocks/bin/:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/Users/dsh0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/MacGPG2/bin:/plattform-tools"
source $ZSH/oh-my-zsh.sh
source ~/.aliases

autoload -Uz compinit
compinit

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
eval $(gdircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)
zstyle ':completion:*:default' list-colors  ${(s.:.)LS_COLORS}

autoload run-help

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--bind "ctrl-v:execute(vim {})"
		--bind "ctrl-o:execute(less {})"
		--bind "ctrl-q:execute(print-query)"
		--history=/Users/dsh0/.fzf_history
		--inline-info'

fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# ftpane - switch pane (@george-b)
ftpane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}

# c - browse chrome history
gch() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{{::}}'

  # Copy History DB to circumvent the lock
  # - See http://stackoverflow.com/questions/8936878 for the file path
  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

export ANDROID_AVD_HOME="/Users/dsh0/.android/avd/"
export ANDROID_SDK="$HOME/src/android-sdk"
export ANDROID_SDK_ROOT=$ANDROID_SDK
export ANDROID_HOME=$ANDROID_SDK
export ANDROID_NDK=$ANDROID_SDK/ndk-bundle
export NDK=$ANDROID_NDK
export AOSP_HOME="/Users/dsh0/VirtualBox/Shared/AndroidBuildEnvironment/aosp/"
export GRADLE_HOME=/opt/local/share/java/gradle
export PATH="$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
export VIEW_PDF=/usr/bin/open
export VIEW_POSTSCRIPT=/usr/bin/open

# Switch profile of running iTerm2 window
it2prof() { echo -e "\033]50;SetProfile=$@\a"; }

__fzfz() {
  local cmd="z -l | awk '{print \$2}'"
  eval "$cmd" | fzf -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzfz-file-widget() {
  LBUFFER="${LBUFFER}$(__fzfz)"
  zle redisplay
}

zle     -N   fzfz-file-widget
bindkey '^G' fzfz-file-widget

export PATH="$PATH:$ANDROID_SDK/plattform-tools"
export MANPATH="/opt/local/share/man:$MANPATH"

