#!/bin/bash

set -euo pipefail

PLIST_NAME="com.user.topgrade.monday"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
TOPGRADE_PATH="$(command -v topgrade || true)"
USER_ID=$(id -u)

echo "Checking topgrade installation..."
if [[ -z "$TOPGRADE_PATH" ]]; then
  echo "topgrade is NOT installed"
  exit 1
else
  echo "topgrade is installed at: $TOPGRADE_PATH"
  "$TOPGRADE_PATH" --version
fi

echo
echo "Checking LaunchAgent plist..."
if [[ ! -f "$PLIST_PATH" ]]; then
  echo "LaunchAgent not found at: $PLIST_PATH"
  exit 1
else
  echo "LaunchAgent plist found"
fi

echo
echo "Checking if LaunchAgent is loaded..."
if launchctl list | grep -q "$PLIST_NAME"; then
  echo "LaunchAgent is loaded in launchd"
else
  echo "LaunchAgent is NOT loaded"
  echo "You can try to load it with:"
  echo "launchctl load \"$PLIST_PATH\""
  exit 1
fi

echo
echo "Next run will be Monday at 08:00"
echo "Logs:"
echo "  stdout: $HOME/Library/Logs/topgrade.log"
echo "  stderr: $HOME/Library/Logs/topgrade.err"

echo
echo "Kickstarting it now to confirm it runs..."
launchctl kickstart -k gui/"$USER_ID"/"$PLIST_NAME"
sleep 2

if tail -n 5 "$HOME/Library/Logs/topgrade.log" 2>/dev/null | grep -qi topgrade; then
  echo "Log output confirms topgrade is running"
else
  echo "No recent topgrade output in log yet (may take a moment)"
fi
