#!/usr/bin/env bash
set -euo pipefail

# Folder this script lives in (kitty-list-sessions.sh lives right next to it).
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Invoked via `launch --type=background`, so we get NO kitty env vars
# (KITTY_LISTEN_ON etc. are only set for programs running inside a kitty
# window). Find the main kitty control socket ourselves instead.
#
# Every kitty instance owns a /tmp/kitty-<pid> socket (`listen_on
# unix:/tmp/kitty`). Quick-access-terminal windows run as their own kitty
# process, so the main instance is whichever socket's process is NOT one.
main_sock=""
for sock in /tmp/kitty-*; do
    [[ -S "$sock" ]] || continue
    pid="${sock##*-}"
    cmd="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)" || continue
    [[ "$cmd" == *kitty-quick-access* ]] && continue
    main_sock="unix:$sock"
    break
done

if [[ -z "$main_sock" ]]; then
    echo "kitty-session-float: could not find the main kitty socket" >&2
    exit 1
fi

# The selector runs inside a floating quick-access-terminal (a separate kitty
# instance). Forward the main socket so it switches the main session, not the
# floating window's. The QAT auto-loads quick-access-terminal.conf (centered).
export KITTY_MAIN_SOCKET="$main_sock"
exec kitten quick-access-terminal \
    --instance-group session-selector \
    "$SCRIPT_DIR/kitty-list-sessions.sh"

