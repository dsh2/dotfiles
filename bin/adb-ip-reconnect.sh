ANDROID_IP=$(adb -d shell netcfg | grep wlan0 | cut -d/ -f 1 | cut -c 20- | tr -d ' ') 
( adb -d tcpip 5555 && adb -d connect $ANDROID_IP ) > /dev/null 2>&1
echo ANDROID_SERIAL=$ANDROID_IP:5555
