return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewFileHistory',
    'DiffviewRefresh',
  },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iffview open' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it repo [H]istory' },
    { '<leader>gx', '<cmd>DiffviewClose<cr>', desc = '[G]it diffview close' },
  },
  opts = {
    enhanced_diff_hl = true, -- Better diff highlights (added/removed word-level)
    use_icons = true, -- File icons in the panel (requires nvim-web-devicons)
    icons = { -- Only applies when use_icons is true.
      folder_closed = '',
      folder_open = '',
    },
    signs = {
      fold_closed = '',
      fold_open = '',
      done = '✓',
    },
    view = {
      default = {
        layout = 'diff2_horizontal',
        winbar_info = true, -- Show branch/commit info in winbar
      },
      merge_tool = {
        layout = 'diff3_horizontal',
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = {
        layout = 'diff2_horizontal',
        winbar_info = true,
      },
    },
    file_panel = {
      listing_style = 'tree',
      tree_options = {
        flatten_dirs = true,
        folder_statuses = 'only_folded',
      },
      win_config = {
        position = 'left',
        width = 35,
      },
    },
    file_history_panel = {
      win_config = {
        position = 'bottom',
        height = 16,
      },
    },
  },
  config = function(_, opts)
    -- Diagonal lines for deleted lines (the signature look from screenshots)
    vim.opt.fillchars:append { diff = '╱' }
    require('diffview').setup(opts)
  end,
}
