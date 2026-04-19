return {
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
