#!/usr/bin/env bash
echo "🖼️ Setting wallpaper..."

# Define URL and local path
WALLPAPER_URL="https://raw.githubusercontent.com/gggoaaat/ubuntuscript/main/background2.png"
WALLPAPER_PATH="$HOME/Pictures/ubuntu-background.png"

# Ensure Pictures folder exists
mkdir -p "$HOME/Pictures"

# Download wallpaper
echo "⬇️  Downloading wallpaper..."
if curl -fsSL "$WALLPAPER_URL" -o "$WALLPAPER_PATH"; then
  echo "✅ Wallpaper downloaded to $WALLPAPER_PATH"
else
  echo "⚠️  Failed to download wallpaper from $WALLPAPER_URL"
  exit 0
fi

# Apply wallpaper if GNOME available
if command -v gsettings >/dev/null 2>&1; then
  echo "🎨 Applying wallpaper via gsettings..."
  gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH" || true
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH" || true
  echo "✅ Wallpaper applied successfully."
else
  echo "⚙️  GNOME desktop not detected — skipping wallpaper setup."
fi
