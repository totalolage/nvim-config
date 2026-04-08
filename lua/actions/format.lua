local M = {}

local log_file_path = vim.fn.stdpath "state" .. "/fix-and-format.log"

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

local function log_fix_and_format(message)
  local ok, timestamped_message = pcall(function()
    local timestamp = os.date "%Y-%m-%d %H:%M:%S"
    return string.format("[%s] %s\n", timestamp, message)
  end)
  if not ok then
    return
  end

  pcall(function()
    local log_file = io.open(log_file_path, "a")
    if not log_file then
      return
    end

    log_file:write(timestamped_message)
    log_file:close()
  end)
end

local function summarize_list(items)
  if type(items) ~= "table" then
    return "none"
  end

  if vim.tbl_isempty(items) then
    return "empty"
  end

  local summarized_items = vim.tbl_map(function(item)
    return tostring(item)
  end, items)

  return table.concat(summarized_items, ", ")
end

local function summarize_client(client, bufnr)
  local code_action_provider = client.server_capabilities.codeActionProvider
  local code_action_kinds = type(code_action_provider) == "table" and code_action_provider.codeActionKinds or nil

  return string.format(
    "%s(id=%s,supports_code_action=%s,supports_resolve=%s,kinds=%s)",
    client.name,
    tostring(client.id),
    tostring(client:supports_method("textDocument/codeAction", bufnr)),
    tostring(client:supports_method("codeAction/resolve", bufnr)),
    summarize_list(code_action_kinds)
  )
end

local function summarize_code_action(action)
  if type(action) ~= "table" then
    return tostring(action)
  end

  return string.format(
    "title=%s kind=%s has_edit=%s has_command=%s has_data=%s",
    tostring(action.title),
    tostring(action.kind),
    tostring(action.edit ~= nil),
    tostring(action.command ~= nil),
    tostring(action.data ~= nil)
  )
end

