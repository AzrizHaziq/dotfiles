return {
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
    config = function()
      local function tmux_bin()
        local tmux = vim.env.TMUX or ''
        local server_pid = tmux:match '^[^,]+,(%d+),'
        if not server_pid then
          return 'tmux'
        end

        local server_exe = vim.uv.fs_readlink('/proc/' .. server_pid .. '/exe')
        if server_exe and server_exe ~= '' then
          return server_exe
        end

        return 'tmux'
      end

      local function select_tmux_pane(direction_flag)
        if not vim.env.TMUX or vim.env.TMUX == '' or not vim.env.TMUX_PANE or vim.env.TMUX_PANE == '' then
          return
        end

        local args = { tmux_bin(), 'select-pane', '-t', vim.env.TMUX_PANE, direction_flag }
        if vim.g.tmux_navigator_preserve_zoom == 1 then
          table.insert(args, '-Z')
        end

        local result = vim.system(args, { text = true }):wait()
        if result.code ~= 0 then
          local msg = result.stderr ~= '' and result.stderr or 'tmux select-pane failed'
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end

      local function navigate(direction, tmux_flag)
        local current_win = vim.api.nvim_get_current_win()
        vim.cmd('wincmd ' .. direction)

        if vim.api.nvim_get_current_win() ~= current_win then
          return
        end

        select_tmux_pane(tmux_flag)
      end

      local function navigate_from_terminal(direction, tmux_flag)
        local esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'n', false)
        vim.schedule(function()
          navigate(direction, tmux_flag)
        end)
      end

      vim.keymap.set('n', '<C-h>', function()
        navigate('h', '-L')
      end, { desc = 'Move left across nvim and tmux' })
      vim.keymap.set('n', '<C-j>', function()
        navigate('j', '-D')
      end, { desc = 'Move down across nvim and tmux' })
      vim.keymap.set('n', '<C-k>', function()
        navigate('k', '-U')
      end, { desc = 'Move up across nvim and tmux' })
      vim.keymap.set('n', '<C-l>', function()
        navigate('l', '-R')
      end, { desc = 'Move right across nvim and tmux' })

      vim.keymap.set('t', '<C-h>', function()
        navigate_from_terminal('h', '-L')
      end, { desc = 'Move left across nvim and tmux' })
      vim.keymap.set('t', '<C-j>', function()
        navigate_from_terminal('j', '-D')
      end, { desc = 'Move down across nvim and tmux' })
      vim.keymap.set('t', '<C-k>', function()
        navigate_from_terminal('k', '-U')
      end, { desc = 'Move up across nvim and tmux' })
      vim.keymap.set('t', '<C-l>', function()
        navigate_from_terminal('l', '-R')
      end, { desc = 'Move right across nvim and tmux' })

      local function run_tmux(args)
        if not vim.env.TMUX or vim.env.TMUX == '' then
          vim.notify('tmux is not running', vim.log.levels.WARN)
          return
        end

        local result = vim.system(vim.list_extend({ tmux_bin() }, args), { text = true }):wait()
        if result.code ~= 0 then
          local msg = result.stderr ~= '' and result.stderr or 'tmux command failed'
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end

      vim.keymap.set('n', '<leader>tf', function()
        run_tmux { 'display-popup', '-E', '-d', vim.fn.getcwd() }
      end, { desc = '[T]erminal [F]loat popup' })

      -- vim.keymap.set('n', '<leader>tv', function()
      --   run_tmux { 'split-window', '-h', '-c', vim.fn.getcwd() }
      -- end, { desc = '[T]erminal [V]ertical tmux pane' })
    end,
  },
}

-- Tmux cheat sheet
--
-- General
--   leader ?        list keys
--   leader :        command prompt
--   leader d        detach session
--   leader r        reload config
--
-- Sessions
--   leader $        rename session
--   leader s        list sessions
--
-- Windows
--   leader c        new window
--   leader ,        rename window
--   leader &        kill window
--   leader w        list windows
--   leader n        next window
--   leader p        previous window
--   leader 0..9     window by index
--   leader l        last window
--
-- Panes
--   leader %        split vertical
--   leader "        split horizontal
--   leader x        kill pane
--   leader z        zoom pane
--   leader !        pane to window
--   leader ;        last pane
--   leader q        pane numbers
--   leader o        next pane
--   leader {        swap pane left
--   leader }        swap pane right
--   leader Space    next layout
--   leader M-1      even-horizontal
--   leader M-2      even-vertical
--   leader M-3      main-horizontal
--   leader M-4      main-vertical
--   leader M-5      tiled
--   leader Arrow    select pane
--   leader C-Arrow  resize pane
--
-- Copy mode
--   leader [        enter copy mode
--   leader ]        paste buffer
--
-- Buffers
--   leader #        list buffers
--   leader =        choose buffer
--   leader -        delete buffer
--
-- Client
--   leader t        clock
--   leader i        pane info
--   leader ~        messages
