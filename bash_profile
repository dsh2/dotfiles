# bash history
export HISTCONTROL=ignoreboth
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT='%F %T '

# path
pathprepend() {
    if [ -d "$1" ] && [[ ! $PATH =~ (^|:)$1(:|$) ]]; then
        PATH=$1:$PATH
    fi
}

export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="$PATH:$ANDROID_SDK/plattform-tools"
export MANPATH="/opt/local/share/man:$MANPATH"
pathprepend "/opt/local/share/luarocks/bin/"

# pager
# export PAGER=~/.dotfiles/vimpager/vimpager
export LESS=cRMiWSJ
export PAGER=less
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export GIT_PAGER='less -F'
alias less=$PAGER
alias zless=$PAGER

# l10n
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# editor
export VISUAL='vim -X'
export EDITOR=$VISUAL

export HTML_TIDY=~/.tidy_config
export USE_CCACHE=1
# export GREP_COLOR=auto
export SSLKEYLOGFILE=~/ssl_key_log

# miscellaneous
export BC_ENV_ARGS="-q $HOME/.bcrc"
export HH_CONFIG=hicolor
export XENVIRONMENT=$HOME/.Xresources

if [ ! $SSH_TTY ]; then
	if [ -z $DISPLAY  ]; then
		export DISPLAY=:0.0
	fi
fi

export MYHOSTNAME=${HOSTNAME/.*/}
[ -e ~/.bash_profile.$MYHOSTNAME ] && source ~/.bash_profile.$MYHOSTNAME
[ -e ~/.bashrc ] && source ~/.bashrc
