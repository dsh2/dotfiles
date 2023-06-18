#!env zsh

# set -x 
rm() {
    local module=$1
    local prefix=$2
    # echo ENTER: $module
    # [ -d /sys/module/$module/holders ] || return
    setopt nullglob

    local holder
    for holder in /sys/module/$module/holders/*; do 
	holder=${holder##*/}
	# echo holder = $holder
	# echo $module: holder = $holder
	rm $holder $prefix:$holder
	# echo $prefix:$holder
	echo sudo modprobe --dry-run --verbose $holder
    done
    # echo EXIT: $module
}

[[ $# == 1 ]] || { echo "usage: $0 module"; exit 1; }

module=$1
echo rm $module $module
