#!/bin/sh
set -x
adb -d usb && sleep 1
ANDROID_IP=$(adb -d shell netcfg | grep wlan0 | cut -d/ -f 1 | cut -c 20- | tr -d ' ') 2> /dev/null
[ -z $ANDROID_IP ] && ANDROID_IP=$(adb -d shell ip address show dev wlan0 | sed -ne 's,.*inet \(.*\)/24.*,\1,p')
exec 3>&2 2>&1 1>&3 3>&- adb -d tcpip 5555 && adb -d connect $ANDROID_IP && echo ANDROID_SERIAL=$ANDROID_IP:5555 || echo ANDROID_SERIAL=$(adb get-serialno)
