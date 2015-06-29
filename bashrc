msource() { for f in $*; do [ -r "$f"  ] && source "$f"; done; }
msource $HOME/.bashrc.$(uname) $HOME/.bashrc.local

alias .....='cd ../../../..'
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'

alias TCPTRACEOPTS_minimal='export TCPTRACEOPTS="--noshowdupack3 --noshowsacks --noshowrexmit --noshowoutorder"'
alias TCPTRACEOPTS_normal='export TCPTRACEOPTS='
alias Xreseed="dd if=/dev/urandom count=1 2>/dev/null|md5|sed -e 's/^/add :0 . /'|tee /dev/stderr|xauth -q"
alias aospmm='aosp && cd external/boringssl && pwd && mm'
alias aosp='cd "$AOSP_HOME" && source build/envsetup.sh'

alias f=find
alias fd='f . -type d'
alias fgr='f . | grep -i --color=auto '

alias gca='git commit -va'
alias gdf='git diff'
alias gst='git status'

alias l.='l -A'
alias l="ls -Ghl"
alias lt='l -tr'

alias last='v -S ~/.vim/lastsession'
alias glast='gv -S ~/.vim/lastsession'

alias le=$PAGER
alias loc='locate'
alias ma='man -a'

alias p='ps axu | grep --color'
alias pst='pstree -wg3'

alias rm='rm -v'
alias v='vim -X'
alias c=z

alias tag=prompt_tag

function viminfo () { vim -R -c "Info $1 $2" -c "bdelete 1"; }
function vimman () { vim -R -c "Man $1 $2" -c "bdelete 1"; }
g() { grep --color -Inri -- "$@" *; }
gw() { grep --color -Iwri -- "$@" *; }
gv() { gvim "$*"; raiseX; }
src_index() { find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) > cscope.files && command cscope -bi cscope.files; ctags -R; }
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
source ~/.dotfiles/z/z.sh
