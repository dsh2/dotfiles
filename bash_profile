export PATH=$HOME/bin:$PATH:/usr/local/bin:/usr/local/sbin
export PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export MANPATH=/opt/local/share/man:$MANPATH

export HISTCONTROL=ignoreboth
export HISTFILESIZE=32767
export HISTSIZE=32767
export HISTTIMEFORMAT='%T'
CDHISTFILE=$HOME/.cd_history

export LESS=RMiwS
export GIT_PAGER='less -F'
#export LESSOPEN="| $HOME/bin/lesspipe.sh %s"
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

if [ ! $SSH_TTY ]; then
	if [ -z $DISPLAY  ]; then
		export DISPLAY=:0.0
	fi
fi

# Change the Window Title
case "$TERM" in
	xterm*|rxvt*)
		export PROMPT_COMMAND='if [ "$CUSTOM_TITLE" = "0" ]; then echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"; fi' ;;
	screen*)
		export PROMPT_COMMAND='if [ "$CUSTOM_TITLE" = "0" ]; then echo -ne "\033k\033\\"; fi' ;;
	*)
	;;
esac

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

[ "${HOSTNAME/.*/}" = "dasmacbookpro.local" -o "$HOSTNAME" = "localhost" ] && HOST_COLOR='\[\e[32;40m\]' || HOST_COLOR='\[\e[31;40m\]'
[ "$(whoami)" = "root" ] && USER_COLOR='\[\e[31;40m\]' || USER_COLOR='\[\e[32;40m\]'
#[ -z "$WINDOW" ] && WINDOW_STR="" || WINDOW_STR=\($WINDOW\)
export PS1=$USER_COLOR'\u\[\e[1;36m\]@'$HOST_COLOR'\h\[\e[00m\]'$WINDOW_STR'$(RC=$?;[ $RC -ne 0 ] && echo [\[\e[31\;40m\]rc = $RC\[\e[0\;0m\]]):\[\e[01;34m\]\w\[\e[00m\] $(while [ "$PWD" != "/" ]; do BRANCH=$(cat .git/HEAD 2>/dev/null); if [ $? -eq 0 ]; then echo \(${BRANCH/*\//}\); break; else cd ..; fi; done)\$ '


if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

[ -f ~/.bashrc ] && . ~/.bashrc
