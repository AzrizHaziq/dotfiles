return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*', -- Latest stable release
    keys = {
      -- stylua: ignore start
      { '<leader>oo', function() require('opencode').ask '@this: ' end, mode = { 'n', 'x' }, desc = 'Ask OpenCode…' },
      { '<leader>oh', function() require('opencode').select() end, mode = { 'n', 'x' }, desc = 'Select OpenCode…' },
      { '<leader>oll', function() return require('opencode').operator '@this ' .. '_' end, mode = 'n', expr = true, desc = 'Append line to OpenCode' },
      { '<leader>ol', function() return require('opencode').operator '@this ' end, mode = { 'n', 'x' }, expr = true, desc = 'Append range to OpenCode' },
      { '<leader>ou', function() require('opencode').command 'session.half.page.up' end, mode = 'n', desc = 'Scroll OpenCode up' },
      { '<leader>od', function() require('opencode').command 'session.half.page.down' end, mode = 'n', desc = 'Scroll OpenCode down' },
      -- stylua: ignore end
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type for details
      }
    end,
  },
}
