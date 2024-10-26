return {
  "supermaven-inc/supermaven-nvim",
  event = { "InsertEnter", "VeryLazy" },
  opts = {
    keymaps = {
      accept_suggestion = "<c-y>",
      clear_suggestion = "<c-]>",
      accept_word = "<c-j>",
    },
  },
  config = function(_, opts)
    require("supermaven-nvim").setup(opts)
  end,
}
