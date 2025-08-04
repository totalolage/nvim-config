-- Function to detect which formatter to use
local function get_js_formatters()
  local root_dir = vim.fn.getcwd()
  
  -- Check for config files
  local has_biome = false
  local has_prettier = false
  
  -- Check for Biome config
  local biome_configs = { "biome.json", "biome.jsonc" }
  for _, config in ipairs(biome_configs) do
    if vim.fn.filereadable(root_dir .. "/" .. config) == 1 then
      has_biome = true
      break
    end
  end
  
  -- Check for Prettier config
  local prettier_configs = { ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js", "prettier.config.cjs" }
  for _, config in ipairs(prettier_configs) do
    if vim.fn.filereadable(root_dir .. "/" .. config) == 1 then
      has_prettier = true
      break
    end
  end
  
  -- If both exist, check if Biome is configured for formatting
  if has_biome and has_prettier then
    -- Read biome.json to check if formatter is disabled
    local biome_config_path = vim.fn.filereadable(root_dir .. "/biome.json") == 1 and root_dir .. "/biome.json" or root_dir .. "/biome.jsonc"
    local biome_config = vim.fn.readfile(biome_config_path)
    local config_text = table.concat(biome_config, "\n")
    
    -- Check if formatter is explicitly disabled in Biome
    if string.match(config_text, '"formatter"%s*:%s*{%s*"enabled"%s*:%s*false') then
      -- Biome formatter is disabled, use Prettier
      return { "prettierd" }
    end
  end
  
  -- Priority: Biome > Prettier > default Prettier
  if has_biome then
    return { "biome" }
  else
    return { "prettierd" }
  end
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
        command = function()
          local local_biome = vim.fn.getcwd() .. "/node_modules/.bin/biome"
          if vim.fn.executable(local_biome) == 1 then
            return local_biome
          end
          return "biome"
        end,
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
