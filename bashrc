msource() { for f in $*; do [ -r "$f"  ] && source "$f"; done; }
msource $HOME/.bashrc.$(uname) $HOME/.bashrc.local

# change directory
alias .....='cd ../../../..'
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
source ~/.dotfiles/z/z.sh
alias c=z

# aosp
alias aospmm='aosp && cd external/boringssl && pwd && mm'
alias aosp='cd "$AOSP_HOME" && source build/envsetup.sh && export OUT_DIR_COMMON_BASE="$AOSP_HOME/out.$MYHOSTNAME" && lunch aosp_x86_64-eng'

# find
alias f=find
alias fdd='f . -type d'
alias ff='f . -type f'
alias ffn='ff -name'
gffn() { ffn "$1" -exec grep --color=auto -HE "$2" {} \; ; }
alias fgr='f . | grep -i --color=auto '

# git
alias gap='git add -pv && git commit -v'
alias gc='git commit -v'
alias gcv=gc
alias gca='git commit -va'
alias gcop='git checkout --patch'
alias gdf='git diff'
alias grp='git reset --patch'
alias gst='git status -sb'

# ls
alias l.='l -A'
alias l="ls -Ghl"
alias lt='l -tr'
alias l1="ls -1"

# vim alises
alias v='vim -X'
vs() { v "$1" && echo -e "\nSourcing \"$1\"..."; time source "$1"; echo -e "\nDone sourcing \"$1\"...";}
alias v.=vs
gv() { gvim "$*"; raiseX; }
alias last='v -S ~/.vim/lastsession'
alias glast='gv -S ~/.vim/lastsession'
alias vl=last
viminfo () { vim -R -c "Info $1 $2" -c "bdelete 1"; }
vimman () { vim -R -c "Man $1 $2" -c "bdelete 1"; }

# miscellaneous
alias TCPTRACEOPTS_minimal='export TCPTRACEOPTS="--noshowdupack3 --noshowsacks --noshowrexmit --noshowoutorder"'
alias TCPTRACEOPTS_normal='export TCPTRACEOPTS='
alias Xreseed="dd if=/dev/urandom count=1 2>/dev/null|md5|sed -e 's/^/add :0 . /'|tee /dev/stderr|xauth -q"
alias h=history
alias hgrep='history | grep -i $@'
alias hle='history | less +G -S'
alias le=$PAGER
alias loc='locate'
alias man='man -a'
alias p='ps axu | grep --color'
alias pst='pstree -wg3'
alias p_s='port search --line '
alias rm='rm -v'
alias tag=prompt_tag
g() { grep --color -Inri -- "$@" *; }
gw() { grep --color -Iwri -- "$@" *; }

src_index() {
		find . -name .repo -prune -o \
				-name .git -prune -o \
				-name out -prune -o \
				-type f \( \
						-name '*.c' -o \
						-name '*.cc' -o \
						-name '*.cpp' -o \
						-name '*.h' -o \
						-name '*.hpp' \
				\) > cscope.files && command cscope -bi cscope.files;
		ctags -R;
}

shopt -s autocd 
shopt -s cmdhist
shopt -s histappend
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
