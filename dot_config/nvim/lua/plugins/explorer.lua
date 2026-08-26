return {
  {
    'nvim-mini/mini.files',
    version = false,
    keys = {
      -- stylua: ignore start
      { '\\', function() require('mini.files').open() end, desc = 'mini files', },
      { '<leader>er', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = '[E]xplorer [R]eveal current file', },
      -- { '\\', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = '[e]xplorer [r]eavel', },
      -- stylua: ignore end
    },
    config = function()
      require('mini.files').setup {
        windows = {
          preview = true,
          width_focus = 40,
          width_nofocus = 20,
          width_preview = 50,
        },
        options = {
          permanent_delete = false, -- use trash instead
          use_as_default_explorer = false,
        },
      }

      -- Custom actions via autocmd
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf = args.data.buf_id
          local map = function(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
          end

          -- Close on Esc
          map('<Esc>', function()
            require('mini.files').close()
          end, 'Close mini.files')

          -- Copy relative path
          map('<leader>cr', function()
            local entry = require('mini.files').get_fs_entry()
            if not entry then
              return
            end

            local rel = vim.fn.fnamemodify(entry.path, ':.')
            vim.fn.setreg('+', rel)
            vim.notify('Copied: ' .. rel, vim.log.levels.INFO)
          end, 'Copy relative path')

          -- Copy absolute path
          map('<leader>ca', function()
            local entry = require('mini.files').get_fs_entry()
            if not entry then
              return
            end

            vim.fn.setreg('+', entry.path)
            vim.notify('Copied: ' .. entry.path, vim.log.levels.INFO)
          end, 'Copy absolute path')

          -- Open in vertical split
          map('<C-v>', function()
            local entry = require('mini.files').get_fs_entry()
            if not entry or entry.fs_type ~= 'file' then
              return
            end
            require('mini.files').close()
            vim.cmd('vsplit ' .. vim.fn.fnameescape(entry.path))
          end, 'Open in vertical split')
        end,
      })
    end,
  },
}
