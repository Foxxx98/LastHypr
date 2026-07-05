#!/bin/bash

official=$(checkupdates 2>/dev/null | wc -l)
aur=$(yay -Qua 2>/dev/null | wc -l)

total=$((official + aur))

if [ "$total" -gt 0 ]; then
  echo "{\"text\":\"󰚰 $total\",\"tooltip\":\"$official oficiales • $aur AUR\"}"
fi
