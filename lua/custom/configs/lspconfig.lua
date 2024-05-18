local base = require "plugins.configs.lspconfig"
local on_attach = base.on_attach
local base_capibilities = base.capabilities
local autocomplete_capibilities = require('cmp_nvim_lsp').default_capabilities()

local capibilities = vim.tbl_deep_extend("force", base_capibilities, autocomplete_capibilities)

local lspconfig = require "lspconfig"

local servers = {
  "astro",
  "eslint",
  "graphql",
  "jsonls",
  "tailwindcss",
  "tsserver",
  "yamlls",
}

local server_settings = {
  tsserver = {
    implicitProjectConfiguration = {
      checkJs = true,
    }
  }
}

for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capibilities = capibilities,
    settings = server_settings[lsp],
  }
end
