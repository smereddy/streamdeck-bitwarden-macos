# Bitwarden CLI Setup on macOS

This guide walks through setting up Bitwarden CLI for use with AmpliGame / StreamDock.

## Prerequisites

- macOS with Homebrew installed
- A Bitwarden account
- AmpliGame / StreamDock software installed

## Step 1: Install Bitwarden CLI

```bash
brew install bitwarden-cli
```

Verify the installation:

```bash
bw --version
```

## Step 2: Log in to Bitwarden

```bash
bw login
```

Follow the prompts to enter your email and master password. If you have 2FA enabled, you'll be prompted for that as well.

## Step 3: Unlock and Store Session Token

The Bitwarden CLI requires an active session to access your vault. We'll store this in a file:

```bash
mkdir -p "$HOME/.config/bitwarden"
bw unlock --raw > "$HOME/.config/bitwarden/bw_session"
chmod 600 "$HOME/.config/bitwarden/bw_session"
```

**Important:** This session token grants access to your vault. Keep the file secure.

## Step 4: Find Your Item IDs

To use the TOTP script, you need the Bitwarden item ID:

```bash
export BW_SESSION="$(cat "$HOME/.config/bitwarden/bw_session")"
bw list items --search "your search term" | python3 -c "import sys,json; [print(f\"{i['name']}: {i['id']}\") for i in json.load(sys.stdin)]"
```

For username/password scripts, you can use the item name directly.

## Step 5: Configure the Scripts

Edit each script in `scripts/` and set:

### bw_copy_totp.sh
```bash
ITEM_ID="your-bitwarden-item-id-here"
```

### bw_copy_username.sh and bw_copy_password.sh
```bash
ITEM_NAME="Your Item Name"
```

## Step 6: Create Automator Apps

For each script you want to trigger from the deck:

1. Open **Automator** (Applications → Automator)
2. Choose **Application** as the document type
3. Search for "Run Shell Script" and drag it to the workflow
4. Set **Shell** to `/bin/zsh`
5. Set **Pass input** to "to stdin"
6. Enter the full path to your script:
   ```
   /Users/YOUR_USERNAME/Projects/ampligame-bitwarden-macos/scripts/bw_copy_totp.sh
   ```
7. Save as `Bitwarden TOTP.app` in a convenient location

Repeat for other scripts (username, password).

## Step 7: Map to StreamDock

In the AmpliGame / StreamDock software:

1. Select a button on your deck
2. Choose "Open" or "Application" action
3. Browse to your Automator app
4. Optionally assign a custom icon

## Session Maintenance

The Bitwarden session expires after a period of inactivity. When it expires:

1. Open Terminal
2. Run:
   ```bash
   bw unlock --raw > "$HOME/.config/bitwarden/bw_session"
   ```

Consider creating a script or reminder to refresh the session periodically.

## Troubleshooting

### "Bitwarden CLI (bw) not found"
Ensure Homebrew's bin is in your PATH. The scripts include common paths, but you may need to adjust.

### "Bitwarden session missing"
Run `bw unlock --raw > ~/.config/bitwarden/bw_session` to refresh your session.

### "Could not fetch TOTP code"
- Verify the ITEM_ID is correct
- Check that the item has TOTP configured in Bitwarden
- Ensure your session is still valid

### Keystrokes not working
macOS requires accessibility permissions for AppleScript to send keystrokes:
1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Add Terminal (or your Automator app) to the allowed list

## Security Notes

- The session file (`~/.config/bitwarden/bw_session`) should have `600` permissions
- These scripts are designed for personal use on a trusted machine
- Consider the tradeoffs between convenience and security for your use case
