#!/bin/bash
# Outputs current power profile for waybar custom module

profile=$(powerprofilesctl get 2>/dev/null)
if [ -z "$profile" ]; then
    echo '{"text":"? profile","tooltip":"power-profiles-daemon not found"}'
    exit 0
fi

case "$profile" in
    performance) icon="" ;;
    balanced)    icon="" ;;
    power-saver) icon="" ;;
    *)           icon="" ;;
esac

echo "{\"text\":\"$icon $profile\",\"tooltip\":\"Power profile: $profile\",\"class\":\"$profile\"}"
