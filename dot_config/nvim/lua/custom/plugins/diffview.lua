return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
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
  opts = {},
}
