#!/usr/bin/env bash
# wall-select.sh

ROFI_WALL_DIR="/ThousanD/XternD/Projects/WallpapersDir/RofiWall/"
COLOR_FILE="$HOME/.config/hypr/Scripts/wall-color.txt"
SCRIPT_DIR="$HOME/.config/hypr/Scripts"

# --- Clasificar color desde hex ---
# Usa saturación y hue en lugar de solo brightness
classify_color_hex() {
  local hex="${1#'#'}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))

  # max, min para calcular saturación y hue
  local max=$r min=$r
  ((g > max)) && max=$g
  ((b > max)) && max=$b
  ((g < min)) && min=$g
  ((b < min)) && min=$b

  local brightness=$(((r + g + b) / 3))
  local delta=$((max - min))

  # si delta es muy pequeño = gris/negro/blanco (sin color)
  if ((delta < 20)); then
    ((brightness < 80)) && {
      echo "black"
      return
    }
    ((brightness > 180)) && {
      echo "black"
      return
    } # white → black fallback
    echo "black"
    return
  fi

  # calcular hue aproximado (0-360)
  local hue=0
  if ((max == r)); then
    hue=$((60 * (g - b) / delta))
    ((hue < 0)) && hue=$((hue + 360))
  elif ((max == g)); then
    hue=$((60 * (b - r) / delta + 120))
  else
    hue=$((60 * (r - g) / delta + 240))
  fi

  # clasificar por hue
  if ((hue >= 345 || hue < 15)); then
    echo "red"
  elif ((hue >= 15 && hue < 40)); then
    echo "orange"
  elif ((hue >= 40 && hue < 70)); then
    echo "yellow"
  elif ((hue >= 70 && hue < 150)); then
    echo "green"
  elif ((hue >= 150 && hue < 195)); then
    echo "cyan"
  elif ((hue >= 195 && hue < 255)); then
    echo "blue"
  elif ((hue >= 255 && hue < 290)); then
    echo "purple"
  elif ((hue >= 290 && hue < 345)); then
    echo "pink"
  else
    echo "black"
  fi
}

# --- Construir lista para rofi ---
mapfile -t IMGS < <(find "$ROFI_WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

[[ ${#IMGS[@]} -eq 0 ]] && exit 1

declare -A IMG_MAP
ROFI_INPUT=""
for img in "${IMGS[@]}"; do
  name=$(basename "$img" | sed 's/\.[^.]*$//')
  IMG_MAP["$name"]="$img"
  ROFI_INPUT+="${name}\x00icon\x1f${img}\n"
done

# --- Rofi ---
SELECTED=$(printf "%b" "$ROFI_INPUT" | rofi \
  -dmenu \
  -i \
  -p "  Wallpaper" \
  -theme-str 'element { children: [element-icon, element-text]; }' \
  -theme-str 'element-icon { size: 4em; }' \
  -show-icons)

[[ -z "$SELECTED" ]] && exit 0

SELECTED_IMG="${IMG_MAP[$SELECTED]}"
[[ -z "$SELECTED_IMG" || ! -f "$SELECTED_IMG" ]] && exit 1

# --- Obtener source_color de matugen ---
# key es "color" no "hex" aunque se pase --json hex
SOURCE_HEX=$(matugen image "$SELECTED_IMG" \
  --source-color-index 0 \
  --json hex \
  --dry-run 2>/dev/null |
  python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data['colors']['source_color']['default']['color'])
except:
    sys.exit(1)
")

[[ -z "$SOURCE_HEX" ]] && exit 1

COLOR=$(classify_color_hex "$SOURCE_HEX")
echo "$COLOR" >"$COLOR_FILE"

# --- Ejecutar todo en paralelo ---
matugen image "$SELECTED_IMG" --source-color-index 0 &
bash "$SCRIPT_DIR/wall-engine.sh" "$COLOR" &
bash "$SCRIPT_DIR/wall-swww.sh" "$COLOR" &

wait
