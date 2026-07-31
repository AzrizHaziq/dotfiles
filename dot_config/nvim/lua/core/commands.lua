vim.api.nvim_create_user_command(
  'SetColumnWidth',
  function(opts)
    -- Default to 80 if no argument is given, otherwise use the argument
    local width = opts.args ~= '' and opts.args or '80'
    vim.opt.colorcolumn = width
  end,
  { nargs = '?' } -- Allows 0 or 1 argument
)

vim.api.nvim_create_user_command('PrettierForce', function()
  vim.cmd('!npx prettier --write --no-config --ignore-path /dev/null ' .. vim.fn.expand '%')
end, {})
