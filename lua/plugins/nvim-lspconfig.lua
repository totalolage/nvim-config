return {
  "neovim/nvim-lspconfig",
  -- dependencies = {
  --   "hrsh7th/nvim-cmp",
  -- },
  config = function()
    local nvlsp = require "nvchad.configs.lspconfig"
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
      },
    }

    -- defaults via autocommand
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        nvlsp.on_attach(client, args.buf)
      end,
    })

    for _, lsp in ipairs(servers) do
      vim.lsp.config(lsp, {
        capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, autocomplete_capibilities),
        settings = server_settings[lsp],
      })
    end

    vim.lsp.enable(servers)
  end,
}
