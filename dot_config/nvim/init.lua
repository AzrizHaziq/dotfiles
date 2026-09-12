require 'core'

-- lazy.nvim event lifecycle (load order):
-- [startup]
--   1. (no event / lazy=false)  → loads immediately, blocks startup
--   2. VimEnter                 → right after nvim starts, before UI drawn
--   3. UIEnter                  → after the UI is fully rendered
--   4. VeryLazy                 → lazy.nvim synthetic event, vim.schedule after UIEnter
--
-- [on file open]
--   5. BufReadPre               → before file is read into buffer
--   6. BufReadPost / BufRead    → after file is read (gitsigns, ufo, comment, etc.)
--   7. FileType / ft = '...'    → when filetype is detected (lazydev, etc.)
--
-- [on lsp ready]
--   8. LspAttach                → when an LSP server attaches to a buffer
--
-- [on interaction]
--   9. InsertEnter              → when entering insert mode (autopairs, etc.)
--  10. keys / cmd               → on-demand, loads only when triggered

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
