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
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon

                  if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= '' then
                      icon = color_item.abbr
                    end
                  end

                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local highlight = 'BlinkCmpKind' .. ctx.kind

                  if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      highlight = color_item.abbr_hl_group
                    end
                  end

                  return highlight
                end,
              },
            },
          },
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
            score_offset = -5,
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
      fuzzy = { implementation = 'lua' },
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
        },
      },
    },
  },
}
