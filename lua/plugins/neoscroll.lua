return {
  "karb94/neoscroll.nvim",
  opts = {
    easing = "sine",
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
  end,
  keys = {
    "<C-u>",
    "<C-d>",
    "<C-b>",
    "<C-f>",
    "<C-y>",
    "<C-e>",
    "zt",
    "zz",
    "zb",
  },
}
