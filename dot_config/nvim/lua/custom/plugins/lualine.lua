return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local catppuccin = require 'catppuccin'
    local devicons = require 'nvim-web-devicons'
    local C = require('catppuccin.palettes').get_palette 'mocha'
    local opts = catppuccin.options
    local transparent_bg = opts.transparent_background and 'NONE' or C.mantle
    local pill_bg = opts.transparent_background and 'NONE' or C.surface0

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

    local function filename_for(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == '' then
        return '[No Name]'
      end
      return vim.fn.fnamemodify(name, ':t')
    end

    local function file_label()
      local bufnr = target_bufnr()
      local label = filename_for(bufnr)
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

      return label .. ' ' .. table.concat(marks, ' ')
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
        lualine_c = {}, -- Removed filename from bottom
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        -- Since globalstatus is true, this section is largely ignored by lualine,
        -- but good to keep clean
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
              return file_icon()
            end,
            color = function()
              local _, color = file_icon()
              return { fg = color, bg = pill_bg, gui = 'bold' }
            end,
            separator = { left = '', right = '' },
            padding = { left = 1, right = 0 },
          },
          {
            file_label,
            color = { fg = C.lavender, bg = pill_bg, gui = 'bold' },
            separator = { left = '', right = '' },
            padding = { left = 1, right = 1 },
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
              return file_icon()
            end,
            color = function()
              local _, color = file_icon()
              return { fg = color, bg = pill_bg }
            end,
            separator = { left = '', right = '' },
            padding = { left = 1, right = 0 },
          },
          {
            file_label,
            color = { fg = C.subtext0, bg = pill_bg },
            separator = { left = '', right = '' },
            padding = { left = 1, right = 1 },
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
}
