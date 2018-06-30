#!/usr/bin/env zsh

for tag in $(herbstclient tag_status); do 
	if [ ${tag:0:1} = '.' ]; then 
		herbstclient merge_tag ${tag:1}
	fi
done
