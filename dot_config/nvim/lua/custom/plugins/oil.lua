-- Declare a global function to show CWD and current browsing directory
function _G.get_oil_winbar()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
  return string.format('CWD: %s', cwd)
end

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    lazy = false, -- recommended: don't lazy load
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      -- use oil as the default file explorer (replaces netrw)
      default_file_explorer = true,

      -- columns shown in the oil buffer
      columns = {
        'icon',
        -- 'permissions',
        'size',
        -- 'mtime',
      },

      -- need at least 2 sign columns for oil-git-status (index + working tree)
      win_options = {
        signcolumn = 'yes:2',
        winbar = '%!v:lua.get_oil_winbar()',
      },

      -- show hidden files (toggle with g. inside oil)
      view_options = {
        show_hidden = true,
      },

      -- send deleted files to trash instead of permanent delete
      delete_to_trash = false,

      -- float window config (used with toggle_float)
      float = {
        padding = 2,
        max_width = 0.8,
        max_height = 0.8,
        border = 'rounded',
      },

      -- Oil keymaps - enabled for CWD management and file operations
      -- See :help oil-actions for the full list of available actions
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' }, -- show this help
        ['<CR>'] = 'actions.select', -- open file / enter dir
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } }, -- open in vsplit
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } }, -- open in hsplit
        ['<C-t>'] = { 'actions.select', opts = { tab = true } }, -- open in new tab
        ['<C-p>'] = 'actions.preview', -- preview file
        ['<C-c>'] = { 'actions.close', mode = 'n' }, -- close oil
        ['<C-l>'] = 'actions.refresh', -- refresh listing
        ['-'] = { 'actions.parent', mode = 'n' }, -- go up one directory
        ['_'] = { 'actions.open_cwd', mode = 'n' }, -- open vim cwd in oil
        ['`'] = { 'actions.cd', mode = 'n' }, -- :cd to this dir (global)
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' }, -- :tcd to this dir (tab only)
        ['gs'] = { 'actions.change_sort', mode = 'n' }, -- cycle sort order
        ['gx'] = 'actions.open_external', -- open with system app
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' }, -- toggle dotfiles
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' }, -- toggle trash view

        -- Copy absolute path with line:column
        ['<leader>ca'] = {
          callback = function()
            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if entry and dir then
              local full_path = dir .. entry.name
              local full = string.format('%s', full_path)
              vim.fn.setreg('+', full)
            end
          end,
          desc = 'Copy absolute path with line:col',
          mode = 'n',
        },

        -- Copy relative path with line:column
        ['<leader>cr'] = {
          callback = function()
            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if entry and dir then
              local full_path = dir .. entry.name
              local relative = vim.fn.fnamemodify(full_path, ':.')
              local full = string.format('%s', relative)
              vim.fn.setreg('+', full)
            end
          end,
          desc = 'Copy relative path with line:col',
          mode = 'n',
        },
      },
    },
    keys = {
      -- \: toggle the oil float window (open if closed, close if open)
      {
        '\\',
        function()
          require('oil').toggle_float()
        end,
        desc = 'Toggle Oil float window',
      },
      -- Note: '-' is intentionally NOT mapped globally.
      -- Inside the oil buffer, '-' still works as "go to parent dir" via the
      -- default internal keymaps above (actions.parent).
    },
  },

  -- git status signs in the signcolumn (index left, working tree right)
  -- must be loaded after oil.nvim
  {
    'refractalize/oil-git-status.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    config = true,
  },
}
