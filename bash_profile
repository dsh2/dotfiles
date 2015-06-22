export PATH=$HOME/bin:$PATH:/usr/local/bin:/usr/local/sbin
export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export ANDROID_SDK=$HOME/src/adt-bundle-mac-x86_64-20140702/sdk
export PATH=$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools
export AOSP_HOME=/Volumes/AndroidBuildEnvironment/aosp

export MANPATH=/opt/local/share/man:$MANPATH

export HISTCONTROL=ignoreboth
export HISTFILESIZE=32767
export HISTSIZE=32767
export HISTTIMEFORMAT='%T'
CDHISTFILE=$HOME/.cd_history

export LESS=RMiwS
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export GIT_PAGER='less -F'
export BC_ENV_ARGS="-q $HOME/.bcrc"
export XENVIRONMENT=$HOME/.Xresources
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export VISUAL='vim -X'
export EDITOR=$VISUAL
export PAGER=less
CUSTOM_TITLE=0
export VIEW_PDF=/usr/bin/open
export VIEW_POSTSCRIPT=/usr/bin/open
export HTML_TIDY=~/.tidy_config
export USE_CCACHE=1
export GREP_COLOR=auto

if [ ! $SSH_TTY ]; then
	if [ -z $DISPLAY  ]; then
		export DISPLAY=:0.0
	fi
fi

[ -f ~/.bashrc ] && . ~/.bashrc
