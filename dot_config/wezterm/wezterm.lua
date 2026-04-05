local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Use a broadly available terminfo entry so tmux works reliably in local/WSL shells.
config.term = 'xterm-256color'

-- Font: change "JetBrainsMono Nerd Font" to whatever Nerd Font you installed
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 12.0
config.color_scheme = 'Catppuccin Mocha'

-- Nerd Font glyph rendering: allow wezterm to use wide/double-width glyphs
config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- WSL: ensures box-drawing and powerline symbols align correctly
config.cell_width = 1.0
config.line_height = 1.0

-- Prevent fallback font from breaking nerd font icons
config.warn_about_missing_glyphs = false

-- --- UI & LAYOUT ---
-- Disables the top tab bar entirely
config.enable_tab_bar = false

-- Removes the title bar and "Traffic Lights" (on macOS)
-- Options: "NONE" (no border), "RESIZE" (thin border only), "TITLE | RESIZE" (default)
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.use_resize_increments = true

-- --- KEYBINDINGS ---
-- Disables all default WezTerm shortcuts to prevent tmux conflicts
config.disable_default_key_bindings = true

config.keys = {
  -- Ctrl+Backspace: delete word to the left
  {
    key = 'Backspace',
    mods = 'CTRL',
    action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
  },

  -- Copy / Paste
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

  -- Reload configuration (useful when editing this file)
  { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },

  -- Toggle Fullscreen
  -- { key = 'Enter', mods = 'ALT', action = wezterm.action.ToggleFullScreen },
}

return config
