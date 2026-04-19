local snacks = require 'snacks'

return {
  'folke/trouble.nvim',
  event = 'VeryLazy',
  opts = {
    -- Uncomment and customize if you want to override icons
    -- icons = require('nvim-web-devicons').get_icons(),
    -- Example for custom icons:
    icons = {
      error = '',
      warning = '',
      hint = '',
      information = '',
      other = '',
    },
  }, -- for default options, refer to the configuration section for custom setup.
  config = function(_, opts)
    require('trouble').setup(opts)
    -- Snacks notifications for Trouble events
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TroubleOpen',
      callback = function()
        snacks.notify('Trouble opened', 'info')
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TroubleClose',
      callback = function()
        snacks.notify('Trouble closed', 'info')
      end,
    })
  end,
  cmd = 'Trouble',
  keys = {
    {
      '<leader>qx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics',
    },
    {
      '<leader>qX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>qs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>ql',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ...',
    },
    {
      '<leader>qL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List',
    },
    {
      '<leader>qQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List',
    },
  },
}

-- vim.keymap.set('n', '<leader>ql', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
