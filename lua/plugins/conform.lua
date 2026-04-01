local js_formatter_candidates = {
  { formatter = "oxfmt", executable = "oxfmt" },
  { formatter = "biome", executable = "biome" },
  { formatter = "prettierd", executable = "prettierd" },
}

local html_formatter_candidates = {
  { formatter = "oxfmt", executable = "oxfmt" },
  { formatter = "biome", executable = "biome" },
  { formatter = "prettierd", executable = "prettierd" },
  { formatter = "prettier", executable = "prettier" },
}

local css_formatter_candidates = {
  { formatter = "oxfmt", executable = "oxfmt" },
  { formatter = "biome", executable = "biome" },
  { formatter = "prettierd", executable = "prettierd" },
  { formatter = "prettier", executable = "prettier" },
}

local json_formatter_candidates = {
  { formatter = "oxfmt", executable = "oxfmt" },
  { formatter = "biome", executable = "biome" },
  { formatter = "prettierd", executable = "prettierd" },
  { formatter = "prettier", executable = "prettier" },
}

local astro_formatter_candidates = {
  { formatter = "prettierd", executable = "prettierd" },
  { formatter = "prettier", executable = "prettier" },
  { formatter = "deno_fmt", executable = "deno" },
}

local graphql_formatter_candidates = {
  { formatter = "oxfmt", executable = "oxfmt" },
  { formatter = "prettierd", executable = "prettierd" },
  { formatter = "prettier", executable = "prettier" },
}

local local_formatter_suffix = "__local"

local formatter_package_names = {
  oxfmt = { "oxc", "oxfmt", "@oxc-project/cli" },
  biome = { "@biomejs/biome", "biome" },
  prettierd = { "@fsouza/prettierd", "prettierd" },
  prettier = { "prettier" },
}

local manifest_dependency_fields = {
  "dependencies",
  "devDependencies",
  "optionalDependencies",
  "peerDependencies",
}

local package_manifest_cache = {}

local function get_manifest_cache_key(package_manifest_stat)
  return table.concat({
    package_manifest_stat.mtime.sec,
    package_manifest_stat.mtime.nsec,
    package_manifest_stat.size,
  }, ":")
end

local js_workspace_root_markers = {
  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "bun.lock",
  "bun.lockb",
  "pnpm-workspace.yaml",
  ".git",
}

local function get_workspace_root(start_dir)
  if not start_dir then
    return nil
  end

  local marker = vim.fs.find(js_workspace_root_markers, {
    path = start_dir,
    upward = true,
    stop = vim.uv.os_homedir(),
  })[1]

  if not marker then
    return start_dir
  end

  return vim.fs.dirname(marker)
end

local function read_package_manifest(package_manifest_path)
  local package_manifest_stat = vim.uv.fs_stat(package_manifest_path)
  if not package_manifest_stat then
    package_manifest_cache[package_manifest_path] = nil
    return false
  end

  local manifest_cache_key = get_manifest_cache_key(package_manifest_stat)

  local cached_manifest = package_manifest_cache[package_manifest_path]
  if cached_manifest and cached_manifest.cache_key == manifest_cache_key then
    return cached_manifest.manifest
  end

  local ok, decoded_manifest = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(package_manifest_path), "\n"))
  end)

  if not ok or type(decoded_manifest) ~= "table" then
    package_manifest_cache[package_manifest_path] = {
      cache_key = manifest_cache_key,
      manifest = false,
    }
    return false
  end

  package_manifest_cache[package_manifest_path] = {
    cache_key = manifest_cache_key,
    manifest = decoded_manifest,
  }

  return decoded_manifest
end

local function manifest_declares_dependency(package_manifest_path, package_names)
  local package_manifest = read_package_manifest(package_manifest_path)
  if not package_manifest then
    return false
  end

  for _, dependency_field in ipairs(manifest_dependency_fields) do
    local declared_dependencies = package_manifest[dependency_field]
    if type(declared_dependencies) == "table" then
      for _, package_name in ipairs(package_names) do
        if declared_dependencies[package_name] ~= nil then
          return true
        end
      end
    end
  end

  return false
end

