local M = {}

local js_fixable_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local providers = {
  {
    name = "oxlint",
    client_name = "oxlint",
    executable = "oxlint",
    package_names = { "oxlint", "oxc", "@oxc-project/cli" },
    config_files = {
      "oxlint.json",
      ".oxlintrc.json",
      ".oxlintrc.jsonc",
      ".oxlintrc",
    },
  },
  {
    name = "biome",
    client_name = "biome",
    executable = "biome",
    package_names = { "@biomejs/biome", "biome" },
    config_files = {
      "biome.json",
      "biome.jsonc",
    },
  },
  {
    name = "eslint",
    client_name = "eslint",
    executable = "eslint",
    package_names = { "eslint" },
    config_files = {
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
    },
  },
}

local provider_priority = {}

for index, provider in ipairs(providers) do
  provider_priority[provider.client_name] = index
end

local function client_supports_fix_all(client, bufnr)
  if not client:supports_method("textDocument/codeAction", bufnr) then
    return false
  end

  local code_action_provider = client.server_capabilities.codeActionProvider
  if type(code_action_provider) ~= "table" then
    return true
  end

  local code_action_kinds = code_action_provider.codeActionKinds
  if type(code_action_kinds) ~= "table" or vim.tbl_isempty(code_action_kinds) then
    return true
  end

  for _, code_action_kind in ipairs(code_action_kinds) do
    if code_action_kind == "source.fixAll" or vim.startswith(code_action_kind, "source.fixAll.") then
      return true
    end
  end

  return false
end

local function get_fix_clients(bufnr)
  local fix_clients = {}

  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client_supports_fix_all(client, bufnr) then
      table.insert(fix_clients, client)
    end
  end

  table.sort(fix_clients, function(left, right)
    local left_priority = provider_priority[left.name] or math.huge
    local right_priority = provider_priority[right.name] or math.huge

    if left_priority ~= right_priority then
      return left_priority < right_priority
    end

    if left.name ~= right.name then
      return left.name < right.name
    end

    return left.id < right.id
  end)

  return fix_clients
end

local function make_full_buffer_range(bufnr)
  local last_line_index = vim.api.nvim_buf_line_count(bufnr) - 1
  local last_line = vim.api.nvim_buf_get_lines(bufnr, last_line_index, last_line_index + 1, false)[1] or ""

  return {
    start = { line = 0, character = 0 },
    ["end"] = { line = last_line_index, character = #last_line },
  }
end

local function to_lsp_diagnostic(diagnostic)
  local lsp_diagnostic = diagnostic.user_data and diagnostic.user_data.lsp
  if lsp_diagnostic then
    return lsp_diagnostic
  end

  return {
    range = {
      start = {
        line = diagnostic.lnum,
        character = diagnostic.col,
      },
      ["end"] = {
        line = diagnostic.end_lnum or diagnostic.lnum,
        character = diagnostic.end_col or diagnostic.col,
      },
    },
    severity = diagnostic.severity,
    code = diagnostic.code,
    source = diagnostic.source,
    message = diagnostic.message,
  }
end

local function get_client_diagnostics(bufnr, client)
  local diagnostics = {}

  for _, is_pull in ipairs { false, true } do
    local namespace = vim.lsp.diagnostic.get_namespace(client.id, is_pull)
    vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = namespace }))
  end

  return vim.tbl_map(to_lsp_diagnostic, diagnostics)
end

local function resolve_code_action(client, action, bufnr, timeout_ms)
  if action.edit or action.command or not action.data or not client:supports_method("codeAction/resolve", bufnr) then
    return action
  end

  local response = client:request_sync("codeAction/resolve", action, timeout_ms, bufnr)
  if not response or not response.result then
    return action
  end

  return response.result
end

local function apply_code_action(client, action, bufnr)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end

  local command = action.command or action
  if command.command then
    client:exec_cmd(command, { bufnr = bufnr })
  end
end

local function select_fix_action(actions)
  for _, action in ipairs(actions) do
    if
      action.kind == "source.fixAll"
      or (type(action.kind) == "string" and vim.startswith(action.kind, "source.fixAll."))
    then
      return action
    end
  end

  return nil
end

local function run_client_fix(client, bufnr)
  local timeout_ms = 2000
  ---@type lsp.CodeActionParams
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = make_full_buffer_range(bufnr),
    context = {
      diagnostics = get_client_diagnostics(bufnr, client),
      only = { "source.fixAll" },
    },
  }

  local response = client:request_sync("textDocument/codeAction", params, timeout_ms, bufnr)
  if not response then
    return false, client.name .. " fixer request timed out"
  end

  if type(response.err) == "table" then
    return false, client.name .. " fixer request failed: " .. (response.err.message or "unknown error")
  end

  if response.result == nil or response.result == vim.NIL then
    return true
  end

  if type(response.result) ~= "table" then
    return false, client.name .. " fixer returned an invalid code action response"
  end

  if vim.tbl_isempty(response.result) then
    return true
  end

  local action = select_fix_action(response.result)
  if not action then
    return true
  end

  local ok, err = pcall(function()
    apply_code_action(client, resolve_code_action(client, action, bufnr, timeout_ms), bufnr)
  end)

  if not ok then
    return false, client.name .. " fixer failed: " .. err
  end

  return true
end

local function notify_fix_failure(message)
  vim.notify(message .. "; formatting anyway", vim.log.levels.WARN, {
    title = "Fix and format",
  })
end

function M.fix_and_format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local filetype = vim.bo[bufnr].filetype
  if js_fixable_filetypes[filetype] then
    for _, client in ipairs(get_fix_clients(bufnr)) do
      local ok, err = run_client_fix(client, bufnr)
      if not ok then
        notify_fix_failure(err)
      end
    end
  end

  require("conform").format {
    async = false,
    bufnr = bufnr,
    lsp_format = "fallback",
  }
end

return M
