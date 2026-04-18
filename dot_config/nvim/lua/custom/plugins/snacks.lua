local Snacks = require 'snacks'

return {
  {
    'folke/snacks.nvim',
    lazy = true,
    priority = 1000,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
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
          files = {
            hidden = true,
          },
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
                },
              },
              preview = {
                keys = {
                  ['<Esc>'] = false,
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        '\\',
        function()
          Snacks.explorer()
        end,
        desc = 'File Explorer',
      },
      {
        '<leader>eb',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[e]xplorer [b]uffers',
      },
      {
        '<leader>ed',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[E]xplorer [D]iagnostics',
      },
      {
        '<leader>eg',
        function()
          Snacks.picker.git_status()
        end,
        desc = '[E]xplorer [G]it changes',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>so',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = '[S]earch [O]pen buffers',
      },
      {
        '<leader>sr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker()
        end,
        desc = '[S]earch [S]nacks pickers',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        mode = { 'n', 'x' },
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>er',
        function()
          Snacks.explorer.reveal()
        end,
        desc = 'Reveal current file in Explorer',
      },
      {
        '<leader>hl',
        function()
          Snacks.picker.git_log_line()
        end,
        mode = 'n',
        desc = '[H]istory [L]og line for file',
      },
      {
        '<leader>hf',
        function()
          Snacks.picker.git_log_file()
        end,
        mode = 'n',
        desc = '[H]istory [F]ile',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.lines()
        end,
        desc = '[S]earch [L]ines',
      },
      {
        '<leader>sf',
        function()
          Snacks.picker.files { title = 'Find Files in ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~') }
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep { title = 'Live Grep in ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~') }
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },
    },
  },
}

-- Snacks cheat sheet
-- Conflicts avoided
--   <leader>fb   kept for format buffer, so buffers use <leader>eb
--   <leader><leader> old Telescope buffers removed (leader maps now use 2+ keys)
--   GitHub Snacks pickers intentionally not mapped
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
--   <leader>sr   resume last Snacks picker
--   <leader>ss   show all Snacks pickers
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
