return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fe",
      "<cmd>Telescope grep_string<CR>",
      desc = "Find word",
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
      "<leader>tr",
      "<cmd>Telescope resume<CR>",
      desc = "Resume last telescope session",
    },
  }
}
