return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'saghen/blink.compat',
        version = '2.*',
        lazy = true,
        opts = {},
      },
      {
        'brenoprata10/nvim-highlight-colors',
        main = 'nvim-highlight-colors',
        opts = {},
      },
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = function()
          require('luasnip.loaders.from_lua').lazy_load {
            paths = { vim.fn.stdpath 'config' .. '/lua/snippets' },
          }
        end,
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        menu = {
          border = 'rounded',
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
          },
        },
      },
      sources = {
        default = { 'lsp', 'lazydev', 'snippets', 'path', 'buffer' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 10 },
          snippets = { score_offset = 1 },
          path = { score_offset = 3 },
          buffer = {
            min_keyword_length = 3,
            score_offset = -10,
          },
        },
      },
      cmdline = {
        enabled = true,
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == ':' then
            return { 'cmdline', 'path', 'buffer' }
          end
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          return {}
        end,
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust' },
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
        },
      },
    },
  },
}
