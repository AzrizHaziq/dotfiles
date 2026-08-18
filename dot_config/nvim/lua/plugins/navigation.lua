return {
  {
    'lmilojevicc/herdr-splits.nvim',
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
      {
        '<C-h>',
        function()
          require('herdr-splits').move_cursor_left()
        end,
        desc = 'Navigate left',
      },
      {
        '<C-j>',
        function()
          require('herdr-splits').move_cursor_down()
        end,
        desc = 'Navigate down',
      },
      {
        '<C-k>',
        function()
          require('herdr-splits').move_cursor_up()
        end,
        desc = 'Navigate up',
      },
      {
        '<C-l>',
        function()
          require('herdr-splits').move_cursor_right()
        end,
        desc = 'Navigate right',
      },
      {
        '<M-h>',
        function()
          require('herdr-splits').resize_left()
        end,
        desc = 'Resize left',
      },
      {
        '<M-j>',
        function()
          require('herdr-splits').resize_down()
        end,
        desc = 'Resize down',
      },
      {
        '<M-k>',
        function()
          require('herdr-splits').resize_up()
        end,
        desc = 'Resize up',
      },
      {
        '<M-l>',
        function()
          require('herdr-splits').resize_right()
        end,
        desc = 'Resize right',
      },
    },
  },

  {
    'aserowy/tmux.nvim',
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
      {
        '<leader>tu',
        function()
          require('undotree').toggle()
        end,
        desc = '[T]oggle [U]ndo tree',
      },
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
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
