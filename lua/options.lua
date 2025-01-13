require "nvchad.options"

vim.opt.relativenumber = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.cursorlineopt = 'both'
vim.opt.mouse=""

-- Custom file extensions
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})
