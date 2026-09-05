"""Custom kitty tab bar mimicking tmux catppuccin style."""

import os
import socket

from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb
from kitty.utils import color_as_int

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


def _get_user_host() -> tuple[str, str]:
    """Get username and hostname (SSH-safe)."""
    try:
        username = os.getlogin()
    except OSError:
        username = os.environ.get("USER", "user")
    hostname = socket.gethostname().split('.')[0]
    return username, hostname


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

    # ─── LEFT: Session pill (only on first tab, only if session exists) ───
    if index == 1 and tab.session_name:
        screen.cursor.fg = as_rgb(GREEN)
        screen.cursor.bg = bar_bg
        screen.draw(LEFT_SEP)

        screen.cursor.fg = bar_bg
        screen.cursor.bg = as_rgb(GREEN)
        screen.cursor.bold = True
        screen.draw(f" 💻 {tab.session_name} ")

        screen.cursor.fg = as_rgb(GREEN)
        screen.cursor.bg = bar_bg
        screen.cursor.bold = False
        screen.draw(RIGHT_SEP + " ")

        before = screen.cursor.x

    # ─── MIDDLE: Tab pill ───
    # Active:   [BLUE num bg] | [SURFACE1 title bg]
    # Inactive: [SURFACE1 num bg] | [SURFACE0 title bg]
    num_bg   = BLUE     if tab.is_active else SURFACE1
    title_bg = SURFACE1 if tab.is_active else SURFACE0

    screen.cursor.fg = as_rgb(num_bg)
    screen.cursor.bg = bar_bg
    screen.draw(LEFT_SEP)

    screen.cursor.fg = bar_bg
    screen.cursor.bg = as_rgb(num_bg)
    screen.cursor.bold = tab.is_active
    screen.draw(f"{index} ")

    screen.cursor.fg = as_rgb(FG)
    screen.cursor.bg = as_rgb(title_bg)
    screen.cursor.bold = tab.is_active

    title = tab.title or ""
    avail = max_title_length - len(str(index)) - 6
    if avail > 0 and len(title) > avail:
        title = title[: avail - 1] + "…"
    screen.draw(f" {title} ")

    screen.cursor.fg = as_rgb(title_bg)
    screen.cursor.bg = bar_bg
    screen.cursor.bold = False
    screen.draw(RIGHT_SEP)

    end = screen.cursor.x

    screen.cursor.fg = bar_bg
    screen.cursor.bg = bar_bg
    screen.draw(" ")

    # ─── RIGHT: User and host pills (only after last tab) ───
    if is_last:
        username, hostname = _get_user_host()
        total_right = len(username) + 8 + len(hostname) + 7
        right_start = screen.columns - total_right

        gap = right_start - screen.cursor.x
        if gap > 0:
            screen.cursor.fg = bar_bg
            screen.cursor.bg = bar_bg
            screen.draw(" " * gap)

        # User pill — [SAPPHIRE: emoji] | [SURFACE1: username]
        screen.cursor.fg = as_rgb(SAPPHIRE)
        screen.cursor.bg = bar_bg
        screen.draw(LEFT_SEP)

        screen.cursor.fg = bar_bg
        screen.cursor.bg = as_rgb(SAPPHIRE)
        screen.cursor.bold = True
        screen.draw("👦 ")

        screen.cursor.fg = as_rgb(FG)
        screen.cursor.bg = as_rgb(SURFACE1)
        screen.cursor.bold = False
        screen.draw(f" {username} ")

        screen.cursor.fg = as_rgb(SURFACE1)
        screen.cursor.bg = bar_bg
        screen.draw(RIGHT_SEP + " ")

        # Host pill — [MAUVE: emoji] | [SURFACE1: hostname]
        screen.cursor.fg = as_rgb(MAUVE)
        screen.cursor.bg = bar_bg
        screen.draw(LEFT_SEP)

        screen.cursor.fg = bar_bg
        screen.cursor.bg = as_rgb(MAUVE)
        screen.cursor.bold = True
        screen.draw("💻 ")

        screen.cursor.fg = as_rgb(FG)
        screen.cursor.bg = as_rgb(SURFACE1)
        screen.cursor.bold = False
        screen.draw(f" {hostname} ")

        screen.cursor.fg = as_rgb(SURFACE1)
        screen.cursor.bg = bar_bg
        screen.draw(RIGHT_SEP)

    return end
