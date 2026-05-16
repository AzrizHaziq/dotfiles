return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎+' },
        change = { text = '▎~' },
        delete = { text = '▎-' },
        topdelete = { text = '▎-' },
        changedelete = { text = '▎~' },
        untracked = { text = '▎?' },
      },
      signs_staged = {
        add = { text = '▎+' },
        change = { text = '▎~' },
        delete = { text = '▎-' },
        topdelete = { text = '▎-' },
        changedelete = { text = '▎~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        local function hunk_diff_file_floating()
          local file = vim.fn.expand '%:p'
          local cwd = vim.fn.getcwd()

          -- Build tmux command with proper shell quoting
          -- shellescape adds single quotes, so file will be 'path/to/file'
          local escaped_file = vim.fn.shellescape(file)
          local escaped_cwd = vim.fn.shellescape(cwd)

          -- Use bash -c to properly interpret the command
          local cmd = string.format(
            "tmux display-popup -w 80%% -h 80%% -d %s -E \"bash -c 'cd %s && hunk diff -- %s'\"",
            escaped_cwd,
            escaped_cwd,
            escaped_file
          )
          os.execute(cmd)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hB', gitsigns.toggle_current_line_blame, { desc = 'toggle git [B]lame line' })
        map('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)' })
        map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (all files in repo)' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        map('n', '<leader>hF', hunk_diff_file_floating, { desc = 'hunk [F]ile diff (floating tmux)' })

        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },
}
