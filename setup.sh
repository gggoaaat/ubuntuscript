#!/usr/bin/env bash
set -e

REPO="gggoaaat/ubuntuscript"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/$REPO/$BRANCH"

# --------------------------------------------
# Logging setup
# --------------------------------------------
LOG_DIR="$HOME/setup_logs"
LOG_FILE="$LOG_DIR/setup-$(date +'%Y%m%d-%H%M').log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "==============================="
echo "  🧰 Remote Ubuntu Setup"
echo "==============================="
echo "📁 Logging to: $LOG_FILE"
echo "==============================="

# --------------------------------------------
# Function to fetch and execute a script from GitHub
# --------------------------------------------
run_remote_script() {
  local script_name="$1"
  local url="$RAW_BASE/scripts/$script_name"
  echo "▶️  Running $script_name ..."
  if curl -fsSL "$url" | bash; then
    echo "✅ Finished $script_name"
  else
    echo "❌ Error running $script_name"
    exit 1
  fi
  echo ""
}

# --------------------------------------------
# Run all numbered scripts in order
# --------------------------------------------
SCRIPT_LIST=$(curl -fsSL "https://api.github.com/repos/$REPO/contents/scripts?ref=$BRANCH" \
  | grep '"name":' | cut -d '"' -f 4 | grep '^[0-9][0-9]_.*\.sh' | sort)

for script in $SCRIPT_LIST; do
  run_remote_script "$script"
done

echo "==============================="
echo "🎯 Setup complete!"
echo "Logs saved to: $LOG_FILE"
echo "==============================="
