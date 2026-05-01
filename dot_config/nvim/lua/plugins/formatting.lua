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
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sql_formatter' },
      },
    },
  },
}
