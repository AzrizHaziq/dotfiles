return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', desc = '[T]oggle [M]arkdown Preview' },
    },
  },
}
