return {
  "mason-org/mason.nvim",
  lazy = false,
  opts = function()
    return vim.tbl_extend("force", require "nvchad.configs.mason", { PATH = "prepend" })
  end,
}
