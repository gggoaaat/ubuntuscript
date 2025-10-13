#!/usr/bin/env bash
set -e

# Root logging setup
source ./scripts/00_logging.sh

echo "==============================="
echo "  🧰 Ubuntu Setup Starting"
echo "==============================="

# Run modules in order
for script in ./scripts/[0-9][0-9]_*.sh; do
  echo "▶️  Running $(basename "$script")..."
  bash "$script"
  echo "✅ Finished $(basename "$script")"
  echo ""
done

echo "==============================="
echo "🎯 Setup complete!"
echo "Logs saved to: $LOG_FILE"
echo "==============================="
