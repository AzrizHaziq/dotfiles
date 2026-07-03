-- Set default format-on-save --[[ state  ]](can toggle with <leader>tf)
vim.g.enable_autoformat = true

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fb',
        function()
          require('conform').format {
            async = true,
            lsp_format = 'fallback',
          }
        end,
        mode = '',
        desc = '[F]ormat [B]uffer with conform',
      },
      {
        '<leader>tf',
        function()
          vim.g.enable_autoformat = not vim.g.enable_autoformat
          if vim.g.enable_autoformat then
            vim.notify('Format on save enabled', vim.log.levels.INFO)
          else
            vim.notify('Format on save disabled', vim.log.levels.INFO)
          end
        end,
        mode = 'n',
        desc = '[T]oggle [F]ormat on save',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if not vim.g.enable_autoformat then
          return nil
        end

        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end

        return {
          timeout_ms = 3000,
          lsp_format = 'fallback', -- Replaced true with fallback to avoid LSP/formatter race conditions
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Inner arrays tell Conform to pick ONE layout engine, then always run ESLint after it
        javascript = { 'prettier', 'eslint_d' },
        typescript = { 'prettier', 'eslint_d' },
        javascriptreact = { 'prettier', 'eslint_d' },
        typescriptreact = { 'prettier', 'eslint_d' },
        css = { 'prettier', stop_after_first = true },
        scss = { 'prettier', stop_after_first = true },
        html = { 'prettier', stop_after_first = true },
        json = { 'prettier', stop_after_first = true },
        yaml = { 'prettier', stop_after_first = true },
        markdown = { 'prettier', stop_after_first = true },
        sql = { 'sql_formatter' },
      },
    },
  },
}
