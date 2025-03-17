require "nvchad.mappings"

local map = vim.keymap.set

-- path yanks: (broken for some reason)
map("n", "<leader>yf", "", { desc = "Yank filename" })
map("n", "<leader>yf ", "<cmd>let @+ = expand('%:t')<CR>", { desc = "Yank filename" })
map(
  "n",
  "<leader>yfl",
  "<cmd>let @+ = join([expand('%:t'), line('.')], ':')<CR>",
  { desc = "Yank path filename with line number" }
)
map(
  "n",
  "<leader>yfc",
  "<cmd>let @+ = join([expand('%:t'), line('.'), col('.')], ':')<CR>",
  { desc = "Yank path filename with cursor position" }
)
map("n", "<leader>yr", "", { desc = "Yank relative path" })
map("n", "<leader>yr", "<cmd>let @+ = expand('%:~:.')<CR>", { desc = "Yank relative path" })
map(
  "n",
  "<leader>yrl",
  "<cmd>let @+ = join([expand('%:~:.'), line('.')], ':')<CR>",
  { desc = "Yank relative path with line number" }
)
map(
  "n",
  "<leader>yrc",
  "<cmd>let @+ = join([expand('%:~:.'), line('.'), col('.')], ':')<CR>",
  { desc = "Yank relative path with cursor position" }
)
map("n", "<leader>ya", "", { desc = "Yank absolute path" })
map("n", "<leader>ya ", "<cmd>let @+ = expand('%:p')<CR>", { desc = "Yank absolute path" })
map(
  "n",
  "<leader>yal",
  "<cmd>let @+ = join([expand('%:p'), line('.')], ':')<CR>",
  { desc = "Yank path absolute with line number" }
)
map(
  "n",
  "<leader>yac",
  "<cmd>let @+ = join([expand('%:p'), line('.'), col('.')], ':')<CR>",
  { desc = "Yank absolute path with cursor position" }
)

-- diagnostics
map("n", "<leader>ds", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostics" })

-- file opening:
map("n", "<leader>of", function()
  local clipboard = vim.fn.getreg "+"

  local filename_dirty, line_dirty, column_dirty

  -- libs/gql-server/src/resolvers/breakdown/utils/transformBackendError.ts#L31
  if not filename_dirty then
    filename_dirty, line_dirty, column_dirty = clipboard:match "^(.+)#L([1-9]%d*)$"
  end
  -- libs/gql-server/src/resolvers/breakdown/utils/transformBackendError.ts#L31-L36
  if not filename_dirty then
    filename_dirty, line_dirty, column_dirty = clipboard:match "^(.+)#L([1-9]%d*)-L([1-9]%d*)$"
  end

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

  -- -- paste debug info into the current buffer
  -- vim.cmd("echom 'Yanked file: " .. filename .. "' | echom 'Yanked line: " .. line .. "' | echom 'Yanked column: " .. column .. "'")

  vim.cmd("e " .. filename)
  vim.fn.cursor(line, column)
end, { desc = "Open last yanked file" })

-- navigation
map("n", "<leader>X", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close all buffers" })
-- option + tab to move buffer to the right
map("n", "<A-Tab>", function()
  require("nvchad.tabufline").move_buf(1)
end, { desc = "Move buffer to the right" })
-- option + shift + tab to move buffer to the left (not working right now)
map("n", "<A-Shift-Tab>", function()
  require("nvchad.tabufline").move_buf(-1)
end, { desc = "Move buffer to the left" })

-- window sizing
map("n", "=", "<C-w>+", { desc = "Increase window height" })
map("n", "-", "<C-w>-", { desc = "Decrease window height" })
map("n", "+", "<C-w>>", { desc = "Increase window width" })
map("n", "_", "<C-w><", { desc = "Decrease window width" })

-- disable arrow keys
map({ "n", "v" }, "<Left>", "<Nop>", { noremap = true })
map({ "n", "v" }, "<Right>", "<Nop>", { noremap = true })
map({ "n", "v" }, "<Up>", "<Nop>", { noremap = true })
map({ "n", "v" }, "<Down>", "<Nop>", { noremap = true })

-- disable control-hjkl movement
map({ "n", "v" }, "<C-h>", "<Nop>", { noremap = true })
map({ "n", "v" }, "<C-j>", "<Nop>", { noremap = true })
map({ "n", "v" }, "<C-k>", "<Nop>", { noremap = true })
map({ "n", "v" }, "<C-l>", "<Nop>", { noremap = true })
