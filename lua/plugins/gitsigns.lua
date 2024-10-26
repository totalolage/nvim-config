return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "<leader>rb",
      "<cmd>lua require('gitsigns').reset_buffer()<CR>",
      desc = "Reset buffer",
    },
    {
      "<leader>sh",
      "<cmd>lua require('gitsigns').stage_hunk()<CR>",
      desc = "Stage hunk",
    },
    {
      "<leader>uh",
      "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>",
      desc = "Undo stage hunk",
    },
    {
      "<leader>sb",
      "<cmd>lua require('gitsigns').stage_buffer()<CR>",
      desc = "Stage buffer",
    },
    {
      "<leader>ub",
      "<cmd>lua require('gitsigns').reset_buffer_index()<CR>",
      desc = "Undo stage buffer",
    }
  }
}
