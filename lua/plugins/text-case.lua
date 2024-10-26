return {
  "johmsalas/text-case.nvim",
  lazy = false,
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    prefix = "<leader>ac",
  },
  config = function(_, opts)
    require("textcase").setup(opts)
    require("telescope").load_extension "textcase"
  end,
  keys = {
    {
      "<leader>ac.",
      "<cmd>TextCaseOpenTelescope<CR>",
      desc = "Text Case Telescope",
    }
  }
}
