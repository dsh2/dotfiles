#!env zsh
die() { print "$@"; exit 1 ; }
setopt extendedglob
setopt monitor
setopt notify 
usage="${0:t} [-e|--edit] zsh-log-timestamp"
set -x

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
# We get log_timestamp from command line because deriving timestamp in non-interactive zsh (or even zsh -i) seems to be non-trivial
set -v
log_timestamp=$1
[[ $log_timestamp = "-" ]] && read log_timestamp
[[ -z $log_timestamp ]] && die "Failed to derive log_timestamp." 
log_dir=${ZSH_LOGS:-$HOME/.logs/zsh/}/$log_timestamp
[[ -z $log_dir ]] && die "Failed to derive log_dir." 
log_file=$log_dir/output
[[ ! -f $log_file ]] && die "No execution log captured."
# TODO: check if log_file is compressed 
[[ -n $EDIT ]] && { ${EDITOR:-vim} $log_file; exit $? }

print SIZE: \
    ${${$(wc $log_file):gfs,  , ,:gs, ,/,}[1,3]} \
    "("${$(du -h --apparent-size $log_file)[1]}")"
# print DIR: $(locate .zsh_local_history | xargs grep --color ')
# TODO: fix the following line sepeartor to respect full screen width
print -P ${(r:$COLUMNS * 4 - 16 ::\u2d:)} 
head -1000 $log_file | sed -e 's,$,,' -e '$ d' 
print -P ${(r:$COLUMNS * 4 - 16 ::\u2d:)} 
exit 0
