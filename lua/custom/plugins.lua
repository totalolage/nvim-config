local plugins = {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    config = require "custom.configs.null-ls",
  },
  {
    "neovim/nvim-lspconfig",
    -- dependencies = {
    --   "hrsh7th/nvim-cmp",
    -- },
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
    opts = vim.tbl_extend("force", require "plugins.configs.treesitter", require "custom.configs.treesitter"),
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = vim.tbl_extend("force", require "plugins.configs.nvimtree", require "custom.configs.nvimtree"),
  },
  {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_assume_mapped = true
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "williamboman/mason.nvim",
    opts = vim.tbl_extend("force", require "plugins.configs.mason", require "custom.configs.mason"),
  },
  {
    "stevearc/conform.nvim",
    opts = require "custom.configs.conform",
  },
  {
    "zapling/mason-conform.nvim",
    init = function()
      require("mason-conform").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    -- For some godforsaken reason this is the only way to get nvim-surround to load
    init = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = require "custom.configs.auto-save",
  },
  {
    "johmsalas/text-case.nvim",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = require "custom.configs.text-case",
    config = function(_, opts)
      require("textcase").setup(opts)
      require("telescope").load_extension "textcase"
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
  {
    "chentoast/marks.nvim",
    event = "BufRead",
    config = function(_, opts)
      require("marks").setup(opts)
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>tt", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Trouble document" },
      { "<leader>tp", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Trouble project" },
      { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", desc = "Trouble quickfix" },
    },
  },
  {
    "jiaoshijie/undotree",
    lazy = false,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- {
  --   "tzachar/cmp-ai",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   config = require "custom.configs.cmp_ai"
  -- },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "tzachar/cmp-ai",
  --   },
  --   opts = require "custom.configs.cmp"
  -- },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    opts = require "custom.configs.nvim-highlight-colors",
  },
}

return plugins
