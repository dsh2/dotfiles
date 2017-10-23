#!/usr/bin/env zsh
TMUX_LOG=~/.tmux-log

setopt extendedglob
setopt monitor
setopt notify 
usage="${0:t} [-e|--edit] [-s|--show] zsh-history-event-number"

if ! zparseopts -D \
    D=DEBUG -debug=DEBUG \
    s=SHOW -show=SHOW \
    e=EDIT -edit=EDIT; \
then
    print $usage
    exit 1
fi

log_num=$1
shift
if [[ -n $1 ]]; then
    print $usage
    exit 1
fi

# Parse number of history event
if [[ ! $log_num = <-> ]]; then
    log_num=${1[(ws:-:)1]}
    log_parm=${1[(ws:-:)2,-1]}
fi

log_file=$TMUX_LOG/$log_num
if [ ! -f $log_file ]; then
    print OUTPUT: No execution log captured
    exit 0
fi
# TODO: check if log_file is compressed 

if [[ -n $SHOW ]]; then
    print OUTPUT: ${$(cat $log_file | wc):gfs,  , ,:gs, ,/,} 
    # "("$(du -sm $log_file)" MiB)"
    head -10 $log_file
fi

if [[ -n $EDIT ]]; then
    # ${=EDITOR} $log_file
    vim $log_file
fi

exit 0
