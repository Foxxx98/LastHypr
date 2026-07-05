#!/usr/bin/env bash
# wall-swww.sh
# Recibe un color como argumento y pone una imagen aleatoria en HDMI-A-1
# Uso: wall-swww.sh blue

COLOR_FILE="$HOME/.config/hypr/Scripts/wall-color.txt"
COLOR="${1:-$(cat "$COLOR_FILE" 2>/dev/null)}"

# --- Directorios por color ---
declare -A WALL_DIRS
WALL_DIRS=(
  [black]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/black/"
  [blue]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/blue/"
  [cyan]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/cyan/"
  [green]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/green/"
  [orange]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/orange/"
  [pink]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/pink/"
  [purple]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/purple/"
  [red]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/red/"
  [yellow]="/ThousanD/XternD/Projects/WallpapersDir/ColorWall/yellow/"
)

WALL_DIR="${WALL_DIRS[$COLOR]:-${WALL_DIRS[black]}}"

# fallback a black si el directorio no existe
[[ -d "$WALL_DIR" ]] || WALL_DIR="${WALL_DIRS[black]}"

RANDOM_IMG=$(find "$WALL_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n1)

[[ -z "$RANDOM_IMG" ]] && exit 1

# solo inicia daemon si no está corriendo
pgrep -x "awww-daemon" >/dev/null || {
  awww-daemon &
  sleep 0.8
}

awww img "$RANDOM_IMG" \
  --outputs HDMI-A-1 \
  --transition-type center \
  --transition-duration 1.2
