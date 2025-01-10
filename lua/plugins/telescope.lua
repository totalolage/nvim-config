return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        n = {
          ["<Up>"] = false,
          ["<Down>"] = false,
        },
      },
    },
  },
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
  },
}
