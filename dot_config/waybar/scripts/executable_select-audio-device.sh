#!/bin/bash

ACTION="${1:-info}"

get_sink_info() {
    pactl list sinks 2>/dev/null | awk '
        /^Sink #/ { num = substr($2, 2) }
        /^[[:space:]]*Name:/ { name = substr($0, index($0, ":") + 2) }
        /^[[:space:]]*Description:/ {
            desc = substr($0, index($0, ":") + 2)
            gsub(/^[[:space:]]+/, "", desc)
            gsub(/Core Ultra 200H\/200V Series Processors HD Audio /, "", desc)
            gsub(/Realtek ALC.* /, "", desc)
            print num "|" name "|" desc
        }
    '
}

case "$ACTION" in
    info)
        DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null)
        if [ -z "$DEFAULT_SINK" ]; then
            echo '{"text":"󰎈 No device","tooltip":"No audio device"}'
            exit 0
        fi

        DESC=""
        while IFS='|' read -r num name desc; do
            if [ "$name" = "$DEFAULT_SINK" ]; then
                DESC="$desc"
                break
            fi
        done < <(get_sink_info)
        [ -z "$DESC" ] && DESC="$DEFAULT_SINK"

        VOL=$(pactl get-sink-volume "$DEFAULT_SINK" 2>/dev/null | grep -oP '\d+%' | head -1)
        MUTE=$(pactl get-sink-mute "$DEFAULT_SINK" 2>/dev/null | awk '{print $2}')

        if [ "$MUTE" = "yes" ]; then
            ICON="󰝟"
        else
            ICON="󰎈"
        fi

        echo "{\"text\":\"$ICON $VOL\",\"tooltip\":\"$DESC\"}"
        ;;
    *)
        echo "Usage: $0 {info}" >&2
        exit 1
        ;;
esac
