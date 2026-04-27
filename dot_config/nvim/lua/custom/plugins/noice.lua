return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>nh', function() require('noice').cmd('history') end,  desc = 'Noice History' },
    { '<leader>nl', function() require('noice').cmd('last') end,     desc = 'Noice Last Message' },
    { '<leader>nd', function() require('noice').cmd('dismiss') end,  desc = 'Noice Dismiss All' },
    {
      '<c-f>',
      function()
        if not require('noice.lsp').scroll(4) then return '<c-f>' end
      end,
      silent = true,
      expr = true,
      mode = { 'n', 'i', 's' },
      desc = 'Scroll LSP Docs Down',
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      opts = {
        background_colour = '#000000',
      },
    },
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      bottom_search = false,        -- disabled so search also uses the centered view
      command_palette = false,      -- we define the layout manually below
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    -- Centered cmdline input box
    cmdline = {
      view = 'cmdline_popup',
      format = {
        cmdline     = { icon = '>' },
        search_down = { icon = ' ' },
        search_up   = { icon = ' ' },
        filter      = { icon = '$' },
        lua         = { icon = '' },
        help        = { icon = '?' },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = '40%',  -- vertically centered (slightly above true center looks better)
          col = '50%',
        },
        size = {
          width  = 60,
          height = 'auto',
        },
        border = {
          style   = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
      -- Completion popupmenu anchored just below the cmdline popup
      popupmenu = {
        relative = 'editor',
        position = {
          row = '60%',
          col = '50%',
        },
        size = {
          width  = 60,
          height = 10,
        },
        border = {
          style   = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
    },
  },
}
