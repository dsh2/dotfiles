#!/bin/sh
# set -e
# set -v
# set -x
# adb -d usb >&2 >/dev/null
# timeout  4 adb wait-for-usb-device >&2 || true
ANDROID_SERIAL=$(adb -d get-serialno 2>/dev/null)
[ -z $ANDROID_SERIAL ] && { echo "Failed to get ANDROID_SERIAL via USB. Is device attached?" >&2; exit 1; }
# ANDROID_IP=$(adb -d shell netcfg 2>/dev/null| grep wlan0 | cut -d/ -f 1 | cut -c 20- | tr -d ' ') 2> /dev/null
if=wlan0
[ -z $ANDROID_IP ] && ANDROID_IP=$(adb -d shell ip address show dev $if scope link | sed -ne 's,.*inet6 \(.*\)/.*,\1,p')
[ -z $ANDROID_IP ] && ANDROID_IP=$(adb -d shell ip address show dev $if | sed -ne 's,.*inet \(.*\)/.*,\1,p')
[ -z $ANDROID_IP ] && { echo "Failed to get WLAN IP address of $ANDROID_SERIAL." >&2; exit 1; }
ANDROID_PORT=$((1024+RANDOM%2**12))
adb -d tcpip $ANDROID_PORT >/dev/null 2>&1
sleep 1.3
ping -W 1 -c 1 $ANDROID_IP >/dev/null 2>&1|| { echo "Failed to ping $ANDROID_SERIAL. Wrong WiFi? ANDROID_IP = $ANDROID_IP" >&2; exit 1; }
adb -d connect $ANDROID_IP:$ANDROID_PORT >/dev/null 2>&1
# TODO: implement wait-for-tcp-device
# adb -s $ANDROID_SERIALwait-for-tcp-device >&2
sleep 0.3
# adb devices -l >&2
# adb -s $ANDROID_IP:$ANDROID_PORT -e shell hostname >&2
echo "export ANDROID_IP=\"$ANDROID_IP\""
echo "export ANDROID_PORT=\"$ANDROID_PORT\""
echo "export ANDROID_ORIG_SERIAL=\"$ANDROID_SERIAL\""
echo "export ANDROID_SERIAL=\"$ANDROID_IP:$ANDROID_PORT\"" | tee ~/.android-serial
scrcpy --serial $ANDROID_SERIAL > /dev/null 2>&1 &
