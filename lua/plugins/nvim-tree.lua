return {
  "nvim-tree/nvim-tree.lua",
  opts = vim.tbl_extend("force", require "nvchad.configs.nvimtree", {
    view = {
      width = 50,
    },
  }),
}
