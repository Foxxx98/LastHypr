#!/bin/bash

WALLPAPER_DIR="/ThousanD/XternD/Projects/Wallpaper/"

# Only start daemon if not running (don't kill it)
if ! pgrep -x "awww-daemon" >/dev/null; then
  awww-daemon &
  sleep 1
fi

RANDOM_IMG=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

# Fast transition
awww img "$RANDOM_IMG" --outputs HDMI-A-1 --transition-type center --transition-duration 1.2
