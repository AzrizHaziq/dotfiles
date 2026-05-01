return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    keys = {
      {
        '<leader>ah',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Add file to harpoon',
      },
      {
        '<leader>aH',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = 'Toggle harpoon menu',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon file 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon file 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon file 3',
      },
      {
        '<leader>4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Harpoon file 4',
      },
      {
        '<leader>5',
        function()
          require('harpoon'):list():select(5)
        end,
        desc = 'Harpoon file 5',
      },
    },
  },
  {
    'aserowy/tmux.nvim',
    event = 'VeryLazy',
    config = function()
      require('tmux').setup {
        navigation = {
          cycle_navigation = false,
          enable_default_keybindings = true,
          persist_zoom = false,
        },
      }
    end,
  },
  {
    'jiaoshijie/undotree',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>tu',
        function()
          require('undotree').toggle()
        end,
        desc = '[T]oggle [U]ndo tree',
      },
    },
    opts = {
      float_diff = true,
      position = 'right',
    },
  },
}
