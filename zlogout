[[ -z $SSH_TTY ]] && clear
if [[ -n $TMUX ]]; then
	echo zsh timed out. \(TMOUT=\"$TMOUT\", \$\*=\"$*\"\)
	# TODO: think about if sleeping is a bad idea....
	sleep 1m
fi
