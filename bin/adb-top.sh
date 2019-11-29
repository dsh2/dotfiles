#!/bin/sh
#set -x
clear
while :; do 
    # adb shell top -n 1 -m $(($(tput lines) - 3)) | column -t 
    adb shell top -n 1 -m $(($(tput lines) - 3)) 
    sleep 2
done
