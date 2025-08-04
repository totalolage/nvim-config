-- Function to detect which formatter to use
local function get_js_formatters()
  local root_dir = vim.fn.getcwd()
  
  -- Check for Biome config files
  local biome_configs = { "biome.json", "biome.jsonc" }
  for _, config in ipairs(biome_configs) do
    if vim.fn.filereadable(root_dir .. "/" .. config) == 1 then
      return { "biome" }
    end
  end
  
  -- Default to Prettier
  return { "prettierd" }
end

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

      javascript = function()
        local formatters = get_js_formatters()
        table.insert(formatters, "eslint-lsp")
        table.insert(formatters, "graphql")
        return formatters
      end,
      javascriptreact = function()
        local formatters = get_js_formatters()
        table.insert(formatters, "eslint-lsp")
        table.insert(formatters, "graphql")
        return formatters
      end,
      typescript = function()
        local formatters = get_js_formatters()
        table.insert(formatters, "eslint-lsp")
        table.insert(formatters, "graphql")
        return formatters
      end,
      typescriptreact = function()
        local formatters = get_js_formatters()
        table.insert(formatters, "eslint-lsp")
        table.insert(formatters, "graphql")
        return formatters
      end,

      astro = {
        "eslint-lsp",
        "prettierd",
        "astro",
      },

      graphql = { "graphql" },
    },

    -- Configure formatters
    formatters = {
      biome = {
        -- Use biome check with apply flag for formatting
        command = "biome",
        args = {
          "check",
          "--apply",
          "--formatter-enabled=true",
          "--linter-enabled=false",
          "--organize-imports-enabled=true",
          "--stdin-file-path",
          "$FILENAME",
        },
        stdin = true,
      },
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
