#!/bin/sh
unset PS4
set -x
set -e

[ -e $1 ] || { echo "File not found."; exit 9; }

pkg=$( aapt dump badging $1 | awk -F" " '/package/ {print $2}' | awk -F"'" '/name=/ {print $2}' )
[[ -n $pkg ]]
act=$( aapt dump badging $1 | awk -F" " '/launchable-activity/ {print $2}' | awk -F"'" '/name=/ {print $2}' )
[[ -n $act ]]

adb shell am start -n $pkg/$act
