return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
        json = { 'jsonlint' },
        dockerfile = { 'hadolint' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        yaml = { 'yamllint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    opts = {
      icons = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '',
      },
    },
    cmd = 'Trouble',
    keys = {
      { '<leader>qX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics' },
      { '<leader>qx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics' },
      { '<leader>qs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>ql', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ...' },
      { '<leader>qL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List' },
      { '<leader>qq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List' },
    },
  },
}
