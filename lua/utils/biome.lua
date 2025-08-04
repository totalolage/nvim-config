-- Biome utility module for centralized path resolution and configuration detection
local M = {}

-- Cache for biome executable paths to avoid repeated filesystem checks
local biome_path_cache = {}

-- Clear cache when directory changes
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    biome_path_cache = {}
  end,
  desc = "Clear Biome path cache on directory change"
})

--- Get the path to the Biome executable
--- Checks for local project biome first, then falls back to global
--- @param cwd string|nil The working directory (defaults to vim.fn.getcwd())
--- @return string The path to the biome executable
function M.get_biome_executable(cwd)
  cwd = cwd or vim.fn.getcwd()
  
  -- Check cache first
  if biome_path_cache[cwd] then
    return biome_path_cache[cwd]
  end
  
  -- Check for local biome in node_modules
  local local_biome = cwd .. "/node_modules/.bin/biome"
  if vim.fn.executable(local_biome) == 1 then
    biome_path_cache[cwd] = local_biome
    return local_biome
  end
  
  -- Fallback to global biome (from PATH, usually Mason's)
  biome_path_cache[cwd] = "biome"
  return "biome"
end

--- Get the Biome LSP command
--- @param cwd string|nil The working directory
--- @return table The command array for starting Biome LSP
function M.get_lsp_cmd(cwd)
  return { M.get_biome_executable(cwd), "lsp-proxy" }
end

--- Check if a Biome config file exists in the given directory
--- @param cwd string|nil The working directory
--- @return boolean Whether a biome config exists
function M.has_biome_config(cwd)
  cwd = cwd or vim.fn.getcwd()
  local configs = { "biome.json", "biome.jsonc" }
  
  for _, config in ipairs(configs) do
    if vim.fn.filereadable(cwd .. "/" .. config) == 1 then
      return true
    end
  end
  
  return false
end

--- Check if Biome formatter is enabled in the config
--- @param cwd string|nil The working directory
--- @return boolean Whether the formatter is enabled (true if not explicitly disabled)
function M.is_formatter_enabled(cwd)
  cwd = cwd or vim.fn.getcwd()
  
  -- Find biome config file
  local config_path = nil
  local configs = { "biome.json", "biome.jsonc" }
  for _, config in ipairs(configs) do
    local path = cwd .. "/" .. config
    if vim.fn.filereadable(path) == 1 then
      config_path = path
      break
    end
  end
  
  if not config_path then
    return true -- Default to enabled if no config
  end
  
  -- Read and check config
  local ok, lines = pcall(vim.fn.readfile, config_path)
  if not ok then
    return true -- Default to enabled if can't read
  end
  
  local content = table.concat(lines, "\n")
  -- Check if formatter is explicitly disabled
  return not string.match(content, '"formatter"%s*:%s*{%s*"enabled"%s*:%s*false')
end

--- Detect if the current project should use Biome for formatting
--- Takes into account both Biome and Prettier configs
--- @param cwd string|nil The working directory
--- @return boolean Whether to use Biome for formatting
function M.should_use_biome_formatter(cwd)
  cwd = cwd or vim.fn.getcwd()
  
  local has_biome = M.has_biome_config(cwd)
  if not has_biome then
    return false
  end
  
  -- Check for Prettier config
  local prettier_configs = {
    ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml",
    ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js", "prettier.config.cjs"
  }
  
  local has_prettier = false
  for _, config in ipairs(prettier_configs) do
    if vim.fn.filereadable(cwd .. "/" .. config) == 1 then
      has_prettier = true
      break
    end
  end
  
  -- If both exist, check if Biome formatter is disabled
  if has_prettier and not M.is_formatter_enabled(cwd) then
    return false
  end
  
  return true
end

return M