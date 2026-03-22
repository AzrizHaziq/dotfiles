return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = vim.g.have_nerd_font,
        theme = 'auto', -- 'auto' matches your colorscheme (tokyonight)
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true, -- ENABLE GLOBAL STATUSLINE
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {}, -- Removed filename from bottom
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        -- Since globalstatus is true, this section is largely ignored by lualine,
        -- but good to keep clean
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      -- WINBAR CONFIGURATION (Filename at the top of the split)
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 0, -- 0 = just filename
            symbols = {
              modified = ' ',      -- Nerd font dot for unsaved changes (comfy/modern look)
              readonly = ' ',      -- Lock icon for readonly
              unnamed = '[No Name]',
              newfile = '[New]',
            },
            color = { gui = 'bold' }, -- Make the filename bold
          }
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 0,
            symbols = {
              modified = ' ',
              readonly = ' ',
              unnamed = '[No Name]',
              newfile = '[New]',
            }
          }
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      }
    }
  end,
}
