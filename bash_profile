# bash history
export HISTCONTROL=ignoreboth
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT='%F %T '

[ -e ~/.bash_profile.$MYHOSTNAME ] && source ~/.bash_profile.$MYHOSTNAME
[ -e ~/.bashrc ] && source ~/.bashrc
