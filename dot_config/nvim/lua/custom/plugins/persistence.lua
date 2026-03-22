return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore [Q]uit [S]ession (dir)" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore [Q]uit [L]ast session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "[Q]uit Session (Don't save current)" },
  },
}