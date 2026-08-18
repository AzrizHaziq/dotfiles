return {

  {
    'algmyr/vcsigns.nvim',
    dependencies = {
      'algmyr/vclib.nvim',
      'lewis6991/async.nvim',
    },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('vcsigns').setup {
        -- target_commit = 1, -- Nice default for jj with new+squash flow.
      }

      local function map(mode, lhs, rhs, desc, opts)
        local options = { noremap = true, silent = true, desc = desc }
        if opts then
          options = vim.tbl_extend('force', options, opts)
        end
        vim.keymap.set(mode, lhs, rhs, options)
      end

      -- stylua: ignore start
      map('n', '[r', function() require('vcsigns.actions').target_older_commit(0, vim.v.count1) end, 'Move diff target back')
      map('n', ']r', function() require('vcsigns.actions').target_newer_commit(0, vim.v.count1) end, 'Move diff target forward')
      map('n', '[c', function() require('vcsigns.actions').hunk_prev(0, vim.v.count1) end, 'Go to previous hunk')
      map('n', ']c', function() require('vcsigns.actions').hunk_next(0, vim.v.count1) end, 'Go to next hunk')
      map('n', '[C', function() require('vcsigns.actions').hunk_prev(0, 9999) end, 'Go to first hunk')
      map('n', ']C', function() require('vcsigns.actions').hunk_next(0, 9999) end, 'Go to last hunk')
      map('n', '<leader>hu', function() require('vcsigns.actions').hunk_undo(0) end, 'Undo hunks under cursor')
      map('v', '<leader>hu', function() require('vcsigns.actions').hunk_undo(0) end, 'Undo hunks in range')
      map('n', '<leader>hd', function() require('vcsigns.actions').toggle_hunk_diff(0) end, 'Show hunk diffs inline in the current buffer')
      map('n', '<leader>hv', function() require('vcsigns.actions').diffview(0) end, 'Open native side-by-side diff view')
      map('n', '<leader>hf', function() require('vcsigns.actions').toggle_fold(0) end, 'Fold outside hunks')
      -- stylua: ignore end
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    enabled = false,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
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
        map('n', '<leader>hQ', function()
          gitsigns.setqflist 'all'
        end, { desc = 'git hunk [Q]uickfix list (all files in repo)' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })

        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },
}
