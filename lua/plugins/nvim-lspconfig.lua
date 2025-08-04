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
      "biome",
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
      jsonls = {
        schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json",
          },
          {
            fileMatch = { "tsconfig.json", "tsconfig.*.json" },
            url = "http://json.schemastore.org/tsconfig",
          },
        },
      },
      yamlls = {
        schemaStore = {
          enable = true,
        },
      }
    }
    
    -- Function to get the local biome executable if it exists
    local function get_biome_cmd()
      local local_biome = vim.fn.getcwd() .. "/node_modules/.bin/biome"
      if vim.fn.executable(local_biome) == 1 then
        return { local_biome, "lsp-proxy" }
      end
      -- Fallback to Mason's biome
      return { "biome", "lsp-proxy" }
    end

    -- lsps with default config
    for _, lsp in ipairs(servers) do
      local config = {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, autocomplete_capibilities),
        settings = server_settings[lsp],
      }
      
      -- Use local biome if available
      if lsp == "biome" then
        config.cmd = get_biome_cmd()
      end
      
      lspconfig[lsp].setup(config)
    end
  end,
}
