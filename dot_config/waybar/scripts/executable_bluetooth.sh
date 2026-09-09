#!/bin/bash

get_power_state() {
    bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2}'
}

case "${1:-power}" in
    power)
        if ! command -v bluetoothctl &>/dev/null; then
            notify-send "Bluetooth" "Error: bluetoothctl not found"
            exit 1
        fi
        if [ "$(get_power_state)" = "yes" ]; then
            bluetoothctl power off 2>/dev/null
            notify-send "Bluetooth" "Powered off"
        else
            bluetoothctl power on 2>/dev/null
            notify-send "Bluetooth" "Powered on"
        fi
        ;;
    *)
        echo "Usage: $0 {power}" >&2
        exit 1
        ;;
esac
