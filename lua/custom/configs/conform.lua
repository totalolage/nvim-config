local webdev_lsps = {
  "eslint-lsp",
  "prettierd",
}

local opts = {
  lsp_fallback = true,

  formatters_by_ft = {
    lua = { "stylua" },

    yaml = { "yamlfmt" },
    json = { "jsonls" },

    html = { webdev_lsps },
    css = { webdev_lsps },

    javascript = { webdev_lsps, "graphql" },
    javascriptreact = { webdev_lsps, "graphql" },
    typescript = { webdev_lsps, "graphql" },
    typescriptreact = { webdev_lsps, "graphql" },

    astro = { webdev_lsps, "astro" },

    graphql = { "graphql" },
  },

  -- -- adding same formatter for multiple filetypes can look too much work for some
  -- -- instead of the above code you could just use a loop! the config is just a table after all!
  --
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 2000,
  --   lsp_fallback = true,
  -- },
}

return opts
