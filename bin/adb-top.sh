set -x
adb shell top -m $(($(tput lines) - 3))
