vim.api.nvim_create_user_command(
  'SetColumnWidth',
  function(opts)
    -- Default to 80 if no argument is given, otherwise use the argument
    local width = opts.args ~= '' and opts.args or '80'
    vim.opt.colorcolumn = width
  end,
  { nargs = '?' } -- Allows 0 or 1 argument
)
