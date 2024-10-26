return {
  "chentoast/marks.nvim",
  event = "BufRead",
  config = function(_, opts)
    require("marks").setup(opts)
  end,
}
