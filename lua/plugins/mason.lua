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
      "biome",
      "oxlint",
      "tailwindcss-language-server",
      "tsgo",
      -- "flow-language-server",
      "graphql-language-service-cli",
      "astro-language-server",

      -- generic stuff
      "json-lsp",
      "yaml-language-server",
      -- "mdx-analyzer",
      -- "remark-language-server",
      "shfmt",
      "bash-language-server",
    },
  }),
}
