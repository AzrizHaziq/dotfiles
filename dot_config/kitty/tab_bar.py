"""Custom kitty tab bar mimicking tmux catppuccin style."""

import os
import socket

from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb
from kitty.utils import color_as_int
from kitty.fast_data_types import get_boss

# ═══════════════════════════════════════════════════════════════════════════
# CATPPUCCIN MOCHA COLORS
# ═══════════════════════════════════════════════════════════════════════════
BG        = 0x1e1e2e
FG        = 0xcdd6f4
OVERLAY0  = 0x6c7086  # dim, for the │ divider
SURFACE0  = 0x313244  # inactive title bg
SURFACE1  = 0x45475a  # active title bg / inactive num bg
BLUE      = 0x89b4fa  # active num bg
GREEN     = 0xa6e3a1
SAPPHIRE  = 0x74c7ec  # user pill
MAUVE     = 0xcba6f7  # host pill

# Powerline rounded separators (nerd font)
LEFT_SEP  = "\ue0b6"  # 
RIGHT_SEP = "\ue0b4"  # 


def _draw_pill(screen: Screen, text: str, color: int, bar_bg: int) -> None:
    """Draw a rounded powerline pill: bg=color, text fg=bar_bg (dark-on-accent)."""
    screen.cursor.fg = as_rgb(color)
    screen.cursor.bg = bar_bg
    screen.draw(LEFT_SEP)
    screen.cursor.fg = bar_bg
    screen.cursor.bg = as_rgb(color)
    screen.cursor.bold = True
    screen.draw(text)
    screen.cursor.fg = as_rgb(color)
    screen.cursor.bg = bar_bg
    screen.cursor.bold = False
    screen.draw(RIGHT_SEP)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Draw a single tab in tmux catppuccin style."""

    # Derive bar bg from kitty config (tab_bar_background) so it always matches
    bar_bg = as_rgb(color_as_int(draw_data.default_bg))

    # ─── MIDDLE: Tab pill ───
    # Active:   [BLUE num bg] | [SURFACE1 title bg]
    # Inactive: [SURFACE1 num bg] | [SURFACE0 title bg]
    num_bg   = BLUE     if tab.is_active else SURFACE1
    title_bg = SURFACE1 if tab.is_active else SURFACE0

    screen.cursor.fg = as_rgb(num_bg)
    screen.cursor.bg = bar_bg
    screen.draw(LEFT_SEP)

    screen.cursor.fg = bar_bg if tab.is_active else as_rgb(FG)
    screen.cursor.bg = as_rgb(num_bg)
    screen.cursor.bold = tab.is_active
    screen.draw(f"{index} ")

    screen.cursor.fg = as_rgb(FG)
    screen.cursor.bg = as_rgb(title_bg)
    screen.cursor.bold = tab.is_active

    # workmux AI status icon is a suffix: always shown in full, not counted
    # against the title truncation budget.
    status = _get_workmux_status(tab.tab_id)
    status_suffix = f' {status}' if status else ''

    title = tab.title or ""
    avail = max_title_length - len(str(index)) - 6 - len(status_suffix)
    if avail > 0 and len(title) > avail:
        title = title[: avail - 1] + "…"
    screen.draw(f" {title}{status_suffix} ")

    screen.cursor.fg = as_rgb(title_bg)
    screen.cursor.bg = bar_bg
    screen.cursor.bold = False
    screen.draw(RIGHT_SEP)

    end = screen.cursor.x

    screen.cursor.fg = bar_bg
    screen.cursor.bg = bar_bg
    screen.draw(" ")

    if is_last:
        # Dynamic right pills: session (hidden if unnamed) and remote identity
        # (hidden unless actually ssh'd into a different host).
        pills: list[tuple[str, int]] = []
        if tab.session_name:
            pills.append((tab.session_name, GREEN))
        user, host, is_remote = _get_active_identity()
        if is_remote:
            pills.append((f"{user}@{host}" if user else host, MAUVE))

        if pills:
            total_right = sum(len(text) + 2 for text, _ in pills) + len(pills) - 1
            right_start = screen.columns - total_right
            gap = right_start - screen.cursor.x

            screen.cursor.fg = screen.cursor.bg = bar_bg
            if gap > 0:
                screen.draw(" " * gap)
            else:
                # Not enough room: pills always win, drawn over/behind tab text.
                screen.cursor.x = max(0, right_start)

            for i, (text, color) in enumerate(pills):
                if i:
                    screen.cursor.fg = screen.cursor.bg = bar_bg
                    screen.draw(" ")
                _draw_pill(screen, text, color, bar_bg)
    return end


_SSH_FLAGS_WITH_VALUE = {
    '-l', '-p', '-i', '-o', '-F', '-b', '-c', '-D',
    '-E', '-e', '-L', '-R', '-W', '-w', '-B', '-J', '-Q',
}


def _parse_ssh_target(cmdline: list[str]) -> tuple[str | None, str] | None:
    """Parse `ssh [flags] [user@]host ...` argv, return (user, host) or None.

    user is None when not given explicitly (via `user@host` or `-l user`),
    in which case the caller should consult ~/.ssh/config before assuming
    the local username.
    """
    if not cmdline or os.path.basename(cmdline[0]).lower() != 'ssh':
        return None
    user: str | None = None
    i = 1
    n = len(cmdline)
    while i < n:
        arg = cmdline[i]
        if arg == '-l' and i + 1 < n:
            user = cmdline[i + 1]
            i += 2
            continue
        if arg.startswith('-'):
            i += 2 if arg in _SSH_FLAGS_WITH_VALUE else 1
            continue
        if '@' in arg:
            user, host = arg.split('@', 1)
            return user, host
        return user, arg
    return None


def _lookup_ssh_config_user(host_alias: str) -> str | None:
    """Best-effort lookup of `User` for a Host alias in ~/.ssh/config."""
    import fnmatch

    try:
        with open(os.path.expanduser('~/.ssh/config')) as f:
            lines = f.readlines()
    except OSError:
        return None
    matched = False
    for line in lines:
        parts = line.strip().split(None, 1)
        if len(parts) != 2 or parts[0].lower() not in ('host', 'user'):
            continue
        key, val = parts[0].lower(), parts[1].strip()
        if key == 'host':
            matched = any(fnmatch.fnmatch(host_alias, p) for p in val.split())
        elif matched:
            return val
    return None


def _get_local_user_host() -> tuple[str, str]:
    """Get username and hostname of the local kitty process (SSH-safe)."""
    try:
        username = os.getlogin()
    except OSError:
        username = os.environ.get('USER', 'user')
    hostname = socket.gethostname().split('.')[0]
    return username, hostname


def _get_active_identity() -> tuple[str | None, str, bool]:
    """Return (user, host, is_remote) for the currently active window.

    is_remote is True only when the foreground process is ssh'd into a host
    other than the local machine. user is None when the remote user could
    not be determined (not given explicitly and no ~/.ssh/config match) -
    the local username is never used as a stand-in for a remote one.
    """
    local_user, local_host = _get_local_user_host()
    window = get_boss().active_window
    if window is not None:
        try:
            target = _parse_ssh_target(window.child.foreground_cmdline)
        except Exception:
            target = None
        if target:
            user, host = target
            user = user or _lookup_ssh_config_user(host)
            return user, host, host != local_host
    return local_user, local_host, False


def _get_workmux_status(tab_id: int) -> str:
    """Look up the workmux AI status icon for a tab, if any window set it."""
    tab = get_boss().tab_for_id(tab_id)
    if tab:
        for window in tab:
            status = window.user_vars.get('workmux_status', '')
            if status:
                return status
    return ''

