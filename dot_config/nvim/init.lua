-- Neovim 0.12+ Configuration
-- Requires: Neovim >= 0.12 (uses vim.uv, modern LSP APIs)
require 'core'

--[[ local ok, ui2 = pcall(require, 'vim._core.ui2')

if ok then
  ui2.enable {
    enable = true,
    msg = {
      targets = {
        msg = 'pager',
        lua_error = 'pager',
        search_count = 'cmd',
        [''] = 'msg',
      },
      -- cmd = { height = 0.5 },
      msg = { timeout = 3000 },
    } 
  }
end ]]

require('lazy').setup({
  { import = 'plugins' },
}, {
  rocks = {
    enabled = false,
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
     require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
