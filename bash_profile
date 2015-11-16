# bash history
export HISTCONTROL=ignoreboth
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT='%F %T '

# path
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"

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
export LS_COLORS='no=00:di=33;01:tw=33;01:ow=33;01:fi=00:ln=00:pi=00:so=00:bd=00:cd=00:or=00:mi=00:ex=00:*.sh=31:*.sh=31:*.exe=31:*.bat=31:*.com=31'
#export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export SSLKEYLOGFILE=~/.ssl_key_log

# miscellaneous
export BC_ENV_ARGS="-q $HOME/.bcrc"
export XENVIRONMENT=$HOME/.Xresources

if [ ! $SSH_TTY ]; then
	if [ -z $DISPLAY  ]; then
		export DISPLAY=:0.0
	fi
fi

export MYHOSTNAME=${HOSTNAME/.*/}
[ -e ~/.bash_profile.$MYHOSTNAME ] && source ~/.bash_profile.$MYHOSTNAME
[ -e ~/.bashrc ] && source ~/.bashrc

