#!/bin/bash

MONITOR="eDP-1"  # change if needed
STATE_FILE="/tmp/tablet_mode"

echo "0" > $STATE_FILE

# Tablet mode detection (background)
libinput debug-events | while read -r line; do
    if echo "$line" | grep -q "tablet-mode"; then
        if echo "$line" | grep -q "state 1"; then
            echo "1" > $STATE_FILE
            echo "Tablet mode ON"
        else
            echo "0" > $STATE_FILE
            echo "Tablet mode OFF"
        fi
    fi
done &

# Rotation logic
monitor-sensor | while read -r line; do
    TABLET_MODE=$(cat $STATE_FILE)

    if [ "$TABLET_MODE" -eq 1 ]; then
        case "$line" in
            *"normal"*)
                hyprctl keyword monitor "$MONITOR,preferred,auto,1,transform,0"
                ;;
            *"left-up"*)
                hyprctl keyword monitor "$MONITOR,preferred,auto,1,transform,1"
                ;;
            *"right-up"*)
                hyprctl keyword monitor "$MONITOR,preferred,auto,1,transform,3"
                ;;
            *"bottom-up"*)
                hyprctl keyword monitor "$MONITOR,preferred,auto,1,transform,2"
                ;;
        esac
    fi
done
