return {
  "nvim-tree/nvim-tree.lua",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      view = {
        width = 50,
      },
      filters = {
        git_ignored = false,
      },
    })
  end,
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
