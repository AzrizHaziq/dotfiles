return {
  {
    'aserowy/tmux.nvim',
    config = function()
      require('tmux').setup {
        navigation = {
          -- cycles to opposite pane while navigating into the border
          cycle_navigation = false,

          -- enables default keybindings (C-hjkl) for normal mode
          enable_default_keybindings = true,

          -- prevents unzoom tmux when navigating beyond vim border
          persist_zoom = false,
        },
      }
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
