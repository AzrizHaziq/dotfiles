return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'opencode_output' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = { enabled = false },
      anti_conceal = { enabled = false },
      file_types = { 'markdown', 'opencode_output' },
    },
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', desc = '[T]oggle [m]arkdown Preview' },
    },
  },
}
