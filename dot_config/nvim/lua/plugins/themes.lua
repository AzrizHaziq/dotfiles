return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        transparent_background = false,
        styles = {
          comments = { 'italic' },
          conditionals = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          snacks = { enabled = true },
          treesitter = true,
          which_key = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
          },
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
