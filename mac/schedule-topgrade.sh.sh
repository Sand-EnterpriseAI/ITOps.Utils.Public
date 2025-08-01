#!/bin/bash

set -euo pipefail

echo "Ensuring Homebrew is installed..."
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed."
fi

echo "Checking for topgrade..."
if ! command -v topgrade >/dev/null 2>&1; then
  echo "Installing topgrade..."
  brew install topgrade
else
  echo "Topgrade already installed."
fi

TOPGRADE_BIN="$(brew --prefix)/bin/topgrade"
PLIST_NAME="com.user.topgrade.monday"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"
LOG_DIR="$HOME/Library/Logs"
LOG_OUT="$LOG_DIR/topgrade.log"
LOG_ERR="$LOG_DIR/topgrade.err"

mkdir -p "$LOG_DIR"

echo "Writing LaunchAgent to $PLIST_PATH..."

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_NAME}</string>

    <key>ProgramArguments</key>
    <array>
        <string>${TOPGRADE_BIN}</string>
        <string>--yes</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>1</integer> <!-- Monday -->
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>${LOG_OUT}</string>
    <key>StandardErrorPath</key>
    <string>${LOG_ERR}</string>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

echo "Reloading launch agent..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "Topgrade will now run every Monday at 08:00."
echo "Logs: $LOG_OUT and $LOG_ERR"
