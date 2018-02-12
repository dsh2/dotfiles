#!/bin/sh
PID=$(pidof -s sakura)
[ -z $PID ] && PID=$(pidof -s xfce4-terminal)
[ -z $PID ] && exit 1
WS_WIN=$(wmctrl -lp | grep $PID | cut -c -11) 
[ -z $WS_WIN ] && exit 1
wmctrl -ia $WS_WIN
