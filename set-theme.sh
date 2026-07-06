#!/usr/bin/env bash
#
# set-theme.sh
#
# Switches the GTK3 + GTK4 theme from the command line (no nwg-look
# needed), then calls theme-sync.sh so Waybar/Hyprland pick up the
# new colors automatically.
#
# Usage:
#   ./set-theme.sh <ThemeName> [WALLPAPER_PATH]
#
# Example:
#   ./set-theme.sh "VantaBlack"
#   ./set-theme.sh "Orchis-Dark" ~/Pictures/wallpapers/moon.jpg

set -euo pipefail

THEME_NAME="${1:?Usage: $0 <ThemeName> [wallpaper-path]}"
WALLPAPER="${2:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Sanity check: does the theme actually exist? -------------------------
CANDIDATES=(
  "$HOME/.local/share/themes/$THEME_NAME"
  "/usr/share/themes/$THEME_NAME"
)
FOUND_DIR=""
for d in "${CANDIDATES[@]}"; do
  [[ -d "$d" ]] && { FOUND_DIR="$d"; break; }
done

if [[ -z "$FOUND_DIR" ]]; then
  echo "!! Theme '$THEME_NAME' not found in:"
  printf '     %s\n' "${CANDIDATES[@]}"
  echo "   Available themes:"
  ls "$HOME/.local/share/themes" 2>/dev/null
  ls /usr/share/themes 2>/dev/null
  exit 1
fi

echo "==> Found theme at: $FOUND_DIR"

# --- 1. GTK3: gsettings (works if a GNOME-ish settings daemon is present) --
gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME" 2>/dev/null || true
gsettings set org.gnome.desktop.wm.preferences theme "$THEME_NAME" 2>/dev/null || true

# --- 2. GTK3: settings.ini (works everywhere, incl. plain Hyprland/Sway) ---
mkdir -p "$HOME/.config/gtk-3.0"
GTK3_INI="$HOME/.config/gtk-3.0/settings.ini"
touch "$GTK3_INI"

if grep -q '^gtk-theme-name' "$GTK3_INI" 2>/dev/null; then
  sed -i "s/^gtk-theme-name.*/gtk-theme-name=$THEME_NAME/" "$GTK3_INI"
else
  { echo "[Settings]"; echo "gtk-theme-name=$THEME_NAME"; } >> "$GTK3_INI"
fi
echo "==> Wrote $GTK3_INI"

# --- 3. GTK4/libadwaita: only a handful of themes support this -----------
# (libadwaita ignores gtk-theme-name; theming it requires the theme itself
# to ship a gtk-4.0/ folder that gets symlinked into ~/.config/gtk-4.0)
if [[ -d "$FOUND_DIR/gtk-4.0" ]]; then
  mkdir -p "$HOME/.config/gtk-4.0"
  ln -sf "$FOUND_DIR/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
  [[ -f "$FOUND_DIR/gtk-4.0/gtk-dark.css" ]] && \
    ln -sf "$FOUND_DIR/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
  echo "==> Linked GTK4/libadwaita styling from theme"
else
  echo "==> Theme has no gtk-4.0/ folder — libadwaita apps keep their own style"
fi

# --- 4. Restart GTK apps that are already running (optional but handy) ----
# Nautilus and a few others don't always pick up theme changes live.
# Uncomment if you want this behavior:
# killall nautilus 2>/dev/null || true

# --- 5. Hand off to theme-sync.sh for the color propagation ---------------
echo "==> Syncing colors to Waybar/Hyprland via theme-sync.sh"
"$SCRIPT_DIR/theme-sync.sh" "$THEME_NAME" "$WALLPAPER"
