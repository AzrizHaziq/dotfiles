-- local function snacks_explorer_cwd()
--   local explorer = Snacks.picker.get({ source = 'explorer' })[1]
--   return explorer and explorer:cwd() or vim.fn.getcwd()
-- end

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
          disabled = 'gray',
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
        enabled = false,
        replace_netrw = true,
        trash = false,
        --  ["<c-c>"] = "tcd",
        --  ["<leader>/"] = "picker_grep",
        --  ["<c-t>"] = "terminal",
        --  ["I"] = "toggle_ignored",
        --  ["Z"] = "explorer_close_all",
      },
      terminal = {
        enabled = false,
      },
      image = {
        enabled = true,
        doc = {
          enabled = true,
          inline = true, -- render images inline in markdown/html
          float = true,
          max_width = 80,
          max_height = 40,
        },
        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          signcolumn = 'no',
        },
      },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = { hidden = false },
          grep = {},
          buffers = {
            win = {
              input = {
                keys = {
                  ['<c-d>'] = { 'bufdelete', mode = { 'n', 'i' } },
                },
              },
            },
          },
          explorer = {
            follow_file = false,
            git_status = true,
            git_untracked = true,
            hidden = true, -- Show hidden files (files starting with .)
            ignored = true, -- Show gitignored files
            exclude = { -- Exclude system files
              '.git',
              '.DS_Store',
              '*.swp',
              '*.swo',
              '*~',
              'node_modules/.cache',
              '.cache',
              'thumbs.db',
              'desktop.ini',
            },
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
                  ['<c-t>'] = false, -- disable terminal
                  ['<Esc>'] = false,
                  ['<C-v>'] = 'edit_vsplit',
                  ['<C-h>'] = false,
                  ['<C-j>'] = false,
                  ['<C-k>'] = false,
                  ['<C-l>'] = false,
                  ['G'] = 'toggle_gitignored', -- Toggle gitignored files
                  ['<leader>ca'] = 'copy_absolute',
                  ['<leader>cr'] = 'copy_relative',
                },
              },
              preview = {
                keys = {
                  ['<Esc>'] = false,
                },
              },
            },
            actions = {
              copy_relative = function(picker)
                local selected = picker:selected { fallback = true }
                if selected and #selected > 0 then
                  local cwd = picker:dir() or vim.fn.getcwd()
                  for _, item in ipairs(selected) do
                    if item.file then
                      local rel_path = vim.fn.fnamemodify(item.file, ':.' .. cwd)
                      vim.fn.setreg('+', rel_path)
                      Snacks.notify.info('Copied: ' .. rel_path)
                      break
                    end
                  end
                end
              end,

              copy_absolute = function(picker)
                local selected = picker:selected { fallback = true }
                if selected and #selected > 0 then
                  for _, item in ipairs(selected) do
                    if item.file then
                      local abs_path = vim.fn.fnamemodify(item.file, ':p')
                      vim.fn.setreg('+', abs_path)
                      Snacks.notify.info('Copied: ' .. abs_path)
                      break
                    end
                  end
                end
              end,

              -- Toggle gitignored files visibility
              toggle_gitignored = function(picker)
                picker.opts.ignored = not picker.opts.ignored
                local Actions = require 'snacks.explorer.actions'
                Actions.update(picker, { refresh = true })
              end,
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
        win = {
          preview = {
            wo = { wrap = true },
          },
          input = {
            keys = {
              ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<a-z>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
            },
          },
        },
      },
    },

    keys = {
      -- {
      --   '\\',
      --   function()
      --     require('snacks').explorer()
      --   end,
      --   desc = 'File Explorer',
      -- },

      {
        '<leader>gi',
        function()
          Snacks.picker.gh_issue()
        end,
        desc = 'GitHub Issues (open)',
      },
      {
        '<leader>gI',
        function()
          Snacks.picker.gh_issue { state = 'all' }
        end,
        desc = 'GitHub Issues (all)',
      },
      {
        '<leader>gp',
        function()
          Snacks.picker.gh_pr()
        end,
        desc = 'GitHub Pull Requests (open)',
      },
      {
        '<leader>gP',
        function()
          Snacks.picker.gh_pr { state = 'all' }
        end,
        desc = 'GitHub Pull Requests (all)',
      },
      {
        '<leader>gf',
        function()
          require('snacks').lazygit.log_file()
        end,
        desc = 'Lazygit File Logs',
      },

      {
        '<leader>ee',
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
      -- {
      --   '<leader>er',
      --   function()
      --     require('snacks').explorer.reveal()
      --   end,
      --   desc = '[Explorer] [R]eveal current file',
      -- },

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
        '<leader>sr',
        function()
          require('snacks').picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>sp',
        function()
          require('snacks').picker()
        end,
        desc = '[S]earch snacks [P]ickers',
      },

      -- { '<leader>sf', function() local cwd = snacks_explorer_cwd() require('snacks').picker.files { cwd = cwd, title = 'Find Files in ' .. vim.fn.fnamemodify(cwd, ':~') } end, desc = '[S]earch [F]iles', },
      -- { '<leader>ss', function() local cwd = snacks_explorer_cwd() require('snacks').picker.grep { cwd = cwd, title = 'Live Grep in ' .. vim.fn.fnamemodify(cwd, ':~') } end, desc = '[S]earch by [G]rep', },
      -- { '<leader>sw', function() require('snacks').picker.grep_word() end, mode = { 'n', 'x' }, desc = '[S]earch current [W]ord', }, -- Replaced by FFF
      -- { '<leader>sb', function() require('snacks').picker.grep_buffers() end, desc = '[S]earch [O]pen buffers', }, -- Replaced by FFF

      {
        '<leader>hf',
        function()
          require('snacks').picker.git_log_file()
        end,
        mode = 'n',
        desc = '[H]istory [F]ile',
      },
      {
        '<leader>hl',
        function()
          require('snacks').picker.git_log_line()
        end,
        mode = 'n',
        desc = '[H]istory [L]og line for file',
      },

      {
        'grf',
        function()
          require('snacks').rename.rename_file()
        end,
        desc = 'LSP: Rename Current File',
      },
      {
        '<leader>wz',
        function()
          require('snacks').picker.zoxide()
        end,
        desc = '[W]orkspace [Z]oxide',
      },
    },
  },
}

-- Explorer window keys
--   l / <CR>     open file or expand directory
--   h            close directory
--   .            focus path entry
--   /            grep from explorer
--   H            toggle hidden files (dotfiles)
--   G            toggle gitignored files (NEW!)
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
