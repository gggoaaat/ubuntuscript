#!/usr/bin/env bash
echo "🖼️ Setting wallpaper..."
WALLPAPER_URL="https://raw.githubusercontent.com/gggoaaat/ubuntuscript/main/assets/background.jpg"
WALLPAPER_PATH="$HOME/Pictures/ubuntu-background.jpg"
mkdir -p "$HOME/Pictures"
curl -fsSL "$WALLPAPER_URL" -o "$WALLPAPER_PATH"
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH" || true
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH" || true
fi
