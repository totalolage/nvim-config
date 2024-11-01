return {
  "nvim-tree/nvim-tree.lua",
  opts = vim.tbl_extend("force", require "nvchad.configs.nvimtree", {
    view = {
      width = 50,
    },
    filters = {
      git_ignored = false,
    }
  }),
  keys = {
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle()
      end,
      desc = "Toggle explorer",
    }
  }
}
