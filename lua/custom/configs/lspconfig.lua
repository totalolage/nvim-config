local base = require "plugins.configs.lspconfig"
local on_attach = base.on_attach
local capibilities = base.capabilities

local lspconfig = require "lspconfig"

local servers = { "tsserver", "tailwindcss", "eslint", "graphql" }

for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capibilities = capibilities,
  }
end
