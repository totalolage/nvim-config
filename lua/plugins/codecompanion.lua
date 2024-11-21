return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = {
    keymaps = {
      send = {
        modes = {
          n = { "<CR>", "<C-s>" },
          i = "<C-s>",
        },
      },
    },

    display = {
      chat = {
        render_headers = false,
      },
    },

    adapters = {
      strategies = {
        chat = {
          adapter = "openai",
        },
        inline = {
          adapter = "openai",
        },
        agent = {
          adapter = "openai",
        },
        cmd = {
          adapter = "openai",
        },
      },

      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = "cmd:security find-generic-password -a openai_api_key -s codecompanion.nvim -w",
          },
        })
      end,
    },
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    {
      "<leader>cc<CR>",
      function()
        require("codecompanion").toggle()
      end,
      desc = "CodeCompanion",
      mode = { "n", "v" },
    },
    {
      "<leader>cci",
      "<cmd>CodeCompanion<CR>",
      desc = "CodeCompanion",
      mode = { "n", "v" },
    },
    {
      "<leader>cch",
      function()
        require("codecompanion").chat()
      end,
      desc = "CodeCompanionChat",
      mode = { "n", "v" },
    },
    {
      "<leader>cca",
      function()
        require("codecompanion").actions()
      end,
      desc = "CodeCompanionActions",
      mode = { "n", "v" },
    },
    {
      "<leader>cce",
      function()
        require("codecompanion").prompt "explain"
      end,
      desc = "Explain",
      mode = { "n", "v" },
    },
  },
}
