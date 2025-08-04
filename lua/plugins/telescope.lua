return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "rcarriga/nvim-notify", lazy = false, priority = 100 },
  },
  opts = function(_, opts)
    -- Extend existing options
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      mappings = {
        n = {
          ["<Up>"] = false,
          ["<Down>"] = false,
        },
      },
    })
    
    -- Add notify extension config
    opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
      notify = {
        -- Telescope notify extension config
      },
    })
    
    return opts
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    
    -- Load the notify extension
    telescope.load_extension("notify")
  end,
  keys = {
    {
      "<leader>fe",
      "<cmd>Telescope grep_string<CR>",
      desc = "Find word",
      mode = { "n", "v" },
    },
    {
      "<leader>fr",
      "<cmd>Telescope lsp_references<CR>",
      desc = "Find references",
    },
    {
      "<leader>fd",
      "<cmd>Telescope lsp_definitions<CR>",
      desc = "Find definitions",
    },
    {
      "<leader>te",
      "<cmd>Telescope resume<CR>",
      desc = "Resume last telescope session",
    },
    {
      "<leader>fn",
      "<cmd>Telescope notify<CR>",
      desc = "Find notifications",
    },
  },
}
