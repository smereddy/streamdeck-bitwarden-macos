#!/usr/bin/env zsh
# Copy a Bitwarden TOTP code and paste it using Cmd+V on macOS.
# Intended to be triggered from AmpliGame / StreamDock.

set -euo pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Replace this with your own Bitwarden item id
ITEM_ID="YOUR_TOTP_ITEM_ID"

SESSION_FILE="$HOME/.config/bitwarden/bw_session"

BW_BIN="$(command -v bw || true)"
if [ -z "$BW_BIN" ]; then
  osascript -e 'display notification "Bitwarden CLI (bw) not found" with title "StreamDock Bitwarden"'
  exit 1
fi

if [ -z "${BW_SESSION:-}" ] && [ -f "$SESSION_FILE" ]; then
  BW_SESSION="$(cat "$SESSION_FILE")"
fi

if [ -z "${BW_SESSION:-}" ]; then
  osascript -e 'display notification "Bitwarden session missing. Run: bw unlock --raw > ~/.config/bitwarden/bw_session" with title "StreamDock Bitwarden"'
  exit 1
fi

export BW_SESSION

TOTP_CODE="$("$BW_BIN" get totp "$ITEM_ID" 2>/dev/null || true)"

if [ -z "$TOTP_CODE" ]; then
  osascript -e 'display notification "Could not fetch TOTP code. Check ITEM_ID." with title "StreamDock Bitwarden"'
  exit 1
fi

printf '%s' "$TOTP_CODE" | pbcopy

osascript <<EOF
tell application "System Events"
  keystroke "v" using command down
end tell
EOF

osascript -e 'display notification "TOTP pasted" with title "StreamDock Bitwarden"'
