return {
  "sindrets/diffview.nvim",

  opts = function()
    local diffview = require "diffview"
    return {
      diff_binaries = false,
      enhanced_diff_hl = true,
      file_panel = {
        open = function(winid)
          diffview.toggle(winid)
        end,
      },
      use_icons = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
    }
  end,
  keys = {
    { "<leader>gmo", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
    { "<leader>gmc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
  },
}
