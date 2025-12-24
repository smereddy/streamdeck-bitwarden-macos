# Stream Deck Bitwarden Integration for macOS

> **One-tap password, username, and TOTP entry from any macro pad or stream deck**

[![macOS](https://img.shields.io/badge/macOS-compatible-brightgreen)](https://www.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## The Problem

You're logging into a site. You need your TOTP code. You reach for the mouse, click Bitwarden, search, copy, paste...

## The Solution

Press one button on your deck. Code pasted. Done.

---

## Works With Any Deck

This project works with **any macro pad or stream deck** that can trigger shell scripts or applications on macOS:

| Device | Software | Status |
|--------|----------|--------|
| **Elgato Stream Deck** | Stream Deck app | ✅ Tested |
| **Fifine AmpliGame D6** | HotSpot StreamDock | ✅ Tested |
| **Ajazz AKP153** | HotSpot StreamDock | Should work |
| **Ulanzi Stream Deck** | Ulanzi software | Should work |
| **Razer Stream Controller** | Razer Synapse | Should work |
| **Loupedeck** | Loupedeck software | Should work |
| **Any USB macro pad** | Karabiner/BetterTouchTool | Should work |
| **Touch Bar** | BetterTouchTool | Should work |
| **Keyboard shortcuts** | macOS/Raycast/Alfred | ✅ Works |

**If it can run an app or script, it can run Bitwarden.**

---

## How It Works

```
Button Press → Shell Script → Bitwarden CLI → Clipboard → Auto-paste
```

No browser extension magic. Just shell scripts and AppleScript.

---

## Quick Start

### 1. Install Bitwarden CLI

```bash
brew install bitwarden-cli
```

### 2. Set Up Session

```bash
bw login
mkdir -p ~/.config/bitwarden
bw unlock --raw > ~/.config/bitwarden/bw_session
chmod 600 ~/.config/bitwarden/bw_session
```

### 3. Clone & Configure

```bash
git clone https://github.com/smereddy/streamdeck-bitwarden-macos.git
cd streamdeck-bitwarden-macos
```

Edit scripts in `scripts/` and set your Bitwarden item IDs:
- `bw_copy_totp.sh` → set `ITEM_ID`
- `bw_copy_username.sh` → set `ITEM_NAME`
- `bw_copy_password.sh` → set `ITEM_NAME`

### 4. Create Automator App

1. Open **Automator** → New **Application**
2. Add **Run Shell Script** action
3. Set shell to `/bin/zsh`
4. Paste: `/path/to/scripts/bw_copy_totp.sh`
5. Save as `Bitwarden TOTP.app`

### 5. Map to Your Deck

**Elgato Stream Deck**: System → Open → select your .app

**Fifine/Ajazz (StreamDock)**: Add button → Open Application → select your .app

**Keyboard shortcut**: System Settings → Keyboard → Shortcuts → App Shortcuts

**Raycast/Alfred**: Create workflow that runs the script

---

## Scripts Included

| Script | What It Does |
|--------|--------------|
| `bw_copy_totp.sh` | Fetches TOTP code, pastes it |
| `bw_copy_username.sh` | Fetches username, pastes it |
| `bw_copy_password.sh` | Fetches password, pastes it |

All scripts:
- Show macOS notifications on success/failure
- Auto-paste using Cmd+V
- Work with any app that accepts keyboard input

---

## Finding Your Bitwarden Item ID

```bash
export BW_SESSION="$(cat ~/.config/bitwarden/bw_session)"
bw list items --search "github" | python3 -c "import sys,json; [print(f\"{i['name']}: {i['id']}\") for i in json.load(sys.stdin)]"
```

---

## Requirements

- **macOS** (tested on Sonoma/Ventura/Sequoia)
- **Bitwarden CLI** (`brew install bitwarden-cli`)
- **Any deck/macro pad** that can trigger apps or scripts
- **Accessibility permissions** for AppleScript keystroke injection

---

## Security Considerations

| Risk | Mitigation |
|------|------------|
| Session file on disk | `chmod 600`, FileVault encryption |
| Clipboard access | Scripts clear after paste (optional) |
| Keystroke injection | Requires explicit Accessibility permission |

This is designed for **personal use on a trusted machine**. Read the scripts before running them.

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| "Bitwarden CLI not found" | Ensure `/opt/homebrew/bin` is in PATH |
| "Session missing" | Run `bw unlock --raw > ~/.config/bitwarden/bw_session` |
| Keystrokes not working | System Settings → Privacy → Accessibility → Add Terminal/Automator |
| "Could not fetch TOTP" | Verify ITEM_ID, check session validity |

---

## Compatible Deck Software

| Software | Platform | Get It |
|----------|----------|--------|
| Stream Deck | macOS/Windows | [Elgato](https://www.elgato.com/downloads) |
| HotSpot StreamDock | macOS/Windows | Included with Fifine/Ajazz devices |
| BetterTouchTool | macOS | [folivora.ai](https://folivora.ai) |
| Karabiner-Elements | macOS | [karabiner-elements.pqrs.org](https://karabiner-elements.pqrs.org) |
| Raycast | macOS | [raycast.com](https://raycast.com) |
| Alfred | macOS | [alfredapp.com](https://www.alfredapp.com) |

---

## Related Projects

| Project | Description |
|---------|-------------|
| [StreamDeck to AmpliGame Port](https://github.com/smereddy/streamdeck-ampligame-port-macos) | Migrate Stream Deck plugins to AmpliGame/Fifine |
| [TheBeardofKnowledge/StreamDeck](https://github.com/TheBeardofKnowledge/StreamDeck) | Windows batch scripts for deck migration |

---

## Learn More

📖 **Medium Article**: *Coming soon* — Full walkthrough with security deep-dive

---

## Contributing

Have a better session management approach? Want to add Keychain integration? Tested with a different deck? PRs welcome.

## License

MIT — use it, fork it, improve it.

---

**Keywords**: Bitwarden, Stream Deck, Elgato, AmpliGame, Fifine D6, Ajazz, Ulanzi, Loupedeck, Razer, StreamDock, macOS, TOTP, 2FA, password manager, macro pad, automation, CLI, one-tap login
