return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = true,
  opts = {
    -- Terminal options
    terminal = {
      split_width_percentage = 0.5,
    },
  },
  keys = {
    { "<A-c>", "<cmd>ClaudeCode<cr>", mode = { "i", "n" }, desc = "Toggle Claude" },
    { "<A-c>", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  },
}
