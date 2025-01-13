return {
  "nvim-treesitter/playground",
  requires = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = "TSPlaygroundToggle",
  keys = {
    {
      "<leader>tsp",
      "<cmd>TSPlaygroundToggle<CR>",
      desc = "Toggle Treesitter Playground",
    },
  },
}
