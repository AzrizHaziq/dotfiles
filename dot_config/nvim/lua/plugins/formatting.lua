vim.g.enable_autoformat = true

-- LSP format
vim.keymap.set('n', '<leader>fv', vim.lsp.buf.format, { desc = '[F]ormat buffer (LSP)' })

-- JSON deep sort and format
local function format_json_deep()
  local filename = vim.fn.expand '%'

  if not filename:match '%.json$' then
    vim.notify('Not a JSON file', vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')
  local result = vim.fn.system('sort-json-deep', content)

  if vim.v.shell_error ~= 0 then
    vim.notify('JSON format error: ' .. result, vim.log.levels.ERROR)
    return
  end

  local sorted_lines = vim.split(result, '\n')
  if sorted_lines[#sorted_lines] == '' then
    table.remove(sorted_lines)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, sorted_lines)
  vim.notify('JSON sorted and formatted', vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>fj', format_json_deep, { desc = '[F]ormat [J]SON (deep sort)' })

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
