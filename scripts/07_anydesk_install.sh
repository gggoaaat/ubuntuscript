#!/usr/bin/env bash
set -e

echo "==============================="
echo " 🧩 Installing AnyDesk"
echo "==============================="

# Remove any old versions
sudo apt remove -y anydesk || true

# Import the AnyDesk GPG key
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/anydesk-archive-keyring.gpg

# Add the AnyDesk repository
echo "deb [signed-by=/usr/share/keyrings/anydesk-archive-keyring.gpg] http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list

# Update and install
sudo apt update -y
sudo apt install -y anydesk

# Enable and start the service
sudo systemctl enable anydesk.service
sudo systemctl start anydesk.service

# Display AnyDesk ID for confirmation
echo ""
echo "✅ AnyDesk installed successfully!"
echo "🔢 Your AnyDesk address:"
anydesk --get-id || echo "⚠️ Run 'anydesk' manually to see your ID after reboot."
echo "==============================="
