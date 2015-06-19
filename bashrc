msource() { for f in $*; do [ -r $f  ] && source $f; done; }
msource $HOME/.bashrc.$(uname) $HOME/.bashrc.local

alias .....='cd ../../../..'
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias TCPTRACEOPTS_minimal='export TCPTRACEOPTS="--noshowdupack3 --noshowsacks --noshowrexmit --noshowoutorder"'
alias TCPTRACEOPTS_normal='export TCPTRACEOPTS='
alias Xreseed="dd if=/dev/urandom count=1 2>/dev/null|md5|sed -e 's/^/add :0 . /'|tee /dev/stderr|xauth -q"
alias f=find
alias fgr='find . | grep '
alias gca='git commit -va'
alias gdf='git diff'
alias gst='git status'
alias glast='gv -S ~/.vim/lastsession'
alias l.='l -A'
alias l="ls -Ghl"
alias last='v -S ~/.vim/lastsession'
alias le='less'
alias loc=locate
alias lt='l -tr'
alias ma='man -a'
alias o=open
alias pst='pstree -wg3'
alias p='ps axu | grep --color'
alias raiseX='osascript -e "tell application \"X11\"" -e "activate" -e "end tell"'
alias rm='rm -v'
alias v='vim -X'

cd() { if [ "$1" = "--" ]; then command popd; else if [ $# = 0 ]; then pushd $HOME; else command pushd "$@" >/dev/null; fi; fi; pwd >> $HOME/.cd_history; }
cdm() { cd "$(~/bin/cd.sh --most-often-used $@)"; }
cdr() { cd "$(~/bin/cd.sh --most-recently-used $@)"; }
cl() { cd "$@" && l;  }
function viminfo () { vim -R -c "Info $1 $2" -c "bdelete 1"; }
function vimman () { vim -R -c "Man $1 $2" -c "bdelete 1"; }
g() { grep --color -Inri -- "$@" *; }
gv() { gvim "$*"; raiseX; }
gw() { grep --color -Iwri -- "$@" *; }
rcd() { cd - && cd -; }
src_index() { find . | grep -E "\.cc?$|\.cpp$|\.hh?$|\.hpp$" > cscope.files && command cscope -bi cscope.files; ctags -R; }
vs() { v "$1" && echo -e "\nSourcing \"$1\"..."; time source "$1"; echo -e "\nDone sourcing \"$1\"...";}

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

complete -d cd rmdir pushd

source ~/.dotfiles/liquidprompt/liquidprompt

