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

-- Environment variables
vim.env.NVIM_SOCKET_PATH = vim.api.nvim_eval("v:servername")

-- Shell configuration for proper fnm integration
vim.opt.shell = vim.fn.stdpath("config") .. "/nvim-shell"
vim.opt.shellcmdflag = ""

-- Set up shell environment for fnm
vim.env.SHELL = "/bin/zsh"
