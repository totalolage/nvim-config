return {
  "williamboman/mason.nvim",
  opts = vim.tbl_extend("force", require "nvchad.configs.mason", {
    ensure_installed = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- webdev stuff
      "eslint-lsp",
      "prettierd",
      "tailwindcss-language-server",
      "typescript-language-server",
      -- "flow-language-server",
      "graphql-language-service-cli",
      "astro-language-server",

      -- generic stuff
      "json-lsp",
      "yaml-language-server",
      -- "mdx-analyzer",
      -- "remark-language-server",
    },
  }),
}
