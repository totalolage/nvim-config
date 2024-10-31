return {
  "klen/nvim-config-local",
  lazy = false,
  setup = function(_, opts)
    require("config-local").setup(opts)
  end,
}
