return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  opts = {
    ensure_installed = {
      "astro",
      "css",
      "graphql",
      "javascript",
      "lua",
      "markdown",
      "markdown_inline",
      "tsx",
      "typescript",
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "syntax")
    require("nvim-treesitter.configs").setup(opts)
    -- tell treesitter to use the markdown parser for mdx files
    vim.treesitter.language.register("markdown", "mdx")
  end,
}
