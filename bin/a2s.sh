#!/bin/sh
XE="xmodmap -e"

# Normal setup (left)
$XE "keycode 133 = Super_L NoSymbol Super_L"
$XE "keycode 64 = Alt_L Meta_L Alt_L Meta_L"

# Switched setup (left)
# $XE "keycode 64 = Super_L NoSymbol Super_L"
# $XE "keycode 133 = Alt_L Meta_L Alt_L Meta_L"
# $XE "keycode 206 = Super_L NoSymbol Super_L"
# $XE "keycode 206 = Alt_L Meta_L Alt_L Meta_L"

# Normal setup (right) - TODO
$XE "keycode 134 = Super_R NoSymbol Super_R"
$XE "keycode 108 = Alt_R Meta_R ISO_Level3_Shift"

