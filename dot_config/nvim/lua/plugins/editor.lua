return {

  {
    'chrisgrieser/nvim-chainsaw',
    event = 'VeryLazy',
    opts = {},
    keys = {
      -- stylua: ignore start
      { '<leader>lm', function() require('chainsaw').messageLog() end, mode = { 'n', 'v' }, desc = '[l]og [m]essage' },
      { '<leader>lv', function() require('chainsaw').variableLog() end, mode = { 'n', 'v' }, desc = '[l]og [v]ariable' },
      { '<leader>lo', function() require('chainsaw').objectLog() end, mode = { 'n', 'v' }, desc = '[l]og [o]bject' },
      -- stylua: ignore end
    },
  },

  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  {
    'Wansmer/treesj',
    keys = {
      {
        '<leader>tj',
        function()
          require('treesj').toggle { split = { recursive = true } }
        end,
        mode = { 'n', 'v' },
        desc = '[T]oggle format J',
      },
    },
    config = function()
      require('treesj').setup {
        max_join_length = 200,
        use_default_keymaps = false,
      }
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      }
    end,
  },

  {
    'nvim-mini/mini.ai',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup()
    end,
  },

  {
    'kylechui/nvim-surround',
    version = '^4.0.0',
    event = 'VeryLazy',
    config = function()
      -- ysw"   → surround word with "
      -- ys3w(  → surround 3 words with ()
      -- yss(   → surround current line with ()
      -- ySS{   → surround current line with {} on new lines
      require('nvim-surround').setup {}
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above the cursor
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }

      vim.keymap.set('n', '[t', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'Jump to [T]op upper line' })
    end,
  },
}
