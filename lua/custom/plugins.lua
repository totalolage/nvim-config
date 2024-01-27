local plugins = {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- webdev stuff
        "eslint_d",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
        "graphql-language-service-cli",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = function()
      local opts = require "plugins.configs.treesitter"
      opts.ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
      }
      return opts
    end,
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  "tpope/vim-fugitive",
  {
    "junegunn/gv.vim",
    event = "VeryLazy",
    cmd = "GV",
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  -- {
  --   "rhysd/conflict-marker.vim",
  --   event = "BufRead",
  --   config = function()
  --     require "custom.configs.conflict-marker"
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
      require "custom.configs.conform"
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      noautocmd = true,
    },
  },
  -- {
  --   "echasnovski/mini.nvim",
  --   version = "*",
  --   config = function()
  --     -- require "custom.configs.minimap"
  --     require("mini.map").setup()
  --   end,
  -- },
}

return plugins
