return {
  'aaronik/treewalker.nvim',

  -- The following options are the defaults.
  -- Treewalker aims for sane defaults, so these are each individually optional,
  -- and setup() does not need to be called, so the whole opts block is optional as well.
  -- opts = {
  --   -- Whether to briefly highlight the node after jumping to it
  --   highlight = true,
  --
  --   -- How long should above highlight last (in ms)
  --   highlight_duration = 250,
  --
  --   -- The color of the above highlight. Must be a valid vim highlight group.
  --   -- (see :h highlight-group for options)
  --   highlight_group = 'CursorLine',
  -- }
  -- -- movement
  -- vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
  -- vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
  -- vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
  -- vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })
  --
  -- -- swapping
  -- vim.keymap.set('n', '<C-S-k>', '<cmd>Treewalker SwapUp<cr>', { silent = true })
  -- vim.keymap.set('n', '<C-S-j>', '<cmd>Treewalker SwapDown<cr>', { silent = true })
  -- vim.keymap.set('n', '<C-S-h>', '<cmd>Treewalker SwapLeft<cr>', { silent = true })
  -- vim.keymap.set('n', '<C-S-l>', '<cmd>Treewalker SwapRight<cr>', { silent = true })
  cmd = "Treewalker",
  keys = {
    { "<C-k>", "<cmd>Treewalker Up<cr>", mode = { "n", "v" }, desc = "Treewalker up" },
    { "<C-j>", "<cmd>Treewalker Down<cr>", mode = { "n", "v" }, desc = "Treewalker down" },
    { "<C-h>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "Treewalker left" },
    { "<C-l>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Treewalker right" },
    { "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", mode = "n", desc = "Swap with the node above" },
    { "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", mode = "n", desc = "Swap with the node below" },
    { "<C-S-h>", "<cmd>Treewalker SwapLeft<cr>", mode = "n", desc = "Swap with the node to the left" },
    { "<C-S-l>", "<cmd>Treewalker SwapRight<cr>", mode = "n", desc = "Swap with the node to the right" },
  },
}
