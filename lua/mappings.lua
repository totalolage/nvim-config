require "nvchad.mappings"

local map = vim.keymap.set

-- -- path yanks: (broken for some reason)
-- map("n", "ypl ", "<cmd>let @+ = expand('%:t')<CR>", { desc = "Yank Filename" })
-- map("n", "ypnl", "<cmd>let @+ = join([expand('%:t'), line('.')], ':')<CR>", { desc = "Yank Filename with line number" })
-- map(
--   "n",
--   "yplc",
--   "<cmd>let @+ = join([expand('%:t'), line('.'), col('.')], ':')<CR>",
--   { desc = "Yank Filename with line and column number" }
-- )
-- map("n", "ypr ", "<cmd>let @+ = expand('%:~:.')<CR>", { desc = "Yank Path Relative" })
-- map(
--   "n",
--   "yprl",
--   "<cmd>let @+ = join([expand('%:~:.'), line('.')], ':')<CR>",
--   { desc = "Yank Path Relative with line number" }
-- )
-- map(
--   "n",
--   "yprc",
--   "<cmd>let @+ = join([expand('%:~:.'), line('.'), col('.')], ':')<CR>",
--   { desc = "Yank Path Relative with line and column number" }
-- )
-- map("n", "ypa ", "<cmd>let @+ = expand('%:p')<CR>", { desc = "Yank Path Absolute" })
-- map(
--   "n",
--   "ypal",
--   "<cmd>let @+ = join([expand('%:p'), line('.')], ':')<CR>",
--   { desc = "Yank Path Absolute with line number" }
-- )
-- map(
--   "n",
--   "ypac",
--   "<cmd>let @+ = join([expand('%:p'), line('.'), col('.')], ':')<CR>",
--   { desc = "Yank Path Absolute with line and column number" }
-- )

-- diagnostics:
map("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Jump to previous issue" })
map("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Jump to next issue" })

-- file opening:
map("n", "<leader>of", function()
  local clipboard = vim.fn.getreg "+"

  local filename_dirty, line_dirty, column_dirty

  -- src/views/DocumentCreate/DocumentFill/index.tsx:29
  -- Clipboard path should be in format `file[:line[:column]]`
  if not filename_dirty then
    filename_dirty, line_dirty, column_dirty = clipboard:match "^(.+):([1-9]%d*):([1-9]%d*)$"
  end
  if not filename_dirty then
    filename_dirty, line_dirty = clipboard:match "^(.+):([1-9]%d*)$"
  end

  -- Clipboard can alternatively be in the format `file(line[,:]column)`
  if not filename_dirty then
    filename_dirty, line_dirty, column_dirty = clipboard:match "^(.+)%s*%(([1-9]%d*)[,:]([1-9]%d*)%)$"
  end

  -- If all else fails, just use the clipboard as the filename
  if not filename_dirty then
    filename_dirty = clipboard
  end

  local filename = vim.fn.expand(vim.fn.fnameescape(filename_dirty))
  if not vim.fn.filereadable(filename) then
    vim.api.nvim_err_writeln("File does not exist: " .. filename)
    return
  end

  local line = tonumber(line_dirty) or 1
  local column = tonumber(column_dirty) or 1

  vim.cmd("e " .. filename)
  vim.fn.cursor(line, column)
end, { desc = "Open last yanked file" })

-- formattings:
map("n", "<leader>fm", function()
  require("conform").format { async = true }
end, { desc = "Format current buffer" })

-- navigation
map("n", "<leader>X", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close all buffers" })
-- option + tab to move buffer to the right
map("n", "<A-Tab>", function()
  require("nvchad.tabufline").move_buf(1)
end, { desc = "Move buffer to the right" })
-- option + shift + tab to move buffer to the left (not working right now)
map("n", "<A-S-Tab>", function()
  require("nvchad.tabufline").move_buf(-1)
end, { desc = "Move buffer to the left" })
