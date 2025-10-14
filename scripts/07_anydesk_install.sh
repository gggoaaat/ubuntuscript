#!/usr/bin/env bash
set -e

echo "==============================="
echo " 🧩 Installing AnyDesk"
echo "==============================="

# --- 1. Remove any old versions ---
sudo apt remove -y anydesk || true

# --- 2. Import AnyDesk GPG key and add repository ---
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/anydesk-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/anydesk-archive-keyring.gpg] http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list

# --- 3. Install AnyDesk ---
sudo apt update -y
sudo apt install -y anydesk

# --- 4. Enable and start the AnyDesk service ---
sudo systemctl enable anydesk.service
sudo systemctl start anydesk.service

# --- 5. Apply Wayland compatibility fix ---
# Wayland blocks screen capture by default for remote desktop tools.
# The workaround is to add a policy file under /etc/gdm3/custom.conf or set the environment variable.

WAYLAND_CONF="/etc/gdm3/custom.conf"

if [ -f "$WAYLAND_CONF" ]; then
  echo "🧩 Applying Wayland fix in $WAYLAND_CONF..."
  sudo sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' "$WAYLAND_CONF" || true

  # In case the line doesn't exist, append it
  if ! grep -q "WaylandEnable=false" "$WAYLAND_CONF"; then
    echo "WaylandEnable=false" | sudo tee -a "$WAYLAND_CONF" >/dev/null
  fi

  echo "✅ Wayland disabled for GDM — AnyDesk will use Xorg for compatibility."
else
  echo "⚠️  $WAYLAND_CONF not found. Skipping Wayland fix (may not be GDM-based system)."
fi

# --- 6. Restart GDM if running under GUI (to apply the change) ---
if systemctl is-active --quiet gdm; then
  echo "🔁 Restarting GDM to apply changes..."
  sudo systemctl restart gdm || echo "⚠️ Could not restart GDM. Please reboot manually."
else
  echo "💡 GDM not active — reboot required for Wayland fix to take effect."
fi

# --- 7. Display AnyDesk info ---
echo ""
echo "✅ AnyDesk installed successfully!"
echo "🔢 Your AnyDesk address:"
anydesk --get-id || echo "⚠️ Run 'anydesk' manually to view your ID after reboot."
echo "==============================="
