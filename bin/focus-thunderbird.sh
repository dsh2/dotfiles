#!/usr/bin/env zsh
APP=${0:t:r:s.focus-.}
PID=$(pidof -s $APP)
[ -z $PID ] && exit 1
WIN=$(wmctrl -lp | grep $PID | cut -c -11) 
[ -z $WIN ] && exit 1
wmctrl -ia $WIN
