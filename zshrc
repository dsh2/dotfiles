
zstyle ':dotzsh:load' timing 'yes'
zstyle ':dotzsh:module:*' timing 'yes'

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
export ANDROID_AVD_HOME="$HOME/.android/avd/"
export ANDROID_SDK="$HOME/src/android-sdk"
export ANDROID_SDK_ROOT=$ANDROID_SDK
export ANDROID_HOME=$ANDROID_SDK
export ANDROID_NDK=$ANDROID_SDK/ndk-bundle
export NDK=$ANDROID_NDK
export AOSP_HOME="/Users/dsh0/VirtualBox/Shared/AndroidBuildEnvironment/aosp/"
export GRADLE_HOME=/opt/local/share/java/gradle
export PATH="$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools:$PATH"

# Switch profile of running iTerm2 window
it2prof() { echo -e "\033]50;SetProfile=$@\a"; }

export MANPATH="/opt/local/share/man:$MANPATH"

source ~/.aliases
source ~/.fzfrc
