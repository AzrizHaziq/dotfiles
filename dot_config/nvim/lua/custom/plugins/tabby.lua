return {
  'nanozuki/tabby.nvim',
  event = 'VimEnter',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- Always show the tabline
    vim.o.showtabline = 2

    -- Ensure persistence.nvim saves tabpages and globals (for custom tab names)
    vim.opt.sessionoptions:append('tabpages')
    vim.opt.sessionoptions:append('globals')

    local theme = {
      fill = 'TabLineFill',       -- tabline background
      head = 'TabLine',           -- head element highlight
      current_tab = 'TabLineSel', -- current tab label highlight
      tab = 'TabLine',            -- other tab label highlight
      win = 'TabLine',            -- inactive window highlight
      current_win = 'TabLineSel', -- active window highlight (makes it visible)
      tail = 'TabLine',           -- tail element highlight
    }

    require('tabby').setup({
      line = function(line)
        return {
          {
            { '  ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep('', hl, theme.fill),
              tab.is_current() and ' ' or '󰆣 ',
              tab.number(),
              tab.name(),
              tab.close_btn(' '),
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).filter(function(win)
            local bufid = vim.api.nvim_win_get_buf(win.id)
            local ft = vim.bo[bufid].filetype
            -- Filter out Avante windows completely
            if ft:match("^Avante") then return false end
            -- Filter out unnamed diff windows
            if vim.wo[win.id].diff and vim.api.nvim_buf_get_name(bufid) == "" then return false end
            return true
          end).foreach(function(win)
            -- Make the active window highly visible by using `current_win` highlight
            local hl = win.is_current() and theme.current_win or theme.win
            return {
              line.sep('', hl, theme.fill),
              win.is_current() and ' ' or ' ',
              win.buf_name(),
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
      option = {
        theme = theme,
        nerdfont = true,
        lualine_theme = nil,
        tab_name = {
          name_fallback = function(tabid)
            return tabid
          end,
        },
        buf_name = {
          mode = 'unique',
        },
      },
    })

    -- Some useful mappings for tabs
    vim.keymap.set('n', '<leader>ta', ':$tabnew<CR>', { desc = '[T]ab [A]dd new' })
    vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = '[T]ab [C]lose current' })
    vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = '[T]ab [O]nly (close others)' })
    vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { desc = '[T]ab [N]ext' })
    vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { desc = '[T]ab [P]revious' })
    vim.keymap.set('n', '<leader>tr', ':Tabby rename_tab ', { desc = '[T]ab [R]ename' })
  end,
}
