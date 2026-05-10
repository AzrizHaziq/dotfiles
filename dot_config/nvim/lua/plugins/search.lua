return {
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
    opts = {
      base_path = vim.fn.getcwd(),
      prompt = '> ',
      title = 'FFF Files',
      max_results = 100,
      max_threads = 4,
      lazy_sync = true,
      prompt_vim_mode = false,
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = 'top',
        preview_position = 'right',
        preview_size = 0.5,
        flex = { size = 130, wrap = 'top' },
        show_scrollbar = true,
        path_shorten_strategy = 'middle_number',
        anchor = 'center',
      },
      preview = {
        enabled = true,
        max_size = 10 * 1024 * 1024,
        chunk_size = 8192,
        binary_file_threshold = 1024,
        line_numbers = false,
        cursorlineopt = 'both',
        wrap_lines = false,
        filetypes = {
          svg = { wrap_lines = true },
          markdown = { wrap_lines = true },
          text = { wrap_lines = true },
        },
      },
      keymaps = {
        close = '<Esc>',
        select = '<CR>',
        select_split = '<C-h>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        move_up = { '<Up>', '<C-p>' },
        move_down = { '<Down>', '<C-n>' },
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
        toggle_debug = '<F2>',
        cycle_grep_modes = '<S-Tab>',
        cycle_previous_query = '<C-Up>',
        toggle_select = '<Tab>',
        send_to_quickfix = '<C-q>',
        focus_list = '<leader>l',
        focus_preview = '<leader>p',
      },
      frecency = {
        enabled = true,
        db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
      },
      history = {
        enabled = true,
        db_path = vim.fn.stdpath('data') .. '/fff_queries',
        min_combo_count = 3,
        combo_boost_score_multiplier = 100,
      },
      git = {
        status_text_color = true,
      },
      grep = {
        max_file_size = 10 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        time_budget_ms = 150,
        modes = { 'plain', 'regex', 'fuzzy' },
        trim_whitespace = false,
      },
      debug = {
        enabled = false,
        show_scores = false,
      },
      logging = {
        enabled = true,
        log_file = vim.fn.stdpath('log') .. '/fff.log',
        log_level = 'info',
      },
    },
    lazy = false,
    keys = {
      {
        '<leader>sf',
        function()
          local cwd = vim.fn.getcwd()
          require('fff').find_files {
            base_path = cwd,
            title = 'Find Files in ' .. vim.fn.fnamemodify(cwd, ':~'),
          }
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        function()
          local cwd = vim.fn.getcwd()
          require('fff').live_grep {
            base_path = cwd,
            title = 'Live Grep in ' .. vim.fn.fnamemodify(cwd, ':~'),
          }
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sn',
        function()
          require('fff').find_files {
            base_path = vim.fn.stdpath 'config',
            title = 'Neovim Config Files',
          }
        end,
        desc = '[S]earch [N]eovim files',
      },
      {
        '<leader>sw',
        function()
          require('fff').live_grep {
            query = vim.fn.expand '<cword>',
          }
        end,
        mode = { 'n', 'x' },
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>so',
        function()
          local buffers = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              local bufname = vim.api.nvim_buf_get_name(buf)
              if bufname ~= '' and vim.fn.filereadable(bufname) == 1 then
                table.insert(buffers, bufname)
              end
            end
          end

          if #buffers == 0 then
            vim.notify('No open file buffers', vim.log.levels.WARN)
            return
          end

          require('fff').live_grep {
            title = 'Grep Open Buffers',
          }
        end,
        desc = '[S]earch [O]pen buffers',
      },
    },
  },
}
