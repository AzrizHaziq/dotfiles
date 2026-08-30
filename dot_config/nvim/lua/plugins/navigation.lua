return {
  {
    'knubie/vim-kitty-navigator',
    cond = vim.env.TERM == 'xterm-kitty',
    build = 'cp ./*.py ~/.config/kitty/',
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
    end,
    keys = {
      -- stylua: ignore start
      { '<C-h>', '<cmd>KittyNavigateLeft<cr>', mode = { 'n', 'v', 'i' }, desc = 'KittyNavigateLeft' },
      { '<C-j>', '<cmd>KittyNavigateDown<cr>', mode = { 'n', 'v', 'i' }, desc = 'KittyNavigateDown' },
      { '<C-k>', '<cmd>KittyNavigateUp<cr>', mode = { 'n', 'v', 'i' }, desc = 'KittyNavigateUp' },
      { '<C-l>', '<cmd>KittyNavigateRight<cr>', mode = { 'n', 'v', 'i' }, desc = 'KittyNavigateRight' },
      { '<M-h>', function() if vim.fn.winnr '$' > 1 then vim.cmd 'wincmd <' else vim.uv.spawn('kitty', { args = { '@', 'resize-window', '--axis', 'horizontal', '--increment', '-3' } }, nil) end end, mode = { 'n' }, desc = 'Resize left', },
      { '<M-j>', function() if vim.fn.winnr '$' > 1 then vim.cmd 'wincmd -' else vim.uv.spawn('kitty', { args = { '@', 'resize-window', '--axis', 'vertical',   '--increment', '-3' } }, nil) end end, mode = { 'n' }, desc = 'Resize down', },
      { '<M-k>', function() if vim.fn.winnr '$' > 1 then vim.cmd 'wincmd +' else vim.uv.spawn('kitty', { args = { '@', 'resize-window', '--axis', 'vertical',   '--increment',  '3' } }, nil) end end, mode = { 'n' }, desc = 'Resize up', },
      { '<M-l>', function() if vim.fn.winnr '$' > 1 then vim.cmd 'wincmd >' else vim.uv.spawn('kitty', { args = { '@', 'resize-window', '--axis', 'horizontal', '--increment',  '3' } }, nil) end end, mode = { 'n' }, desc = 'Resize right', },
      -- stylua: ignore end
    },
  },

  {
    'lmilojevicc/herdr-splits.nvim',
    enabled = false,
    -- or local path during development:
    -- dir = '~/Projects/herdr-splits',
    cond = vim.env.HERDR_ENV == '1',
    event = 'VeryLazy',
    -- Optional: auto-sync the Herdr-side scripts when lazy updates this plugin. Requires `auto_sync_herdr = true` in setup() below to take effect.
    -- build = 'lua require("herdr-splits").sync_herdr()',
    config = function()
      require('herdr-splits').setup {
        -- Defaults shown. All fields optional.
        default_amount = 0.03, -- Herdr resize ratio
        neovim_amount = 3, -- Neovim resize cells
        at_edge = 'wrap', -- 'wrap' | 'stop' | 'split' | function
        ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
        ignored_filetypes = { 'NvimTree' },
        move_cursor_same_row = false,
        herdr_bin = nil, -- auto-detected from HERDR_BIN_PATH
        auto_sync_herdr = true, -- opt-in: sync Herdr-side scripts on update
      }
    end,
    keys = {
      -- stylua: ignore start
      { '<C-h>', function() require('herdr-splits').move_cursor_left() end, desc = 'Navigate left', },
      { '<C-j>', function() require('herdr-splits').move_cursor_down() end, desc = 'Navigate down', },
      { '<C-k>', function() require('herdr-splits').move_cursor_up() end, desc = 'Navigate up', },
      { '<C-l>', function() require('herdr-splits').move_cursor_right() end, desc = 'Navigate right', },
      { '<M-h>', function() require('herdr-splits').resize_left() end, desc = 'Resize left', },
      { '<M-j>', function() require('herdr-splits').resize_down() end, desc = 'Resize down', },
      { '<M-k>', function() require('herdr-splits').resize_up() end, desc = 'Resize up', },
      { '<M-l>', function() require('herdr-splits').resize_right() end, desc = 'Resize right', },
      -- stylua: ignore end
    },
  },

  {
    'aserowy/tmux.nvim',
    enabled = false,
    event = 'VeryLazy',
    cond = vim.env.TMUX,
    config = function()
      require('tmux').setup {
        navigation = {
          cycle_navigation = false,
          enable_default_keybindings = true,
          persist_zoom = false,
        },
      }
    end,
  },

  {
    'jiaoshijie/undotree',
    event = 'VeryLazy',
    keys = {
      -- stylua: ignore start
      { '<leader>tu', function() require('undotree').toggle() end, desc = '[T]oggle [U]ndo tree', },
      -- stylua: ignore end
    },
    opts = {
      float_diff = true,
      position = 'right',
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      -- stylua: ignore start
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash', },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter', },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash', },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search', },
      -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      -- stylua: ignore end
    },
  },
}
