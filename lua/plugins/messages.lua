-- Simple command to view messages in a floating window
vim.api.nvim_create_user_command("MessagesFloat", function()
  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")
  
  -- Create a buffer for the messages
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  
  -- Create floating window
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Messages ",
    title_pos = "center",
  })
  
  -- Set up keymaps for the floating window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end, { desc = "Show messages in floating window" })

return {}