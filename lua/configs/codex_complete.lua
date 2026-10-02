local M = {}

-- codex-complete has no partial-accept API at its pinned revision.
-- Rebase its existing cache after accepting a word, without requesting a model.
function M.accept_word()
  local plugin = require "codex_complete"
  local ui = require "codex_complete.ui"
  local context = require "codex_complete.context"
  local related = require "codex_complete.related"
  local current = ui.current()
  if not current or current.context.kind == "comment" then
    return false
  end
  if not context.is_current(current.context) or not related.valid(current.context) then
    plugin.dismiss()
    return false
  end

  local completion = current.completion
  -- Match Supermaven's word acceptance, including leading whitespace/punctuation.
  local fragment = completion:match "^.-[%a%d_]+" or completion
  if fragment == completion then
    return plugin.accept()
  end

  local dependencies = vim.deepcopy(current.context.dependencies or {})
  local _, paired = context.reconcile_completion(current.context, completion)
  current.completion = fragment
  -- A partial word before an auto-paired closer must leave that closer intact.
  current.replace_length = paired and paired.closer_index <= #fragment and paired.replace_length or 0
  if not plugin.accept() then
    return false
  end

  local state = plugin._state
  local captured = context.capture(current.context.bufnr, current.context.winid, state.config)
  for path, version in pairs(dependencies) do
    if version:match "^buffer:(%d+):" == tostring(captured.bufnr) then
      dependencies[path] = "buffer:" .. captured.bufnr .. ":" .. captured.changedtick
    end
  end
  captured.dependencies = dependencies
  local remainder, delimiter = context.reconcile_completion(captured, completion:sub(#fragment + 1))
  if remainder ~= "" then
    state.cache[captured.bufnr] = { context = captured, completion = remainder }
    ui.show(captured, remainder, { paired_delimiter = delimiter, highlights = state.config.highlights })
  end
  return true
end

function M.map_accept_word()
  vim.keymap.set("i", "<C-j>", function()
    if not M.accept_word() then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-j>", true, false, true), "in", false)
    end
  end, { silent = true, desc = "Accept next Codex completion word" })
end

function M.setup(opts)
  require("codex_complete").setup(opts)
  M.map_accept_word()
end

return M
