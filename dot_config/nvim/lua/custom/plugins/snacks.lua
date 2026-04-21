local function snacks_explorer_cwd()
  local explorer = Snacks.picker.get({ source = 'explorer' })[1]
  return explorer and explorer:cwd() or vim.fn.getcwd()
end

return {
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      bigfile = { enabled = true },
      toggle = {
        map = vim.keymap.set, -- keymap.set function to use
        which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
        notify = true,
        icon = {
          enabled = ' ',
          disabled = ' ',
        },
        color = {
          enabled = 'green',
          disabled = 'yellow',
        },
      },
      scroll = {
        animate = {
          duration = { step = 10, total = 200 },
          easing = 'linear',
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = 'linear',
        },
      },
      sources = {
        files = {
          args = { '--hidden', '--exclude', '.git' },
        },
        grep = {
          args = { '--hidden' },
        },
      },
      explorer = {
        replace_netrw = true,
        trash = false,
      },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = { hidden = true },
          grep = {},
          explorer = {
            follow_file = false,
            git_status = true,
            git_untracked = true,
            hidden = true,
            diagnostics = true,
            layout = { preset = 'sidebar', preview = false },
            win = {
              input = {
                keys = {
                  ['<Esc>'] = false,
                  ['<BS>'] = 'explorer_up',
                },
              },
              list = {
                keys = {
                  ['<Esc>'] = false,
                  ['<C-v>'] = 'edit_vsplit',
                  ['<C-h>'] = false,
                  ['<C-j>'] = false,
                  ['<C-k>'] = false,
                  ['<C-l>'] = false,
                  -- ['<C-h>'] = 'tmux_left_pane',
                },
              },
              preview = {
                keys = {
                  ['<Esc>'] = false,
                },
              },
            },
            actions = {
              -- tmux_left_pane  = function() require('nvim-tmux-navigation').NvimTmuxNavigateLeft() end,
            },
          },
        },
        previewers = {
          diff = {
            -- fancy: fancy diff (borders, multi-column line numbers, syntax highlighting)
            -- syntax: Neovim's built-in diff syntax highlighting
            -- terminal: external command (git's pager for git commands, `cmd` for other diffs)
            style = 'syntax',
          },
          file = {
            max_size = 1024 * 1024, -- 1MB
            max_line_length = 500, -- max line length
            ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
          },
          man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
        },
      },
    },

    keys = {
      {
        '\\',
        function()
          require('snacks').explorer()
        end,
        desc = 'File Explorer',
      },
      {
        '<leader>eb',
        function()
          require('snacks').picker.buffers()
        end,
        desc = '[E]xplorer [B]uffers',
      },
      {
        '<leader>ed',
        function()
          require('snacks').picker.diagnostics()
        end,
        desc = '[E]xplorer [D]iagnostics',
      },
      {
        '<leader>eg',
        function()
          require('snacks').picker.git_status()
        end,
        desc = '[E]xplorer [G]it changes',
      },
      {
        '<leader>sh',
        function()
          require('snacks').picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          require('snacks').picker.keymaps()
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>so',
        function()
          require('snacks').picker.grep_buffers()
        end,
        desc = '[S]earch [O]pen buffers',
      },
      {
        '<leader>sr',
        function()
          require('snacks').picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>ss',
        function()
          require('snacks').picker()
        end,
        desc = '[S]earch [S]nacks pickers',
      },
      {
        '<leader>sw',
        function()
          require('snacks').picker.grep_word()
        end,
        mode = { 'n', 'x' },
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sd',
        function()
          require('snacks').picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>er',
        function()
          require('snacks').explorer.reveal()
        end,
        desc = '[Explorer] [R]eveal current file',
      },

      {
        '<leader>hf',
        function()
          require('snacks').picker.git_log_file()
        end,
        mode = 'n',
        desc = '[H]istory [F]ile',
      },
      -- {
      --   '<leader>hf',
      --   function()
      --     local file = vim.fn.expand '%:p'
      --     local cmd = string.format("tmux display-popup -w 80%% -h 80%% -d '%s' -E 'lazygit -f %s'", vim.fn.getcwd(), file)
      --     vim.fn.system(cmd)
      --   end,
      --   mode = 'n',
      --   desc = 'Lazygit: log current file',
      -- },
      {
        '<leader>hl',
        function()
          require('snacks').picker.git_log_line()
        end,
        mode = 'n',
        desc = '[H]istory [L]og line for file',
      },
      -- {  doesnt work
      --   '<leader>hl',
      --   function()
      --     local file = vim.fn.expand '%:p'
      --     local line = vim.fn.line '.'
      --     local cmd = string.format(
      --       "tmux display-popup -w 80%% -h 80%% -d '%s' -E 'git blame %s -L %d,%d; read -n 1 -s -r -p \"Press any key for lazygit...\"; lazygit'",
      --       vim.fn.getcwd(),
      --       file,
      --       line,
      --       line
      --     )
      --     vim.fn.system(cmd)
      --   end,
      --   mode = 'n',
      --   desc = 'Lazygit: blame current line',
      -- },
      -- {
      --   '<leader>sl',
      --   function()
      --     require('snacks').picker.lines()
      --   end,
      --   desc = '[S]earch [L]ines',
      --
      -- },

      {
        '<leader>sf',
        function()
          local cwd = snacks_explorer_cwd()
          require('snacks').picker.files { cwd = cwd, title = 'Find Files in ' .. vim.fn.fnamemodify(cwd, ':~') }
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sg',
        function()
          local cwd = snacks_explorer_cwd()
          require('snacks').picker.grep { cwd = cwd, title = 'Live Grep in ' .. vim.fn.fnamemodify(cwd, ':~') }
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sn',
        function()
          require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },
    },
  },
}

-- require('snacks').cheat sheet
-- Conflicts avoided
--   <leader>fb   kept for format buffer, so buffers use <leader>eb
--   <leader><leader> old Telescope buffers removed (leader maps now use 2+ keys)
--   GitHub require('snacks').pickers intentionally not mapped
--
-- Leader keymaps
--   <leader>er   reveal current file in explorer
--   <leader>eb   toggle buffers picker
--   <leader>eg   toggle git changes picker
--   <leader>ed   toggle diagnostics picker
--   <leader>sf   find files
--   <leader>sg   live grep
--   <leader>sG   grep in chosen folder
--   <leader>sh   help tags
--   <leader>sk   show keymaps
--   <leader>sl   search current buffer lines
--   <leader>sn   search Neovim config files
--   <leader>so   grep open buffers
--   <leader>sr   resume last require('snacks').picker
--   <leader>ss   show all require('snacks').pickers
--   <leader>sw   grep current word / visual selection
--   <leader>sd   search diagnostics
--   <leader>gl   lazygit
--
-- Explorer window keys
--   l / <CR>     open file or expand directory
--   h            close directory
--   .            focus path entry
--   /            grep from explorer
--   H            toggle hidden files
--   I            toggle ignored files
--   P            toggle preview
--   a            add file or directory
--   d            delete file or directory
--   r            rename file or directory
--   c            copy file or directory
--   m            move file or directory
--   y            yank path
--   p            paste
--   u            refresh explorer
--   ]g / [g      next / prev git change
--   ]d / [d      next / prev diagnostic
--   ]w / [w      next / prev warning
--   ]e / [e      next / prev error
