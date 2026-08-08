return {
  {
    'nvzone/minty',
    event = 'VeryLazy',
    cmd = { 'Shades', 'Huefy' }, -- Lazy loads the commands
    keys = {
      { '<leader>cs', '<cmd>Shades<cr>', desc = 'Open Minty Shades (Color Palette)' },
      { '<leader>ch', '<cmd>Huefy<cr>', desc = 'Open Minty Huefy (Color Picker)' },
    },
    dependencies = {
      { 'nvzone/volt', lazy = true }, -- Required dependency
    },
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    init = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zf', 'zMzvzz', { desc = 'Focus: Fold everything except current cursor' })

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  ··· %d lines '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'UfoFoldedEllipsis' })
        return newVirtText
      end

      require('ufo').setup {
        fold_virt_text_handler = handler,
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
      }

      vim.opt.fillchars = {
        fold = ' ',
        foldopen = '▾',
        foldsep = ' ',
        foldclose = '▸',
      }
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = ' ',
          Down = ' ',
          Left = ' ',
          Right = ' ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '󱊷 ',
          ScrollWheelDown = '󱕐 ',
          ScrollWheelUp = '󱕑 ',
          NL = '󰌑 ',
          BS = '󰁮',
          Space = '󱁐 ',
          Tab = '󰌒 ',
          F1 = '󱊫',
          F2 = '󱊬',
          F3 = '󱊭',
          F4 = '󱊮',
          F5 = '󱊯',
          F6 = '󱊰',
          F7 = '󱊱',
          F8 = '󱊲',
          F9 = '󱊳',
          F10 = '󱊴',
          F11 = '󱊵',
          F12 = '󱊶',
        },
      },
      spec = {
        { '<leader>e', group = '[E]xplorer' },
        { '<leader>f', group = '[F]ormat' },
        { '<leader>h', group = 'Git [h]unk', mode = { 'n', 'v' } },
        { '<leader>g', group = '[G]it' },
        { '<leader>n', group = '[N]otifications' },
        { '<leader>c', group = '[C]opy abosolute/relative' },
        { '<leader>o', group = '[O]pencode' },
        { '<leader>q', group = 'Dia[Q]nostic' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>r', group = '[R]eload' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]rite buffer' },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local catppuccin = require 'catppuccin'
      local devicons = require 'nvim-web-devicons'
      local C = require('catppuccin.palettes').get_palette 'mocha'
      local opts = catppuccin.options
      local transparent_bg = opts.transparent_background and 'NONE' or C.mantle
      local theme = {
        normal = {
          a = { bg = C.blue, fg = C.mantle, gui = 'bold' },
          b = { bg = C.surface0, fg = C.blue },
          c = { bg = transparent_bg, fg = C.text },
        },
        insert = {
          a = { bg = C.green, fg = C.base, gui = 'bold' },
          b = { bg = C.surface0, fg = C.green },
        },
        terminal = {
          a = { bg = C.green, fg = C.base, gui = 'bold' },
          b = { bg = C.surface0, fg = C.green },
        },
        command = {
          a = { bg = C.peach, fg = C.base, gui = 'bold' },
          b = { bg = C.surface0, fg = C.peach },
        },
        visual = {
          a = { bg = C.mauve, fg = C.base, gui = 'bold' },
          b = { bg = C.surface0, fg = C.mauve },
        },
        replace = {
          a = { bg = C.red, fg = C.base, gui = 'bold' },
          b = { bg = C.surface0, fg = C.red },
        },
        inactive = {
          a = { bg = transparent_bg, fg = C.blue },
          b = { bg = transparent_bg, fg = C.surface1, gui = 'bold' },
          c = { bg = transparent_bg, fg = C.overlay0 },
        },
      }

      local function target_bufnr()
        local winid = vim.g.statusline_winid
        if winid and winid ~= 0 then
          return vim.api.nvim_win_get_buf(winid)
        end
        return vim.api.nvim_get_current_buf()
      end

      local function target_winid()
        local winid = vim.g.statusline_winid
        if winid and winid ~= 0 then
          return winid
        end
        return vim.api.nvim_get_current_win()
      end

      local function is_active_window()
        return target_winid() == vim.api.nvim_get_current_win()
      end

      local function mode_color()
        local mode = vim.api.nvim_get_mode().mode

        if mode:match '^i' then
          return C.green
        elseif mode:match '^[vV]' or mode == '\22' then
          return C.mauve
        elseif mode:match '^R' then
          return C.red
        elseif mode:match '^c' then
          return C.peach
        elseif mode:match '^t' then
          return C.green
        end

        return C.blue
      end

      local function smart_winbar_label(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= '' then
          return vim.fn.fnamemodify(name, ':t')
        end
        local ft = vim.bo[bufnr].filetype
        if ft and ft ~= '' then
          local map = { qf = 'Quickfix', help = 'Help', opencode = 'OpenCode' }
          return map[ft] or ft
        end
        local bt = vim.bo[bufnr].buftype
        if bt and bt ~= '' then
          return bt
        end
        return '[No Name]'
      end

      local function file_label()
        local bufnr = target_bufnr()
        local label = smart_winbar_label(bufnr)
        local marks = {}

        if vim.bo[bufnr].modified then
          table.insert(marks, '')
        end

        if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
          table.insert(marks, '')
        end

        if #marks == 0 then
          return label
        end

        return label .. '  ' .. table.concat(marks, ' ')
      end

      local function file_icon()
        local bufnr = target_bufnr()
        local name = vim.api.nvim_buf_get_name(bufnr)
        local filename = name == '' and 'file' or vim.fn.fnamemodify(name, ':t')
        local extension = vim.fn.fnamemodify(filename, ':e')
        local icon, color = devicons.get_icon_color(filename, extension, { default = true })

        return icon or '', color or C.blue
      end

      require('lualine').setup {
        options = {
          icons_enabled = vim.g.have_nerd_font,
          theme = theme,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'macro',
              fmt = function()
                local reg = vim.fn.reg_recording()
                if reg == '' then
                  return ''
                end
                return ' @' .. reg
              end,
              color = function()
                return { fg = C.blue, gui = 'bold' }
              end,
            },
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        winbar = {
          lualine_a = {
            {
              function()
                return '▍'
              end,
              color = function()
                return { fg = mode_color(), bg = 'NONE' }
              end,
              padding = { left = 0, right = 1 },
            },
            {
              function()
                local icon = file_icon()
                return icon
              end,
              color = function()
                local _, color = file_icon()
                return { fg = color, bg = 'NONE' }
              end,
              padding = { left = 0, right = 1 },
            },
            {
              file_label,
              color = function()
                return {
                  fg = is_active_window() and C.text or C.subtext0,
                  bg = 'NONE',
                  gui = is_active_window() and 'bold' or nil,
                }
              end,
              padding = { left = 0, right = 0 },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {
            {
              function()
                return '▍'
              end,
              color = { fg = C.surface1, bg = 'NONE' },
              padding = { left = 0, right = 1 },
            },
            {
              function()
                local icon = file_icon()
                return icon
              end,
              color = function()
                local _, color = file_icon()
                return { fg = color, bg = 'NONE' }
              end,
              padding = { left = 0, right = 1 },
            },
            {
              file_label,
              color = { fg = C.subtext0, bg = 'NONE' },
              padding = { left = 0, right = 0 },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },

  {
    'sphamba/smear-cursor.nvim',
    event = 'BufReadPre',
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      smear_insert_mode = true,
    },
  },
}
