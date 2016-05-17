msource() { for f in $*; do [ -r "$f" ] && source "$f"; done; }
msource \ 
		$HOME/.aliases \
		$HOME/.bashrc.$(uname) \
		$HOME/.bashrc.local

ash() {
		[ -z "$ANDROID_SERIAL" ] && ANDROID_SERIAL=$(adb get-serialno 2> /dev/null)
		[ -z "$ANDROID_SERIAL" ] && ( echo No Android device found...; exit 1 )
		type prompt_tag > /dev/null 2>&1 && prompt_tag "[ANDROID_SERIAL=$ANDROID_SERIAL]"
		echo $ANDROID_SERIAL: $@
		adb shell $@
}
alias a_=ash
a__() { ash /data/app/dsf/$@; }


shopt -s autocd 
shopt -s cdable_vars
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -s histappend
shopt -s histverify
shopt -s hostcomplete
shopt -u interactive_comments
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s dotglob
shopt -s nocaseglob

ulimit -c unlimited
stty -ixon

complete -d cd rmdir pushd
source ~/.dotfiles/VBoxManage-completion/VBoxManage-completion.bash
source ~/.dotfiles/z/z.sh
[ -f $AOSP_HOME/sdk/bash_completion/adb.bash ] && source $AOSP_HOME/sdk/bash_completion/adb.bash

_logdog() {
    local tag=${COMP_WORDS[COMP_CWORD]}
    procs="$(adb shell pm list packages $tag | sed -e 's/package://')"
    COMPREPLY=($(compgen -W "$procs" -- $tag))
}
complete -o default -o nospace -F _logdog logdog

# Setup prompt
if [ "$MYHOSTNAME" != "P3-01882" ]; then
		if ! grep -q __lp_set_prompt <<< $PROMPT_COMMAND; then
				source ~/.dotfiles/liquidprompt/liquidprompt
		fi
fi
if ! grep -q history <<< $PROMPT_COMMAND; then
		export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
fi

if [ type dircolors > /dev/null 2>&1 ]; then
		eval $(dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark)
fi
export LS_COLORS

alias file='file -ikpz'
alias d2='dnf-2'
alias sx='screen -X'
alias sxt='sx title'
a_pidof() { echo $(adb shell ps "$@" | cut -c 8-15 | sed s,PID,,); }
alias ssv2csv="gsed -re 's/([^ \"]*|\"[^\"]*\") /\1,/g; s/\"([^\"]*)\"/\1/g'"
