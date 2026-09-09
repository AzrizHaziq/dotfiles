#!/bin/bash

if ! command -v gammastep &>/dev/null; then
    notify-send "Gammastep" "Error: gammastep not found"
    exit 1
fi

if pgrep -x "gammastep" > /dev/null; then
    pkill gammastep
    notify-send "Gammastep" "Disabled"
else
    gammastep -O 4500 &
    notify-send "Gammastep" "Enabled (4500K)"
fi
