#!env zsh
TMUX_LOG=~/.tmux-log

setopt extendedglob
setopt monitor
setopt notify 
usage="${0:t} [-e|--edit] zsh-history-event-number"

if ! zparseopts -D \
    e=EDIT -edit=EDIT; \
then
    print $usage
    exit 1
fi

if [[ $# < 1 ]]; then
    print $usage
    exit 1

fi
log_num=$1
shift

# Parse number of history event
if [[ ! $log_num = <-> ]]; then
    # TODO: Try to understand what I am doing here...
    log_num=${1[(ws:-:)1]}
    log_parm=${1[(ws:-:)2,-1]}
fi

log_file=$TMUX_LOG/$log_num
if [ ! -f $log_file ]; then
    print OUTPUT: No execution log captured
    exit 0
fi
# TODO: check if log_file is compressed 

if [[ -n $EDIT ]]; then
    # ${=EDITOR} $log_file
    vim $log_file
    exit $?
fi

print SIZE: \
    ${${$(wc $log_file):gfs,  , ,:gs, ,/,}[1,3]} \
    "("${$(du -h --apparent-size $log_file)[1]}")"
# print DIR: $(locate .zsh_local_history | xargs grep --color ')
# TODO: fix the following line sepeartor to respect full screen width
print -P ${(r:$COLUMNS * 4 - 16 ::\u2d:)} 
head -1000 $log_file | sed -e 's,$,,' -e '$ d' 
print -P ${(r:$COLUMNS * 4 - 16 ::\u2d:)} 
exit 0
