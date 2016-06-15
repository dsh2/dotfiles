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
HIST_STAMPS="yyyy-mm-dd"

plugins=(adb)

export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:/Users/dsh0/src/android-sdk/platform-tools:/Users/dsh0/src/android-sdk/tools:/opt/local/share/luarocks/bin/:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/Users/dsh0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/MacGPG2/bin:/plattform-tools"
source $ZSH/oh-my-zsh.sh
source ~/.aliases
