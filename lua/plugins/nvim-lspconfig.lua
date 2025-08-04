return {
  "neovim/nvim-lspconfig",
  config = function()
    local nvlsp = require "nvchad.configs.lspconfig"
    local lspconfig = require "lspconfig"
    local biome_util = require "utils.biome"
    
    nvlsp.defaults()

    local autocomplete_capibilities = require("cmp_nvim_lsp").default_capabilities()

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

    -- Setup Biome with dynamic command resolution for local vs global binary
    lspconfig.biome.setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, autocomplete_capibilities),
      cmd = function()
        -- Dynamically resolve the command when LSP starts
        -- This function is called each time the LSP client starts
        return biome_util.get_lsp_cmd()
      end,
      root_dir = function(fname)
        -- Find project root by looking for biome config or git root
        return lspconfig.util.root_pattern("biome.json", "biome.jsonc")(fname)
          or lspconfig.util.find_git_ancestor(fname)
          or vim.fn.getcwd()
      end,
      -- Add handlers to prevent errors during shutdown/restart
      handlers = {
        ["$/progress"] = function(...) 
          -- Wrap in pcall to prevent errors during shutdown
          pcall(vim.lsp.handlers["$/progress"], ...)
        end,
      },
    }
    
    -- Setup other language servers
    for _, lsp in ipairs(servers) do
      if lsp ~= "biome" then  -- Skip biome as it's configured above
        lspconfig[lsp].setup {
          on_attach = nvlsp.on_attach,
          on_init = nvlsp.on_init,
          capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, autocomplete_capibilities),
          settings = server_settings[lsp],
        }
      end
    end
  end,
}
