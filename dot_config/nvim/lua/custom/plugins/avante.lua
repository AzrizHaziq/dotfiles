return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, 
    opts = {
      provider = "copilot", -- Tell Avante to use GitHub Copilot
      auto_suggestions_provider = "copilot",
    },
    build = "make", -- Note: Requires `make` and `cargo` (Rust) on your machine. 
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "MeanderingProgrammer/render-markdown.nvim",
      
      -- 1. Snacks.nvim for the awesome input provider
      {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
          input = { enabled = true },
        },
      },
      
      -- 2. Copilot.lua to handle the browser login (:Copilot auth)
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({})
        end,
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
    end,
  }
}
