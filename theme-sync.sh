#!/usr/bin/env bash
#
# theme-sync.sh
#
# Takes the EXACT colors from a GTK theme's gtk.css (background,
# foreground, accent, selection colors, etc.) and injects them into
# matugen as named "custom_colors" — so Waybar and Hyprland end up
# using the very same hex values as your GTK theme, not a regenerated
# Material-You palette derived from a single color.
#
# Usage:
#   ./theme-sync.sh [GTK_THEME_NAME] [WALLPAPER_PATH]
#
# If GTK_THEME_NAME is omitted, the script auto-detects whatever theme
# is currently active (e.g. whatever you just picked in nwg-look).
#
# Examples:
#   ./theme-sync.sh                                   # use theme nwg-look set, no wallpaper change
#   ./theme-sync.sh "" ~/Pictures/wallpapers/moon.jpg  # keep active theme, also set wallpaper
#   ./theme-sync.sh "Orchis-Dark" ~/Pictures/mountains.jpg   # force a specific theme

set -euo pipefail

THEME_NAME="${1:-}"
WALLPAPER="${2:-}"

if [[ -z "$THEME_NAME" ]]; then
  THEME_NAME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
  if [[ -z "$THEME_NAME" ]]; then
    echo "!! Couldn't detect the active GTK theme via gsettings."
    echo "   Set one in nwg-look first, or pass the theme name explicitly:"
    echo "   $0 <gtk-theme-name> [wallpaper-path]"
    exit 1
  fi
  echo "==> No theme passed — using currently active theme: $THEME_NAME"
fi

BASE_CONFIG="$HOME/.config/matugen/config.toml"
RUNTIME_CONFIG="/tmp/matugen-runtime.toml"

# --- 1. Locate the theme's GTK3 stylesheet -------------------------------
CANDIDATES=(
  "$HOME/.local/share/themes/$THEME_NAME/gtk-3.0/gtk.css"
  "/usr/share/themes/$THEME_NAME/gtk-3.0/gtk.css"
)

GTK_CSS=""
for p in "${CANDIDATES[@]}"; do
  [[ -f "$p" ]] && { GTK_CSS="$p"; break; }
done

if [[ -z "$GTK_CSS" ]]; then
  echo "!! Could not find gtk-3.0/gtk.css for theme '$THEME_NAME'"
  printf '   Checked:\n     %s\n' "${CANDIDATES[@]}"
  exit 1
fi

echo "==> Theme:      $THEME_NAME"
echo "==> Stylesheet: $GTK_CSS"

# --- 2. Extract every color we care about, exactly as the theme defines --
# Map: our_name -> list of possible @define-color variable names in the
# theme, tried in order (themes name things differently).
declare -A COLOR_MAP=(
  [gtk_bg]="theme_bg_color window_bg_color"
  [gtk_fg]="theme_fg_color window_fg_color"
  [gtk_accent]="accent_bg_color accent_color theme_selected_bg_color selected_bg_color"
  [gtk_on_accent]="accent_fg_color theme_selected_fg_color selected_fg_color"
  [gtk_surface]="theme_base_color view_bg_color"
  [gtk_border]="borders unfocused_borders"
)

declare -A FOUND=()
for key in "${!COLOR_MAP[@]}"; do
  for var in ${COLOR_MAP[$key]}; do
    match=$(grep -m1 "@define-color[[:space:]]\+$var[[:space:]]" "$GTK_CSS" \
              | grep -oE '#[0-9a-fA-F]{6}' | head -n1 || true)
    if [[ -n "$match" ]]; then
      FOUND[$key]="$match"
      echo "==> $key ($var): $match"
      break
    fi
  done
done

if [[ -z "${FOUND[gtk_accent]:-}" ]]; then
  echo "!! Couldn't find an accent color in $GTK_CSS — needed as the seed color."
  echo "   Add the theme's variable name to COLOR_MAP[gtk_accent] in this script."
  exit 1
fi

# --- 3. Build the [custom_colors] block dynamically -----------------------
CUSTOM_BLOCK="[custom_colors]\n"
for key in "${!FOUND[@]}"; do
  CUSTOM_BLOCK+="${key} = \"${FOUND[$key]}\"\n"
done

cat "$BASE_CONFIG" > "$RUNTIME_CONFIG"
printf '\n%b' "$CUSTOM_BLOCK" >> "$RUNTIME_CONFIG"

# --- 4. Apply the GTK theme itself ---------------------------------------
echo "==> Applying GTK theme via gsettings"
gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME" || true

# --- 5. Set the wallpaper (cosmetic only, doesn't affect the palette) -----
if [[ -n "$WALLPAPER" ]]; then
  if [[ ! -f "$WALLPAPER" ]]; then
    echo "!! Wallpaper not found: $WALLPAPER"
    exit 1
  fi
  echo "==> Setting wallpaper via swww: $WALLPAPER"
  swww img "$WALLPAPER" --transition-type grow --transition-duration 1
fi

# --- 6. Run matugen, seeded with the accent color, carrying the exact ----
#         GTK colors along as custom_colors
echo "==> Running matugen with exact GTK colors injected"
matugen color hex "${FOUND[gtk_accent]}" --config "$RUNTIME_CONFIG"

echo "==> Done. Waybar and Hyprland now use the exact colors from '$THEME_NAME'."
