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
      gh = {},
      explorer = {
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
      dim = {
        scope = {
          min_size = 5,
          max_size = 20,
          siblings = true,
        },
        animate = {
          enabled = vim.fn.has("nvim-0.10") == 1,
          easing = "outQuad",
          duration = {
            step = 20,
            total = 300,
          },
        },
        filter = function(buf)
          return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
        end,
      },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = { hidden = false },
          grep = {},
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
                   ['<Esc>'] = false,
                   ['<C-v>'] = 'edit_vsplit',
                   ['<C-h>'] = 'edit_split',
                   ['<C-j>'] = false,
                   ['<C-k>'] = false,
                   ['<C-l>'] = false,
                   ['G'] = 'toggle_gitignored', -- Toggle gitignored files
                 },
               },
              preview = {
                keys = {
                  ['<Esc>'] = false,
                },
              },
            },
            actions = {
              -- Toggle gitignored files visibility
              toggle_gitignored = function(picker)
                picker.opts.ignored = not picker.opts.ignored
                local Actions = require 'snacks.explorer.actions'
                Actions.update(picker, { refresh = true })
              end,
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
        actions = {
          opencode_send = function(picker)
            local selected = picker:selected({ fallback = true })
            if selected and #selected > 0 then
              local files = {}
              for _, item in ipairs(selected) do
                if item.file then
                  table.insert(files, item.file)
                end
              end
              picker:close()

              require("opencode.core").open({
                new_session = false,
                focus = "input",
                start_insert = true,
              })

              local context = require("opencode.context")
              for _, file in ipairs(files) do
                context.add_file(file)
              end
            end
          end,
        },
        win = {
          input = {
            keys = {
              -- Use <localleader>o or any preferred key to send files to opencode
              ["<localleader>o"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
      },
    },

    keys = {
      { '\\', function() require('snacks').explorer() end, desc = 'File Explorer', },

      { '<leader>gi', function() Snacks.picker.gh_issue() end, desc = 'GitHub Issues (open)', },
      { '<leader>gI', function() Snacks.picker.gh_issue { state = 'all' } end, desc = 'GitHub Issues (all)', },
      { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)', },
      { '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub Pull Requests (all)', },
      { '<leader>gl', function() require('snacks').lazygit.log() end, desc = 'Lazygit Logs', },
      { '<leader>gf', function() require('snacks').lazygit.log_file() end, desc = 'Lazygit File Logs', },

      { '<leader>eb', function() require('snacks').picker.buffers() end, desc = '[E]xplorer [B]uffers', },
      { '<leader>ed', function() require('snacks').picker.diagnostics() end, desc = '[E]xplorer [D]iagnostics', },
      { '<leader>eg', function() require('snacks').picker.git_status() end, desc = '[E]xplorer [G]it changes', },
      { '<leader>er', function() require('snacks').explorer.reveal() end, desc = '[Explorer] [R]eveal current file', },

      { '<leader>sh', function() require('snacks').picker.help() end, desc = '[S]earch [H]elp', },
      { '<leader>sk', function() require('snacks').picker.keymaps() end, desc = '[S]earch [K]eymaps', },
      { '<leader>sr', function() require('snacks').picker.resume() end, desc = '[S]earch [R]esume', },
      { '<leader>sd', function() require('snacks').picker.diagnostics() end, desc = '[S]earch [D]iagnostics', },
      { '<leader>ss', function() require('snacks').picker() end, desc = '[S]earch [S]nacks pickers', },

      -- { '<leader>sw', function() require('snacks').picker.grep_word() end, mode = { 'n', 'x' }, desc = '[S]earch current [W]ord', }, -- Replaced by FFF
      -- { '<leader>so', function() require('snacks').picker.grep_buffers() end, desc = '[S]earch [O]pen buffers', }, -- Replaced by FFF

      { '<leader>hf', function() require('snacks').picker.git_log_file() end, mode = 'n', desc = '[H]istory [F]ile', },
      { '<leader>hl', function() require('snacks').picker.git_log_line() end, mode = 'n', desc = '[H]istory [L]og line for file', },

       { '<leader>rN', function() require('snacks').rename.rename_file() end, desc = 'Fast Rename Current File' },
       { '<leader>tD', function() require('snacks').dim.toggle() end, desc = '[T]oggle [D]im' },
   },
   }
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
