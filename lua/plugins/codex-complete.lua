return {
  "joegoggin/codex-complete.nvim",
  commit = "19f4afa1352e80147d34132afd546ddfee147e78",
  main = "codex_complete",
  event = { "InsertEnter", "VeryLazy" },
  opts = {
    codex = {
      model = "gpt-6-luna",
      effort = "low",
    },
    keymaps = {
      accept = "<C-y>",
      dismiss = "<C-]>",
    },
  },
  config = function(_, opts)
    require("configs.codex_complete").setup(opts)
  end,
}
