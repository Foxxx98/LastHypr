#!/usr/bin/env bash
#
# setup-qt-theming.sh
#
# Run this ONCE to point qt5ct / qt6ct at the color scheme matugen
# will keep regenerating (~/.config/qt5ct/colors/matugen.conf).
# After this, every theme-sync.sh run updates Qt apps too.

set -euo pipefail

for CFG_DIR in "$HOME/.config/qt5ct" "$HOME/.config/qt6ct"; do
  TOOL=$(basename "$CFG_DIR")
  mkdir -p "$CFG_DIR/colors"
  CONF="$CFG_DIR/$TOOL.conf"

  if [[ ! -f "$CONF" ]]; then
    echo "==> $TOOL.conf not found yet — launch $TOOL once to generate it, then rerun this script."
    continue
  fi

  # Ensure [Appearance] section points at our generated palette
  if grep -q '^\[Appearance\]' "$CONF"; then
    if grep -q '^color_scheme_path=' "$CONF"; then
      sed -i "s|^color_scheme_path=.*|color_scheme_path=$CFG_DIR/colors/matugen.conf|" "$CONF"
    else
      sed -i "/^\[Appearance\]/a color_scheme_path=$CFG_DIR/colors/matugen.conf" "$CONF"
    fi
    if grep -q '^custom_palette=' "$CONF"; then
      sed -i "s|^custom_palette=.*|custom_palette=true|" "$CONF"
    else
      sed -i "/^\[Appearance\]/a custom_palette=true" "$CONF"
    fi
  else
    printf '\n[Appearance]\ncolor_scheme_path=%s/colors/matugen.conf\ncustom_palette=true\n' "$CFG_DIR" >> "$CONF"
  fi

  echo "==> Configured $TOOL to use matugen's generated palette"
done

echo ""
echo "==> Also make sure this is in your hyprland.conf:"
echo "      env = QT_QPA_PLATFORMTHEME,qt5ct"
echo "    (or qt6ct, depending on which Qt apps you run)"
