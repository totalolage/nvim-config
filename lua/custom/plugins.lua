local plugins = {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      require "custom.configs.null-ls"
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
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = function()
      local default_opts = require "plugins.configs.treesitter"
      local custom_opts = require "custom.configs.treesitter"
      local opts = vim.tbl_deep_extend("force",default_opts, custom_opts)
      return opts
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local default_opts = require "plugins.configs.nvimtree"
      local custom_opts = require "custom.configs.nvimtree"
      local opts = vim.tbl_deep_extend("force", default_opts, custom_opts)
      return opts
    end,
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  "williamboman/mason.nvim",
  {
    "stevearc/conform.nvim",
    opts = function()
      require "custom.configs.conform"
    end,
  },
  "zapling/mason-conform.nvim",
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
  },
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      noautocmd = true,
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require "custom.configs.text-case"
    end,
    keys = {
      "<leader>ac",
      { "<leader>ac.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}

return plugins
