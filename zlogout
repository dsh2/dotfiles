# TODO: Check for background jobs, in particular tmux
[[ -z $SSH_TTY ]] && clear
if [[ -n $TMOUT ]]; then
	echo zsh timed out. \(TMOUT=\"$TMOUT\", \$\*=\"$*\"\)
	# TODO: think about if sleeping is a bad idea....
	sleep 1m
fi
