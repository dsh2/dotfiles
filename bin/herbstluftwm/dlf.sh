#!/bin/sh
if ! pkill -QUIT -f "vlc.*dlf.de"; then 
	cvlc 'http://st02.dlf.de/dlf/02/128/mp3/stream.mp3'& 
fi
