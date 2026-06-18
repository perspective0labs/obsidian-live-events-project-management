#!/usr/bin/env bash
# Obsidian Live Events Project Management — Plugin Installer (macOS)
set -e

REPO="perspective0labs/obsidian-live-events-project-management"
RAW="https://raw.githubusercontent.com/$REPO/main/plugins"
PLUGINS=("obsidian-mastertour" "obsidian-google-workspace" "obsidian-google-chat" "claude-desktop-mirror")

echo ""
echo "Obsidian Live Events Project Management"
echo "Plugin Installer — macOS"
echo "======================================="
echo ""

# Find vault
DEFAULT_VAULT="$HOME/Documents/Obsidian"
echo "Enter the full path to your Obsidian vault."
echo "Press Enter to use: $DEFAULT_VAULT"
read -r VAULT_PATH
VAULT_PATH="${VAULT_PATH:-$DEFAULT_VAULT}"

if [ ! -d "$VAULT_PATH" ]; then
  echo "ERROR: Vault not found at $VAULT_PATH"
  echo "Create the folder first then re-run this script."
  exit 1
fi

PLUGINS_DIR="$VAULT_PATH/.obsidian/plugins"
mkdir -p "$PLUGINS_DIR"

echo ""
for PLUGIN in "${PLUGINS[@]}"; do
  echo "Installing $PLUGIN..."
  mkdir -p "$PLUGINS_DIR/$PLUGIN"
  curl -sL "$RAW/$PLUGIN/main.js"      -o "$PLUGINS_DIR/$PLUGIN/main.js"
  curl -sL "$RAW/$PLUGIN/styles.css"   -o "$PLUGINS_DIR/$PLUGIN/styles.css"
  curl -sL "$RAW/$PLUGIN/manifest.json" -o "$PLUGINS_DIR/$PLUGIN/manifest.json"
  echo "  ✓ $PLUGIN"
done

echo ""
echo "All plugins installed!"
echo ""
echo "Next steps:"
echo "  1. Open Obsidian and select your vault at: $VAULT_PATH"
echo "  2. Go to Settings → Community Plugins → turn off Restricted Mode"
echo "  3. Enable: Mastertour, Google Workspace, Google Chat, Claude Desktop Mirror"
echo "  4. Configure each plugin with your API credentials in Settings"
echo ""
