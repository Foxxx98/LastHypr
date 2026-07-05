#!/usr/bin/env bash
# wall-engine.sh
# Recibe un color como argumento, elige un ID aleatorio y lanza wallpaperengine
# Uso: wall-engine.sh blue

COLOR_FILE="$HOME/.config/hypr/Scripts/wall-color.txt"
COLOR="${1:-$(cat "$COLOR_FILE" 2>/dev/null)}"
SELF="$HOME/.config/hypr/Scripts/wall-engine.sh"

# --- IDs por color ---
BLACK_IDS=(3371275392 3409144006 3266824725 3366554210 3028090166 3443450456 3596060003 3339375188 1738986142 2581416834)
BLUE_IDS=(1406075299 973101892 2679248947)
CYAN_IDS=(907925288 3596082308 3596062773)
GREEN_IDS=(1845706469 3225929904 2791914120 2311156187)
ORANGE_IDS=(875617215 3229047529 3275335644)
PINK_IDS=(3327425084 3229059458 2835320262 1833376502 3229059458)
PURPLE_IDS=(3596068265 3633510045 3596065136 3229021240 3229009374 3229030302)
RED_IDS=(1626467688 3146507587 3136332792)
YELLOW_IDS=(1182651658 2036702518 2184045712 2882821422)

pick_id() {
  local ids=()
  case "$1" in
  black) ids=("${BLACK_IDS[@]}") ;;
  blue) ids=("${BLUE_IDS[@]}") ;;
  cyan) ids=("${CYAN_IDS[@]}") ;;
  green) ids=("${GREEN_IDS[@]}") ;;
  orange) ids=("${ORANGE_IDS[@]}") ;;
  pink) ids=("${PINK_IDS[@]}") ;;
  purple) ids=("${PURPLE_IDS[@]}") ;;
  red) ids=("${RED_IDS[@]}") ;;
  yellow) ids=("${YELLOW_IDS[@]}") ;;
  *) ids=("${BLACK_IDS[@]}") ;;
  esac
  echo "${ids[RANDOM % ${#ids[@]}]}"
}

NEW_ID=$(pick_id "$COLOR")

# reemplaza el ID en este mismo script
sed -i "s/\(linux-wallpaperengine --screen-root DP-1 --fps 15 --scaling stretch --silent \)[0-9]\+/\1$NEW_ID/" "$SELF"

# mata instancia anterior y lanza con nuevo ID
pkill -f "linux-wallpaperengine" 2>/dev/null
sleep 0.3

linux-wallpaperengine --screen-root DP-1 --fps 15 --scaling stretch --silent $NEW_ID &
