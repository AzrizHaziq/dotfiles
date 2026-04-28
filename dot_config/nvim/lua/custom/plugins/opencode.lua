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
        preferred_completion = 'blink',
        default_global_keymaps = true,
        default_mode = 'plan',
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
          output = {
            filetype = 'opencode_output'
          }
        },

        keymap = {
          editor = {
            ['<leader>og'] = { 'toggle' }, -- Open opencode. Close if opened
            ['<leader>oi'] = { 'open_input' }, -- Opens and focuses on input window on insert mode
            ['<leader>oI'] = { 'open_input_new_session' }, -- Opens and focuses on input window on insert mode. Creates a new session
            ['<leader>oo'] = { 'open_output' }, -- Opens and focuses on output window
            ['<leader>ot'] = { 'toggle_focus' }, -- Toggle focus between opencode and last window
            ['<leader>oT'] = { 'timeline' }, -- Display timeline picker to navigate/undo/redo/fork messages
            ['<leader>oq'] = { 'close' }, -- Close UI windows
            ['<leader>os'] = { 'select_session' }, -- Select and load a opencode session
            ['<leader>oR'] = { 'rename_session' }, -- Rename current session
            ['<leader>om'] = { 'configure_provider' }, -- Quick provider and model switch from predefined list
            ['<leader>oV'] = { 'configure_variant' }, -- Switch model variant for the current model
            ['<leader>oy'] = { 'add_visual_selection', mode = {'v'} },
            ['<leader>oY'] = { 'add_visual_selection_inline', mode = {'v'} }, -- Insert visual selection as inline code block in the input buffer
            ['<leader>oz'] = { 'toggle_zoom' }, -- Zoom in/out on the Opencode windows
            ['<leader>ov'] = { 'paste_image'}, -- Paste image from clipboard into current session
            ['<leader>od'] = { 'diff_open' }, -- Opens a diff tab of a modified file since the last opencode prompt
            ['<leader>o]'] = { 'diff_next' }, -- Navigate to next file diff
            ['<leader>o['] = { 'diff_prev' }, -- Navigate to previous file diff
            ['<leader>oc'] = { 'diff_close' }, -- Close diff view tab and return to normal editing
            ['<leader>ora'] = { 'diff_revert_all_last_prompt' }, -- Revert all file changes since the last opencode prompt
            ['<leader>ort'] = { 'diff_revert_this_last_prompt' }, -- Revert current file changes since the last opencode prompt
            ['<leader>orA'] = { 'diff_revert_all' }, -- Revert all file changes since the last opencode session
            ['<leader>orT'] = { 'diff_revert_this' }, -- Revert current file changes since the last opencode session
            ['<leader>orr'] = { 'diff_restore_snapshot_file' }, -- Restore a file to a restore point
            ['<leader>orR'] = { 'diff_restore_snapshot_all' }, -- Restore all files to a restore point
            ['<leader>ox'] = { 'swap_position' }, -- Swap Opencode pane left/right
            ['<leader>ott'] = { 'toggle_tool_output' }, -- Toggle tools output (diffs, cmd output, etc.)
            ['<leader>otr'] = { 'toggle_reasoning_output' }, -- Toggle reasoning output (thinking steps) ['<leader>o/'] = { 'quick_chat', mode = { 'n', 'x' } }, -- Open quick chat input with selection context in visual mode or current line context in normal mode
            ['<leader>ol'] = { 'quick_chat', mode = { 'n', 'x' } }, -- quick chat with current line or visual selection as context
            ['<leader>oa'] = { 'agent', { 'select' } }, -- picker to select agent (build/plan/custom)
            ['<leader>os'] = false, -- disabled (was: select session)
            ['<leader>op'] = false, -- disabled (was: configure provider/model)
            ['<leader>o/'] = false, -- disabled (moved to <leader>ol)
          },
          input_window = {
            -- ['<S-cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } }, -- Submit prompt (normal mode and insert mode)
            -- ['<C-c>'] = { 'cancel', defer_to_completion = true }, -- Cancel opencode request while it is running
            -- ['~'] = { 'mention_file', mode = 'i' }, -- Pick a file and add to context. See File Mentions section
            -- ['@'] = { 'mention', mode = 'i' }, -- Insert mention (file/agent)
            -- ['/'] = { 'slash_commands', mode = 'i' }, -- Pick a command to run in the input window
            -- ['#'] = { 'context_items', mode = 'i' }, -- Manage context items (current file, selection, diagnostics, mentioned files)
            ['<M-v>'] = { 'paste_image', mode = 'i' }, -- Paste image from clipboard as attachment
            -- ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' }, defer_to_completion = true }, -- Toggle between input and output panes
            -- ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' }, defer_to_completion = true }, -- Navigate to previous prompt in history
            -- ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' }, defer_to_completion = true }, -- Navigate to next prompt in history
            ['<M-m>'] = { 'switch_mode' }, -- Switch between modes (build/plan)
            ['<M-r>'] = { 'cycle_variant', mode = { 'n', 'i' } }, -- Cycle through available model variants
            ['<esc>'] = false, -- disabled (use <leader>og to close)
          },
          output_window = {
            -- ['<C-c>'] = { 'cancel' }, -- Cancel opencode request while it is running
            -- [']]'] = { 'next_message' }, -- Navigate to next message in the conversation
            -- ['[['] = { 'prev_message' }, -- Navigate to previous message in the conversation
            -- ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } }, -- Toggle between input and output panes
            -- ['i'] = { 'focus_input', 'n' }, -- Focus on input window and enter insert mode at the end of the input from the output window
            ['<M-r>'] = { 'cycle_variant', mode = { 'n' } }, -- Cycle through available model variants
            ['<M-m>'] = { 'switch_mode' }, -- Switch between modes (build/plan)
            -- ['<leader>oS'] = { 'select_child_session' }, -- Select and load a child session
            -- ['<leader>oP'] = { 'select_parent_session' }, -- Go to parent session
            -- ['<leader>oB'] = { 'select_sibling_session' }, -- Select sibling session (children of same parent)
            -- ['<leader>oD'] = { 'debug_message' }, -- Open raw message in new buffer for debugging
            -- ['<leader>oO'] = { 'debug_output' }, -- Open raw output in new buffer for debugging
            -- ['<leader>ods'] = { 'debug_session' }, -- Open raw session in new buffer for debugging

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
