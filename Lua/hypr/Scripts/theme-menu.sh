#!/usr/bin/env bash
# theme-menu.sh

THEME_DIR="/usr/share/themes" # O "/usr/share/themes" si están instalados para todo el sistema
SYNC_SCRIPT="$HOME/.config/hypr/Scripts/theme-sync.sh"

# Buscar todos los directorios de temas
mapfile -t THEMES < <(find "$THEME_DIR" -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | sort)

if [[ ${#THEMES[@]} -eq 0 ]]; then
  echo "No se encontraron temas en $THEME_DIR"
  exit 1
fi

# Mostrar menú en Rofi
SELECTED_THEME=$(printf "%s\n" "${THEMES[@]}" | rofi -dmenu -i -p "  Selecciona un Tema GTK")

[[ -z "$SELECTED_THEME" ]] && exit 0

echo "🎨 Aplicando tema: $SELECTED_THEME"

# 1. Aplicar el tema GTK usando gsettings (asegúrate de tener gsettings instalado)
gsettings set org.gnome.desktop.interface gtk-theme "$SELECTED_THEME"

# 2. Ejecutar el script maestro de sincronización
bash "$SYNC_SCRIPT" "$SELECTED_THEME"
