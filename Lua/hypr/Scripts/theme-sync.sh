#!/usr/bin/env bash
# theme-sync.sh

THEME_NAME="$1"
THEME_DIR="/usr/share/themes/$THEME_NAME"
COLOR_FILE="$HOME/.config/hypr/Scripts/wall-color.txt"
SCRIPT_DIR="$HOME/.config/hypr/Scripts"

if [[ -z "$THEME_NAME" ]]; then
  echo "Uso: $0 <nombre-del-tema>"
  exit 1
fi

# --- Función para clasificar el color HEX (idéntica a la que ya tenías) ---
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
  local delta=$((max - min))
  ((delta < 30)) && {
    echo "black"
    return
  }
  local hue=0
  if ((max == r)); then
    hue=$((60 * (g - b) / delta))
    ((hue < 0)) && hue=$((hue + 360))
  elif ((max == g)); then
    hue=$((60 * (b - r) / delta + 120))
  else hue=$((60 * (r - g) / delta + 240)); fi

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
  else echo "black"; fi
}

# --- 1. Extraer el color primario del tema seleccionado ---
GTK_CSS="$THEME_DIR/gtk-3.0/gtk.css"
# En algunos temas el color está en gtk-dark.css o similar, probamos varios
if [[ ! -f "$GTK_CSS" ]]; then
  GTK_CSS=$(find "$THEME_DIR" -name "gtk.css" -o -name "gtk-dark.css" | head -n 1)
fi

PRIMARY_HEX=$(grep -m 1 -oP '@define-color\s+(accent_color|theme_selected_bg_color)\s+\K#[0-9a-fA-F]{6}' "$GTK_CSS")

if [[ -z "$PRIMARY_HEX" ]]; then
  echo "⚠️ No se pudo extraer el color de $THEME_NAME. Usando color por defecto."
  PRIMARY_HEX="#3584e4"
fi

echo "🎨 Color detectado en $THEME_NAME: $PRIMARY_HEX"

# --- 2. Clasificar el color y guardarlo ---
CATEGORY=$(classify_color_hex "$PRIMARY_HEX")
echo "📂 Categoría asignada: $CATEGORY"
echo "$CATEGORY" >"$COLOR_FILE"

# --- 3. Generar los colores dinámicos con Tinte ---
# Descomenta estas líneas cuando tengas tinte configurado
# echo "⚙️ Generando paletas de colores con tinte..."
# tinte color "$PRIMARY_HEX" --mode dark
# hyprctl reload

# --- 4. Actualizar fondos de pantalla ---
# El script de fondos recibe la categoría (blue, red, etc.) y elige una imagen
bash "$SCRIPT_DIR/wall-swww.sh" "$CATEGORY" &
bash "$SCRIPT_DIR/wall-engine.sh" "$CATEGORY" &

wait
echo "✅ Todo sincronizado."
