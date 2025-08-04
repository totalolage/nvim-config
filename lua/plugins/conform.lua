local biome_util = require "utils.biome"

-- Cache for formatter detection
local formatter_cache = {}

-- Clear cache when directory changes
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    formatter_cache = {}
  end,
  desc = "Clear formatter cache on directory change",
})

-- Determine which formatter to use for JavaScript/TypeScript files
local function get_js_formatters()
  local cwd = vim.fn.getcwd()

  -- Check cache
  if formatter_cache[cwd] then
    return formatter_cache[cwd]
  end

  -- Use biome utility to determine formatter
  local result = biome_util.should_use_biome_formatter(cwd) and { "biome" } or { "prettierd" }
  formatter_cache[cwd] = result
  return result
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
        -- Dynamically resolve biome executable path
        command = biome_util.get_biome_executable,
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
