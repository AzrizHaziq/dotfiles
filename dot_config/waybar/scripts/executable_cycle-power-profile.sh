#!/bin/bash

current=$(powerprofilesctl get 2>/dev/null)

if [ -z "$current" ]; then
    notify-send "Power Profile" "Error: Could not get current profile"
    exit 1
fi

case $current in
    power-saver) next="balanced" ;;
    balanced)    next="performance" ;;
    performance) next="power-saver" ;;
    *)           next="balanced" ;;
esac

if powerprofilesctl set "$next" 2>/dev/null; then
    notify-send "Power Profile" "Switched to: $next"
else
    notify-send "Power Profile" "Error: Failed to switch profile"
    exit 1
fi
