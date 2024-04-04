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
      require "plugins.configs.treesitter"
      require "custom.configs.treesitter"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      require "plugins.configs.nvimtree"
      require "custom.configs.nvimtree"
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
    opts = function()
      require "custom.configs.auto-save"
    end,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require "custom.configs.text-case"
    end,
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
  -- {
  --   "mistricky/codesnap.nvim",
  --   build = "make",
  --   cmd = { "CodeSnap" },
  -- },
}

return plugins
