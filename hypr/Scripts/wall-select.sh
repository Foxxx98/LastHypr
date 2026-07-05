#!/usr/bin/env bash
# wall-select.sh

ROFI_WALL_DIR="/ThousanD/XternD/Projects/WallpapersDir/RofiWall/"
COLOR_FILE="$HOME/.config/hypr/Scripts/wall-color.txt"
SCRIPT_DIR="$HOME/.config/hypr/Scripts"

COLORS=(black blue cyan green orange pink purple red yellow)

# --- Detectar color desde nombre de archivo (método primario) ---
color_from_name() {
  local name="${1,,}" # lowercase
  for c in "${COLORS[@]}"; do
    [[ "$name" == *"$c"* ]] && {
      echo "$c"
      return
    }
  done
  echo ""
}

# --- Clasificar color desde hex (fallback) ---
classify_color_hex() {
  local hex="${1#'#'}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))

  local max=$r min=$r
  ((g > max)) && max=$g
  ((b > max)) && max=$b
  ((g < min)) && min=$g
  ((b < min)) && min=$b

  local brightness=$(((r + g + b) / 3))
  local delta=$((max - min))

  # sin saturación → black
  ((delta < 30)) && {
    echo "black"
    return
  }

  # hue
  local hue=0
  if ((max == r)); then
    hue=$((60 * (g - b) / delta))
    ((hue < 0)) && hue=$((hue + 360))
  elif ((max == g)); then
    hue=$((60 * (b - r) / delta + 120))
  else
    hue=$((60 * (r - g) / delta + 240))
  fi

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

# --- Detectar color ---
# 1. primero intenta desde el nombre del archivo
COLOR=$(color_from_name "$SELECTED")

# 2. fallback: source_color de matugen
if [[ -z "$COLOR" ]]; then
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
  [[ -n "$SOURCE_HEX" ]] && COLOR=$(classify_color_hex "$SOURCE_HEX")
fi

# 3. último fallback
[[ -z "$COLOR" ]] && COLOR="black"

echo "$COLOR" >"$COLOR_FILE"

# --- Ejecutar todo en paralelo ---
matugen image "$SELECTED_IMG" --source-color-index 0 &
bash "$SCRIPT_DIR/wall-engine.sh" "$COLOR" &
bash "$SCRIPT_DIR/wall-swww.sh" "$COLOR" &

wait
