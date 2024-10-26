require "nvchad.options"

vim.opt.relativenumber = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.cursorlineopt = 'both'

-- Custom file extensions
vim.filetype.add({
  extension = {
    mdx = "mdx",
  }
})
