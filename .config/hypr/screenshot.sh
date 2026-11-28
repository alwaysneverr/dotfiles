#!/usr/bin/env bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +'%Y%m%d_%H%M%S').png"
case "$1" in
    region) GEOM=$(slurp) || exit 0; MSG="Selected region saved" ;;
    full)   GEOM=""; MSG="Full desktop captured" ;;
    window) GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'); MSG="Active window captured" ;;
    *) exit 1 ;;
esac
if [ -n "$GEOM" ]; then grim -g "$GEOM" - | tee "$FILE" | wl-copy; else grim - | tee "$FILE" | wl-copy; fi
notify-send "Screenshot" "$MSG" -i "$FILE"
