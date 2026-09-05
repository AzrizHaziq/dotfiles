return {
  {
    'nvim-mini/mini.files',
    version = false,
    keys = {
      -- stylua: ignore start
      { '\\', function() require('mini.files').open() end, desc = 'mini files', },
      { '<leader>er', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = '[E]xplorer [R]eveal current file', },
      -- stylua: ignore end
    },
    config = function()
      -- Copy path helper
      local copy_path = function(modifier)
        local entry = require('mini.files').get_fs_entry()
        if not entry then
          return
        end
        local path = modifier and vim.fn.fnamemodify(entry.path, modifier) or entry.path
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end

      -- Open in split helper
      local open_in_split = function(cmd)
        local entry = require('mini.files').get_fs_entry()
        if not entry or entry.fs_type ~= 'file' then
          return
        end
        require('mini.files').close()
        vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(entry.path))
      end

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

          -- stylua: ignore start
          map('<Esc>', function() require('mini.files').close() end, 'Close mini.files')
          map('<leader>cr', function() copy_path(':.') end, 'Copy relative path')
          map('<leader>ca', function() copy_path() end, 'Copy absolute path')
          map('<C-v>', function() open_in_split 'vsplit' end, 'Open in vertical split')
          map('<C-s>', function() open_in_split 'split' end, 'Open in horizontal split')
          -- stylua: ignore end
        end,
      })
    end,
  },
}