local function truncate_log_value(value, max_length)
  if type(value) ~= "string" then
    value = tostring(value)
  end

  if #value <= max_length then
    return value
  end

  return string.format("%s... [truncated %d chars]", value:sub(1, max_length), #value - max_length)
end

local function summarize_command_arguments(arguments)
  if arguments == nil then
    return "nil"
  end

  local ok, inspected_arguments = pcall(vim.inspect, arguments)
  if not ok then
    return string.format("<inspect failed: %s>", tostring(inspected_arguments))
  end

  return truncate_log_value(inspected_arguments, 800)
end

local function make_code_action_debug_dump(action)
  local ok, inspected_action = pcall(vim.inspect, action)
  if not ok then
    return string.format("<code action inspect failed: %s>", tostring(inspected_action))
  end

  local command = type(action) == "table" and action.command or nil
  local command_summary = "command=nil"

  if type(command) == "table" then
    command_summary = string.format(
      "command_name=%s command_args=%s",
      tostring(command.command),
      summarize_command_arguments(command.arguments)
    )
  end

  return truncate_log_value(string.format("%s\n%s", command_summary, inspected_action), 4000)
end

local function log_ts_ls_action_dump(client, stage, action)
  if type(client) ~= "table" or client.name ~= "ts_ls" then
    return nil
  end

  local ok, dump = pcall(make_code_action_debug_dump, action)
  if not ok then
    log_fix_and_format(
      string.format("codeAction debug client=%s stage=%s dump_failed=%s", tostring(client.name), tostring(stage), tostring(dump))
    )
    return nil
  end

  log_fix_and_format(
    string.format("codeAction debug client=%s stage=%s %s dump=%s", client.name, tostring(stage), summarize_code_action(action), dump)
  )

  return dump
end

local function make_buffer_snapshot(bufnr)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local sample_parts = {}

  for index = 1, math.min(#lines, 3) do
    sample_parts[#sample_parts + 1] = lines[index]
  end

  if #lines > 3 then
    sample_parts[#sample_parts + 1] = "..."
  end

  local tail_start = math.max(4, #lines - 2)
  for index = tail_start, #lines do
    sample_parts[#sample_parts + 1] = lines[index]
  end

  local sample = table.concat(sample_parts, "\n")

  return {
    changedtick = vim.api.nvim_buf_get_changedtick(bufnr),
    line_count = line_count,
    sample_hash = vim.fn.sha256(sample),
    sample_length = #sample,
  }
end

local function summarize_workspace_edit(edit)
  if type(edit) ~= "table" then
    return "workspace_edit=invalid"
  end

  local summary_parts = {}
  local has_document_changes = type(edit.documentChanges) == "table"
  local has_changes = type(edit.changes) == "table"

  summary_parts[#summary_parts + 1] = string.format("has_documentChanges=%s", tostring(has_document_changes))
  summary_parts[#summary_parts + 1] = string.format("has_changes=%s", tostring(has_changes))

  if has_document_changes then
    summary_parts[#summary_parts + 1] = string.format("documentChanges_count=%d", #edit.documentChanges)

    for index, change in ipairs(edit.documentChanges) do
      if type(change) == "table" and type(change.textDocument) == "table" then
        summary_parts[#summary_parts + 1] = string.format(
          "documentChange[%d]=uri:%s version:%s edits:%s",
          index,
          tostring(change.textDocument.uri),
          tostring(change.textDocument.version),
          tostring(type(change.edits) == "table" and #change.edits or nil)
        )
      elseif type(change) == "table" and change.kind then
        summary_parts[#summary_parts + 1] = string.format(
          "documentChange[%d]=kind:%s uri:%s oldUri:%s newUri:%s",
          index,
          tostring(change.kind),
          tostring(change.uri),
          tostring(change.oldUri),
          tostring(change.newUri)
        )
      else
        summary_parts[#summary_parts + 1] = string.format("documentChange[%d]=unrecognized", index)
      end
    end
  end

  if has_changes then
    local uris = vim.tbl_keys(edit.changes)
    table.sort(uris)
    summary_parts[#summary_parts + 1] = string.format("changes_count=%d", #uris)

    for _, uri in ipairs(uris) do
      local text_edits = edit.changes[uri]
      summary_parts[#summary_parts + 1] = string.format(
        "change_uri=%s edits=%s",
        tostring(uri),
        tostring(type(text_edits) == "table" and #text_edits or nil)
      )
    end
  end

  return table.concat(summary_parts, " ")
end

local function workspace_edit_targets_current_buffer(edit, current_uri)
  if type(edit) ~= "table" then
    return false
  end

  if type(edit.documentChanges) == "table" then
    for _, change in ipairs(edit.documentChanges) do
      if
        type(change) == "table"
        and type(change.textDocument) == "table"
        and change.textDocument.uri == current_uri
      then
        return true
      end

      if
        type(change) == "table"
        and (change.uri == current_uri or change.oldUri == current_uri or change.newUri == current_uri)
      then
        return true
      end
    end
  end

  if type(edit.changes) == "table" and edit.changes[current_uri] ~= nil then
    return true
  end

  return false
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
    log_fix_and_format(string.format("resolve skipped client=%s %s", client.name, summarize_code_action(action)))
    return action
  end

  log_fix_and_format(string.format("resolve request client=%s %s", client.name, summarize_code_action(action)))

  local response = client:request_sync("codeAction/resolve", action, timeout_ms, bufnr)
  if not response or not response.result then
    log_fix_and_format(
      string.format(
        "resolve response client=%s status=%s has_result=%s",
        client.name,
        response and "received" or "nil",
        tostring(response ~= nil and response.result ~= nil)
      )
    )
    return action
  end

  log_fix_and_format(
    string.format("resolve response client=%s status=resolved %s", client.name, summarize_code_action(response.result))
  )

  return response.result
end

local function dumps_differ(left, right)
  if left == nil or right == nil then
    return left ~= right
  end

  return left ~= right
end

local function apply_code_action(client, action, bufnr)
  log_fix_and_format(string.format("apply start client=%s %s", client.name, summarize_code_action(action)))

  if action.edit then
    local current_uri = vim.uri_from_bufnr(bufnr)
    local before_snapshot = make_buffer_snapshot(bufnr)
    local targets_current_buffer = workspace_edit_targets_current_buffer(action.edit, current_uri)

    log_fix_and_format(
      string.format(
        "apply edit client=%s offset_encoding=%s current_uri=%s targets_current_buffer=%s before_changedtick=%s before_line_count=%s before_sample_hash=%s before_sample_length=%s %s",
        client.name,
        tostring(client.offset_encoding),
        tostring(current_uri),
        tostring(targets_current_buffer),
        tostring(before_snapshot.changedtick),
        tostring(before_snapshot.line_count),
        tostring(before_snapshot.sample_hash),
        tostring(before_snapshot.sample_length),
        summarize_workspace_edit(action.edit)
      )
    )

    if not targets_current_buffer then
      log_fix_and_format(
        string.format(
          "apply edit client=%s note=current_buffer_not_targeted current_uri=%s",
          client.name,
          tostring(current_uri)
        )
      )
    end

    local apply_ok, apply_err = vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    local after_snapshot = make_buffer_snapshot(bufnr)

    log_fix_and_format(
      string.format(
        "apply edit client=%s result_ok=%s result_err=%s after_changedtick=%s after_line_count=%s after_sample_hash=%s after_sample_length=%s changedtick_changed=%s line_count_changed=%s sample_changed=%s",
        client.name,
        tostring(apply_ok),
        tostring(apply_err),
        tostring(after_snapshot.changedtick),
        tostring(after_snapshot.line_count),
        tostring(after_snapshot.sample_hash),
        tostring(after_snapshot.sample_length),
        tostring(before_snapshot.changedtick ~= after_snapshot.changedtick),
        tostring(before_snapshot.line_count ~= after_snapshot.line_count),
        tostring(
          before_snapshot.sample_hash ~= after_snapshot.sample_hash
            or before_snapshot.sample_length ~= after_snapshot.sample_length
        )
      )
    )
  end

  local command = action.command or action
  if command.command then
    log_fix_and_format(
      string.format(
        "apply command client=%s command=%s arguments=%s status=starting",
        client.name,
        tostring(command.command),
        vim.inspect(command.arguments)
      )
    )
    client:exec_cmd(command, { bufnr = bufnr })
    log_fix_and_format(
      string.format("apply command client=%s command=%s status=executed", client.name, tostring(command.command))
    )
    return
  end

  log_fix_and_format(string.format("apply command client=%s status=skipped", client.name))
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
  local diagnostics = get_client_diagnostics(bufnr, client)
  ---@type lsp.CodeActionParams
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = make_full_buffer_range(bufnr),
    context = {
      diagnostics = diagnostics,
      only = { "source.fixAll" },
    },
  }

  log_fix_and_format(
    string.format(
      "client fix start client=%s diagnostics=%d only=%s range_start=%d:%d range_end=%d:%d uri=%s",
      client.name,
      #diagnostics,
      summarize_list(params.context.only),
      params.range.start.line,
      params.range.start.character,
      params.range["end"].line,
      params.range["end"].character,
      tostring(params.textDocument.uri)
    )
  )

  local response = client:request_sync("textDocument/codeAction", params, timeout_ms, bufnr)
  if not response then
    log_fix_and_format(string.format("codeAction response client=%s status=timeout", client.name))
    return false, client.name .. " fixer request timed out"
  end

  if type(response.err) == "table" then
    log_fix_and_format(
      string.format(
        "codeAction response client=%s status=error message=%s",
        client.name,
        tostring(response.err.message or "unknown error")
      )
    )
    return false, client.name .. " fixer request failed: " .. (response.err.message or "unknown error")
  end

  if response.result == nil or response.result == vim.NIL then
    log_fix_and_format(string.format("codeAction response client=%s status=empty result=nil", client.name))
    return true
  end

  if type(response.result) ~= "table" then
    log_fix_and_format(
      string.format("codeAction response client=%s status=invalid result_type=%s", client.name, type(response.result))
    )
    return false, client.name .. " fixer returned an invalid code action response"
  end

  log_fix_and_format(
    string.format("codeAction response client=%s status=ok result_count=%d", client.name, #response.result)
  )

  if vim.tbl_isempty(response.result) then
    return true
  end

  local action = select_fix_action(response.result)
  if not action then
    log_fix_and_format(string.format("codeAction selection client=%s status=no_fix_all_action", client.name))
    return true
  end

  log_fix_and_format(
    string.format("codeAction selection client=%s status=selected %s", client.name, summarize_code_action(action))
  )

  local selected_action_dump = log_ts_ls_action_dump(client, "selected", action)

  local resolved_action = resolve_code_action(client, action, bufnr, timeout_ms)
  local resolved_action_dump = log_ts_ls_action_dump(client, "resolved", resolved_action)

  if dumps_differ(selected_action_dump, resolved_action_dump) then
    log_fix_and_format(string.format("codeAction debug client=%s stage=resolved_changed true", client.name))
  end

  local ok, err = pcall(function()
    apply_code_action(client, resolved_action, bufnr)
  end)

  if not ok then
    log_fix_and_format(string.format("apply failure client=%s error=%s", client.name, tostring(err)))
    return false, client.name .. " fixer failed: " .. err
  end

  log_fix_and_format(string.format("client fix complete client=%s status=success", client.name))

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
  local discovered_clients = vim.lsp.get_clients { bufnr = bufnr }

  log_fix_and_format(
    string.format(
      "fix_and_format entry bufnr=%d filetype=%s total_clients=%d log_file=%s",
      bufnr,
      tostring(filetype),
      #discovered_clients,
      log_file_path
    )
  )

  if vim.tbl_isempty(discovered_clients) then
    log_fix_and_format "fix_and_format clients none"
  else
    for _, client in ipairs(discovered_clients) do
      log_fix_and_format("fix_and_format client " .. summarize_client(client, bufnr))
    end
  end

  if js_fixable_filetypes[filetype] then
    local fix_clients = get_fix_clients(bufnr)
    log_fix_and_format(string.format("fix_and_format eligible_fix_clients=%d", #fix_clients))

    for _, client in ipairs(fix_clients) do
      local ok, err = run_client_fix(client, bufnr)
      if not ok then
        notify_fix_failure(err)
        log_fix_and_format(string.format("fix_and_format notify_failure client=%s message=%s", client.name, err))
      end
    end
  else
    log_fix_and_format(string.format("fix_and_format skip_fix_all filetype=%s", tostring(filetype)))
  end

  log_fix_and_format(string.format("conform.format start bufnr=%d lsp_format=fallback async=false", bufnr))
  local conform_ok, conform_err = pcall(function()
    require("conform").format {
      async = false,
      bufnr = bufnr,
      lsp_format = "fallback",
    }
  end)

  if not conform_ok then
    log_fix_and_format(string.format("conform.format failure bufnr=%d error=%s", bufnr, tostring(conform_err)))
    error(conform_err)
  end

  log_fix_and_format(string.format("conform.format complete bufnr=%d", bufnr))
end

M.log_file_path = log_file_path

return M
