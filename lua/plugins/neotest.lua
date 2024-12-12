return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
  },
  opts = function()
    return {
      adapters = {
        require "neotest-jest" {
          jestCommand = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand "%:p:h") .. " --watch",
          --     jestConfigFile = function(file)
          --       if string.find(file, "/libs/") then
          --         return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
          --       end
          --
          --       return vim.fn.getcwd() .. "/jest.config.ts"
          --     end,
        },
      },
    }
  end,
  cmd = "Neotest",
  keys = {
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last",
    },

    {
      "<leader>to",
      function()
        require("neotest").output.open()
      end,
      desc = "Show Output",
    },

    {
      "<leader>tO",
      function()
        require("neotest").output.toggle()
      end,
      desc = "Toggle Output Panel",
    },

    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },

    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },

    {
      "<leader>tS",
      function()
        require("neotest").stop()
      end,
      desc = "Stop",
    },

    {
      "<leader>tt",
      function()
        require("neotest").run.run(vim.fn.expand "%:p:h")
      end,
      desc = "Run File",
    },

    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.fn.getcwd())
      end,
      desc = "Run All Test Files",
    },

    {
      "<leader>tw",
      function()
        require("neotest").watch.toggle()
      end,
      desc = "Toggle Watch",
    },
    {
      "<leader>tW",
      function()
        require("neotest").watch.toggle(vim.fn.expand "%:p:h")
      end,
      desc = "Toggle Watch for File",
    }
  },
}
