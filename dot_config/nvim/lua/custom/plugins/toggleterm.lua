return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- size can be a number or function which is passed the current terminal
      size = 20,
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
      direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
      float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
      }
    })

    -- Add a custom keymap to escape terminal mode easily inside the toggleterm
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- This allows you to double tap escape to exit terminal mode and look around the buffer
      vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], opts)
      -- Optional: navigate between splits if you have multiple things open
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    -- Set up mappings for floating and vertical terminals
    vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = '[T]oggle [F]loating terminal' })
    vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=40<CR>', { desc = '[T]oggle [V]ertical terminal' })
    vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm direction=tab<CR>', { desc = '[T]oggle [T]ab terminal' })
  end
}
