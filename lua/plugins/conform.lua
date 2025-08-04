return {
  "stevearc/conform.nvim",
  -- Event = 'BufWritePre', -- Format on save
  opts = {
    log_level = vim.log.levels.DEBUG,
    lsp_fallback = true,

    formatters_by_ft = {
      lua = { "stylua" },
      html = { "prettierd" },
      css = { "prettierd" },

      yaml = { "yamlfmt" },
      json = { "jsonls" },

      markdown = { "remark-language-server" },
      -- mdx = { "mdx-language-server" },

      javascript = {
        -- "biome", -- Uncomment to use Biome instead of Prettier
        "eslint-lsp",
        "prettierd",
        "graphql",
      },
      javascriptreact = {
        -- "biome", -- Uncomment to use Biome instead of Prettier
        "eslint-lsp",
        "prettierd",
        "graphql",
      },
      typescript = {
        -- "biome", -- Uncomment to use Biome instead of Prettier
        "eslint-lsp",
        "prettierd",
        "graphql",
      },
      typescriptreact = {
        -- "biome", -- Uncomment to use Biome instead of Prettier
        "eslint-lsp",
        "prettierd",
        "graphql",
      },

      astro = {
        "eslint-lsp",
        "prettierd",
        "astro",
      },

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

    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        desc = "Format current buffer",
      },
    },
  },
}