local function get_formatter_package_names(executable)
  return formatter_package_names[executable] or { executable }
end

local function is_node_local_executable(executable)
  return formatter_package_names[executable] ~= nil
end

local function find_project_executable(start_dir, executable)
  if not start_dir or not is_node_local_executable(executable) then
    return nil
  end

  local workspace_root = get_workspace_root(start_dir)
  local package_names = get_formatter_package_names(executable)
  local directory = start_dir

  while directory do
    local package_manifest_path = vim.fs.joinpath(directory, "package.json")
    local candidate = vim.fs.joinpath(directory, "node_modules", ".bin", executable)

    if vim.fn.executable(candidate) == 1 and manifest_declares_dependency(package_manifest_path, package_names) then
      return candidate
    end

    if directory == workspace_root then
      return nil
    end

    local parent = vim.fs.dirname(directory)
    if parent == directory then
      return nil
    end

    directory = parent
  end

  return nil
end

local function get_buffer_directory(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return nil
  end

  return vim.fs.dirname(filename)
end

local function get_preferred_formatters(candidates, bufnr)
  local start_dir = get_buffer_directory(bufnr)
  local local_formatters = {}

  for _, candidate in ipairs(candidates) do
    if find_project_executable(start_dir, candidate.executable) then
      table.insert(local_formatters, candidate.formatter .. local_formatter_suffix)
    end
  end

  if #local_formatters > 0 then
    return local_formatters
  end

  local global_formatters = {}

  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate.executable) == 1 then
      table.insert(global_formatters, candidate.formatter)
    end
  end

  return global_formatters
end

local function resolve_preferred_formatters(candidates)
  return function(bufnr)
    return get_preferred_formatters(candidates, bufnr)
  end
end

local function build_local_formatter_overrides(candidates)
  local local_formatters = {}

  for _, candidate in ipairs(candidates) do
    local local_formatter_name = candidate.formatter .. local_formatter_suffix

    local_formatters[local_formatter_name] = function(bufnr)
      local ok, formatter = pcall(require, "conform.formatters." .. candidate.formatter)
      if not ok then
        error("Missing built-in formatter definition: " .. candidate.formatter)
      end

      local executable = find_project_executable(get_buffer_directory(bufnr), candidate.executable)
      if not executable then
        error("Missing local formatter executable: " .. candidate.executable)
      end

      local formatter_config = vim.deepcopy(formatter)
      formatter_config.command = executable

      return formatter_config
    end
  end

  return local_formatters
end

local local_formatter_overrides = vim.tbl_extend(
  "force",
  build_local_formatter_overrides(js_formatter_candidates),
  build_local_formatter_overrides(html_formatter_candidates),
  build_local_formatter_overrides(css_formatter_candidates),
  build_local_formatter_overrides(astro_formatter_candidates),
  build_local_formatter_overrides(graphql_formatter_candidates)
)

return {
  "stevearc/conform.nvim",
  -- Event = 'BufWritePre', -- Format on save
  opts = {
    log_level = vim.log.levels.DEBUG,

    formatters_by_ft = {
      lua = { "stylua" },
      html = resolve_preferred_formatters(html_formatter_candidates),
      css = resolve_preferred_formatters(css_formatter_candidates),
      json = resolve_preferred_formatters(json_formatter_candidates),
      astro = resolve_preferred_formatters(astro_formatter_candidates),
      graphql = resolve_preferred_formatters(graphql_formatter_candidates),
      javascript = resolve_preferred_formatters(js_formatter_candidates),
      javascriptreact = resolve_preferred_formatters(js_formatter_candidates),
      typescript = resolve_preferred_formatters(js_formatter_candidates),
      typescriptreact = resolve_preferred_formatters(js_formatter_candidates),
      yaml = { "yamlfmt" },
      markdown = { "remark-language-server" },
    },

    -- Configure formatters
    formatters = vim.tbl_extend("force", local_formatter_overrides, {}),

    -- -- adding same formatter for multiple filetypes can look too much work for some
    -- -- instead of the above code you could just use a loop! the config is just a table after all!
    --
    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   timeout_ms = 2000,
    --   lsp_fallback = true,
    -- },
  },
}
