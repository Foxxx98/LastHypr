#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  matugen-wall.sh                                                ║
# ║  Usage: ./matugen-wall.sh [/path/to/image.jpg]                 ║
# ║  Si no se pasa imagen, elige una aleatoria del directorio      ║
# ╚══════════════════════════════════════════════════════════════════╝

# --- Config ---
WALL_SCRIPT="$HOME/.config/hypr/Scripts/awall.sh"
IMAGES_DIR="/ThousanD/XternD/Projects/Wallpaper/" # <-- cambia esto a tu directorio
SECOND_MONITOR="HDMI-A-1"                         # segundo monitor para swww

# IDs por categoria
BLACK_IDS=(3596943058 3229030302 3229021240 1626467688 973101892 2481198042
  3266824725 3229038567 3596086172 3596082308 3020824486 3339375188
  2581416834 3409144006 2373012544 843532366 3596060003 3596062773
  875617215 3452383721 2103881690 2375328539 3229009374 907925288
  3596065136)
BLUE_IDS=(1406075299)
PINK_IDS=(3162651928 3327425084 2450461501)
PURPLE_IDS=(3596068265 3229059458)
WHITE_IDS=(3596075498 1540435040 3229047529 2421216522 1147402488
  3334283429 3225929904 3022080536)

# --- Pick image ---
if [[ -n "$1" && -f "$1" ]]; then
  IMAGE="$1"
  echo " 🖼  Using provided image: $IMAGE"
else
  if [[ ! -d "$IMAGES_DIR" ]]; then
    echo " ❌ Images directory not found: $IMAGES_DIR"
    exit 1
  fi

  IMAGE=$(find "$IMAGES_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

  if [[ -z "$IMAGE" ]]; then
    echo " ❌ No images found in $IMAGES_DIR"
    exit 1
  fi

  echo " 🎲 Random image: $IMAGE"
fi

# --- Validate deps ---
if [[ ! -f "$WALL_SCRIPT" ]]; then
  echo " ❌ Wall script not found: $WALL_SCRIPT"
  exit 1
fi

if ! command -v convert &>/dev/null; then
  echo " ❌ imagemagick not found. Install: sudo pacman -S imagemagick"
  exit 1
fi

if ! command -v awww &>/dev/null; then
  echo " ❌ awww not found. Install: sudo pacman -S awww"
  exit 1
fi

# --- Extract dominant color ---
echo " 🎨 Extracting dominant color..."

RGB=$(convert "$IMAGE" -resize 1x1\! -format "%[fx:int(255*r+.5)] %[fx:int(255*g+.5)] %[fx:int(255*b+.5)]" info:)
R=$(echo $RGB | awk '{print $1}')
G=$(echo $RGB | awk '{print $2}')
B=$(echo $RGB | awk '{print $3}')

echo " 🎨 Dominant color RGB: ($R, $G, $B)"

# --- Classify color ---
classify_color() {
  local r=$1 g=$2 b=$3
  local brightness=$(((r + g + b) / 3))

  if ((brightness < 60)); then
    echo "black"
    return
  fi

  if ((brightness > 190)); then
    echo "white"
    return
  fi

  if ((b > r + 30 && b > g + 20)); then
    echo "blue"
    return
  fi

  if ((r > 150 && g < 130 && b > 100 && r - g > 30 && r - b < 80)); then
    echo "pink"
    return
  fi

  if ((r > 80 && b > 80 && g < r - 20 && g < b - 10)); then
    echo "purple"
    return
  fi

  echo "black"
}

CATEGORY=$(classify_color $R $G $B)
echo " 🗂  Color category: $CATEGORY"

# --- Pick random ID from category ---
pick_id() {
  local ids=()
  case "$1" in
  black) ids=("${BLACK_IDS[@]}") ;;
  blue) ids=("${BLUE_IDS[@]}") ;;
  pink) ids=("${PINK_IDS[@]}") ;;
  purple) ids=("${PURPLE_IDS[@]}") ;;
  white) ids=("${WHITE_IDS[@]}") ;;
  *) ids=("${BLACK_IDS[@]}") ;;
  esac
  echo "${ids[RANDOM % ${#ids[@]}]}"
}

NEW_ID=$(pick_id "$CATEGORY")
echo " 🎲 Selected wallpaperengine ID: $NEW_ID"

# --- Update awall.sh ---
sed -i "s/\(linux-wallpaperengine --screen-root DP-1 --fps 15 --scaling stretch \)[0-9]\+/\1$NEW_ID/" "$WALL_SCRIPT"
echo " ✅ Updated $WALL_SCRIPT with ID: $NEW_ID"

# --- Restart linux-wallpaperengine (monitor principal DP-1) ---
pkill -f "linux-wallpaperengine" 2>/dev/null
sleep 0.5
bash "$WALL_SCRIPT" &
echo " 🖼  Wallpaperengine restarted on DP-1"

# --- Set image on second monitor via swww ---
# asegura que swww daemon esté corriendo
if ! pgrep -x "awww-daemon" >/dev/null; then
  awww-daemon &
  sleep 0.5
fi

awww img "$IMAGE" \
  --outputs "$SECOND_MONITOR" \
  --transition-type center \
  --transition-duration 1 \
  --transition-fps 60
echo " 🖼  Wallpaper set on $SECOND_MONITOR: $(basename "$IMAGE")"

# --- Run matugen (non-interactive) ---
if command -v matugen &>/dev/null; then
  sleep 1
  echo " 🎨 Running matugen with most dominant color (no prompt)..."

  # --source-color-index 0 = color más dominante, sin mostrar prompt de selección
  matugen image "$IMAGE" --source-color-index 0

  echo " 🎨 Matugen colors updated"
else
  echo " ⚠️  matugen not found, skipping color update"
fi

echo " ✨ Done!"
