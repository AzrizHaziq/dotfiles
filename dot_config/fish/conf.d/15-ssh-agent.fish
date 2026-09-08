# SSH agent via keychain — persists across terminals and reboots
# First terminal after boot: prompts passphrase once, then silent forever
if status is-interactive
    if command -q keychain
        # Start agent if needed, then load env vars
        keychain --quiet --no-gui agent start
        keychain env --shell fish | source
        # Add key if not already loaded
        keychain --quiet --no-gui add ~/.ssh/id_ed25519_personal
    else
        echo "⚠️  keychain not found — run: sudo apt install keychain"
    end
end
