#!/bin/sh
set -e
adb -d usb >&2
adb wait-for-usb-device >&2
ANDROID_SERIAL=$(adb -d get-serialno)
# ANDROID_IP=$(adb -d shell netcfg 2>/dev/null| grep wlan0 | cut -d/ -f 1 | cut -c 20- | tr -d ' ') 2> /dev/null
[ -z $ANDROID_IP ] && ANDROID_IP=$(adb -d shell ip address show dev wlan0 | sed -ne 's,.*inet \(.*\)/24.*,\1,p')
[ -z $ANDROID_IP ] && { echo "Failed to get IP address of $ANDROID_SERIAL"; exit 1; }
ADB_PORT=$((1024+RANDOM%2**12))
adb -d tcpip $ADB_PORT >&2
adb -d connect $ANDROID_IP:$ADB_PORT >&2
# TODO: implement wait-for-tcp-device
# adb -s $ANDROID_SERIALwait-for-tcp-device >&2
sleep 0.3
adb devices -l >&2
# adb -es $ANDROID_SERIAL true || exit
echo "export ANDROID_IP=$ANDROID_IP"
echo "export ANDROID_SERIAL=$ANDROID_IP:$ADB_PORT"
echo "export ANDROID_IP_SERIAL=$ANDROID_SERIAL"
