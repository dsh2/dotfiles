msource() { for f in $*; do [ -r "$f" ] && source "$f"; done; }
msource \ 
		$HOME/.aliases \
		$HOME/.bashrc.$(uname) \
		$HOME/.bashrc.local

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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
