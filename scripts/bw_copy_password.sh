#!/usr/bin/env zsh
# Copy a Bitwarden login password and paste it using Cmd+V on macOS.

set -euo pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

ITEM_NAME="YOUR_ITEM_NAME"   # Bitwarden item name
FIELD="password"

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

ITEM_JSON="$("$BW_BIN" get item "$ITEM_NAME" 2>/dev/null || true)"
if [ -z "$ITEM_JSON" ]; then
  osascript -e 'display notification "Bitwarden item not found. Check ITEM_NAME." with title "StreamDock Bitwarden"'
  exit 1
fi

VALUE="$(python3 -c "
import sys, json
field = '$FIELD'
data = json.loads('''$ITEM_JSON''')
login = data.get('login') or {}
val = login.get(field) or ''
print(val)
")"

if [ -z "$VALUE" ]; then
  osascript -e 'display notification "Field not found in Bitwarden item." with title "StreamDock Bitwarden"'
  exit 1
fi

printf '%s' "$VALUE" | pbcopy

osascript <<EOF
tell application "System Events"
  keystroke "v" using command down
end tell
EOF

osascript -e 'display notification "Password pasted" with title "StreamDock Bitwarden"'
