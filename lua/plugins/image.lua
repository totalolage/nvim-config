return {
  "3rd/image.nvim",
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  ft = { "image" },
  opts = {
    backend = vim.uv.os_uname().sysname == "Darwin" and "kitty" or "ueberzug",
    processor = "magick_cli",
  },
}
