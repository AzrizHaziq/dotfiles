return {
  {
    'sudo-tee/opencode.nvim',
    event = 'VeryLazy',
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
          enable_treesitter_markdown = true,
          position = 'right',
          input_position = 'bottom',
          window_width = 0.40,
          display_model = true,
          display_context_size = true,
          display_cost = true,
          persist_state = true,
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

            ['<leader>ol'] = { 'quick_chat', mode = { 'n', 'x' } }, -- quick chat with current line or visual selection as context
            ['<leader>oa'] = { 'agent', { 'select' } }, -- picker to select agent (build/plan/custom)
            ['<leader>os'] = false, -- disabled (was: select session)
            ['<leader>op'] = false, -- disabled (was: configure provider/model)
            ['<leader>o/'] = false, -- disabled (moved to <leader>ol)
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
        completion = {
          file_sources = {
            enabled = true,
            preferred_cli_tool = 'server', -- 'fd','fdfind','rg','git','server' if nil, it will use the best available tool, 'server' uses opencode cli to get file list (works cross platform) and supports folders
            ignore_patterns = {
              '^%.git/',
              '^%.svn/',
              '^%.hg/',
              'node_modules/',
              '%.pyc$',
              '%.o$',
              '%.obj$',
              '%.exe$',
              '%.dll$',
              '%.so$',
              '%.dylib$',
              '%.class$',
              '%.jar$',
              '%.war$',
              '%.ear$',
              'target/',
              'build/',
              'dist/',
              'out/',
              'deps/',
              '%.tmp$',
              '%.temp$',
              '%.log$',
              '%.cache$',
            },
            max_files = 10,
            max_display_length = 50, -- Maximum length for file path display in completion, truncates from left with "..."
          },
        },
        context = {
          enabled = true, -- Enable automatic context capturing
          cursor_data = {
            enabled = false, -- Include cursor position and line content in the context
            context_lines = 5, -- Number of lines before and after cursor to include in context
          },
          diagnostics = {
            info = false, -- Include diagnostics info in the context (default to false
            warning = true, -- Include diagnostics warnings in the context
            error = true, -- Include diagnostics errors in the context
            only_closest = false, -- If true, only diagnostics for cursor/selection
          },
          current_file = {
            enabled = true, -- Include current file path and content in the context
            show_full_path = true,
          },
          files = {
            enabled = true,
            show_full_path = true,
          },
          selection = {
            enabled = true, -- Include selected text in the context
          },
          buffer = {
            enabled = false, -- Disable entire buffer context by default, only used in quick chat
          },
          git_diff = {
            enabled = false,
          },
        },
      }
    end,
  },
}
