return {
  "neovim/nvim-lspconfig",
  -- dependencies = {
  --   "hrsh7th/nvim-cmp",
  -- },
  config = function()
    local nvlsp = require "nvchad.configs.lspconfig"
    nvlsp.defaults()

    local autocomplete_capibilities = require("cmp_nvim_lsp").default_capabilities()

    local lspconfig = require "lspconfig"

    local servers = {
      "astro",
      "cssls",
      "eslint",
      "graphql",
      "html",
      "jsonls",
      "tailwindcss",
      "ts_ls",
      "yamlls",
    }

    local server_settings = {
      ts_ls = {
        implicitProjectConfiguration = {
          checkJs = true,
        },
      },
      yamlls = {
        schemaStore = {
          enable = true,
        },
      }
    }


    -- lsps with default config
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, autocomplete_capibilities),
        settings = server_settings[lsp],
      }
    end
  end,
}
