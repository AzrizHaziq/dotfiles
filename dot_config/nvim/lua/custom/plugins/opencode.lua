return {
  {
    'sudo-tee/opencode.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'markdown', 'opencode_output' },
        },
        ft = { 'markdown', 'copilot-chat', 'opencode_output' },
      },
      -- completion
      'saghen/blink.cmp',
      -- file picker
      'folke/snacks.nvim',
    },
    config = function()
      require('opencode').setup {
        keymap_prefix = '<leader>o',
        preferred_picker = 'snacks',
        default_global_keymaps = true,
        default_mode = 'build',
        ui = {
          position = 'right',
          input_position = 'bottom',
          window_width = 0.40,
          icons = {
            preset = 'nerdfonts',
          },
        },

        keymap = {
          editor = {
            -- <leader>og  toggle open/close
            -- <leader>oi  open input window (current session)
            -- <leader>oI  open input window (new session)
            -- <leader>oo  open output window
            -- <leader>ot  toggle focus between opencode and last window
            -- <leader>oT  timeline picker (navigate/undo/redo/fork messages)
            -- <leader>oq  close UI windows
            -- <leader>oR  rename current session
            -- <leader>oV  configure model variant
            -- <leader>oy  add visual selection to context (visual mode)
            -- <leader>oY  insert visual selection inline into input (visual mode)
            -- <leader>oz  zoom in/out on opencode windows
            -- <leader>ov  paste image from clipboard
            -- <leader>od  open diff view of changed files
            -- <leader>o]  navigate to next file diff
            -- <leader>o[  navigate to previous file diff
            -- <leader>oc  close diff view tab
            -- <leader>ora revert all file changes since last prompt
            -- <leader>ort revert current file changes since last prompt
            -- <leader>orA revert all file changes since last session
            -- <leader>orT revert current file changes since last session
            -- <leader>orr restore a file to a restore point
            -- <leader>orR restore all files to a restore point
            -- <leader>ox  swap opencode pane left/right
            -- <leader>ott toggle tools output (diffs, cmd output, etc.)
            -- <leader>otr toggle reasoning output (thinking steps)
            -- <leader>oa  select agent (build/plan/custom) [global]

            ['<leader>ol'] = { 'quick_chat', mode = { 'n', 'x' } },       -- quick chat with current line or visual selection as context
            ['<leader>oa'] = { 'agent', { 'select' } },                   -- picker to select agent (build/plan/custom)
            ['<leader>os'] = false,  -- disabled (was: select session)
            ['<leader>op'] = false,  -- disabled (was: configure provider/model)
            ['<leader>o/'] = false,  -- disabled (moved to <leader>ol)
          },
          input_window = {
            -- <S-CR>      submit prompt
            -- <C-c>       cancel running request
            -- ~           pick a file and add to context
            -- @           insert mention (file/agent)
            -- /           slash commands
            -- #           manage context items
            -- <M-v>       paste image from clipboard
            -- <tab>       toggle between input and output panes
            -- <up>        previous prompt in history
            -- <down>      next prompt in history
            -- <M-m>       switch mode (build/plan)
            -- <M-r>       cycle model variants

            ['<esc>'] = false, -- disabled (use <leader>og to close)
          },
          output_window = {
            -- ]]          next message in conversation
            -- [[          previous message in conversation
            -- <tab>       toggle between input and output panes
            -- i           focus input window (insert mode)
            -- <C-c>       cancel running request
            -- <M-r>       cycle model variants
            -- <leader>oS  select child session
            -- <leader>oD  debug message
            -- <leader>oO  debug output
            -- <leader>ods debug session

            ['<esc>'] = false, -- disabled (use <leader>og to close)
          },
        },
      }
    end,
  },
}
