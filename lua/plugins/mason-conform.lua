return {
  "zapling/mason-conform.nvim",
  init = function(_, opts)
    require("mason-conform").setup(opts)
  end,
}
