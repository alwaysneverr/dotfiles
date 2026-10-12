#!/usr/bin/env bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +'%Y%m%d_%H%M%S').png"

case "$1" in
    region)
        grim -g "$(slurp)" - | tee "$FILE" | wl-copy
        notify-send "Screenshot" "Selected region saved to gallery" -i camera
        ;;
    full)
        grim - | tee "$FILE" | wl-copy
        notify-send "Screenshot" "Full desktop captured" -i camera
        ;;
    window)
        # Accurate geometric bounds parsing
        GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$GEOM" - | tee "$FILE" | wl-copy
        notify-send "Screenshot" "Active window captured" -i camera
        ;;
esac
