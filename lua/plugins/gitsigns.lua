return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "<leader>hs",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "Stage hunk",
    },
    {
      "<leader>hu",
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      desc = "Undo stage hunk",
      mode = "n",
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset hunk",
      mode = "n",
    },
    {
      "<leader>hu",
      function()
        require("gitsigns").undo_stage_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
      desc = "Undo stage hunk",
      mode = "v",
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
      desc = "Reset hunk",
      mode = "v",
    },
    {
      "<leader>hp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview hunk",
    },
    {
      "<leader>hb",
      function()
        require("gitsigns").blame_line { full = true }
      end,
      desc = "Blame line",
    },
    {
      "<leader>Hd",
      function()
        require("gitsigns").diffthis()
      end,
      desc = "Diff this",
    },
    {
      "<leader>Hs",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "Stage buffer",
    },
    {
      "<leader>Hu",
      function()
        require("gitsigns").reset_buffer_index()
      end,
      desc = "Undo stage buffer",
    },
    {
      "<leader>rb",
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = "Reset buffer",
    },
    {
      "<leader>tb",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle current line blame",
    },
    {
      "]c",
      function()
        require("gitsigns").next_hunk()
      end,
      desc = "Next hunk",
    },
    {
      "[c",
      function()
        require("gitsigns").prev_hunk()
      end,
      desc = "Prev hunk",
    },
  },
}
