return {
  {
    'NMAC427/guess-indent.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      filetype_exclude = {
        'netrw',
        'tutor',
        'lua',
      },
    },
  },

  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local C = require('catppuccin.palettes').get_palette 'mocha'

      require('hlchunk').setup {
        chunk = {
          enable = true,
          chars = {
            right_arrow = '◉', -- ● ○ ◉
          },
          duration = 200,
          delay = 1,
          style = {
            { fg = C.blue },
            { fg = C.maroon },
          },
        },
        indent = {
          enable = true,
          chars = { '¦' }, -- │┆┊
        },
        line_num = {
          enable = true,
          style = C.lavender,
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- Configure treesitter using its official native setup function
      require('nvim-treesitter.configs').setup {
        -- Replaces your local parsers table completely
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'css',
          'scss',
          'javascript',
          'typescript',
          'tsx',
          'json',
          'yaml',
          'regex',
        },

        -- Replaces your manual autocmd logic entirely
        -- Automatically installs a missing parser whenever you open a new filetype
        auto_install = true,

        -- Enables rich, faster syntax highlighting natively
        highlight = {
          enable = true,
          -- Option: set to true if you want to run standard vim regex highlighting
          -- alongside treesitter (usually left false for performance)
          additional_vim_regex_highlighting = false,
        },

        -- Replaces your manual indent logic block safely
        indent = {
          enable = true,
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    enable = false,
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'css',
        'scss',
        'javascript',
        'typescript',
        'tsx',
        'json',
        'yaml',
        'regex',
      }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then
          return
        end

        vim.treesitter.start(buf, language)

        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
        if has_indent_query then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
