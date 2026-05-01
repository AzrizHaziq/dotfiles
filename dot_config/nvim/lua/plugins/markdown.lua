return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'opencode_output' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', desc = '[T]oggle [M]arkdown Preview' },
    },
  },
  -- https://github.com/nickjj/dotfiles/blob/master/.config/nvim/lua/plugins/markdown.lua
  -- local data_path = vim.fn.stdpath 'config' .. '/lua/custom/plugins/data'
  -- local markdown_preview_css_path = data_path .. '/github-markdown.css'
  --[[ {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_auto_close = false
      vim.g.mkdp_markdown_css = markdown_preview_css_path
    end,
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreview<cr>', desc = '[M]arkdown [P]review' },
    },
  }, ]]
}
