return {
  'nanozuki/tabby.nvim',
  enabled = false,
  event = 'VimEnter',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.o.showtabline = 0
  end,
}
