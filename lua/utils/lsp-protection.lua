-- LSP client protection to prevent errors during shutdown/restart
local M = {}

-- Store original vim.lsp functions
local original_handlers = {}

-- Initialize protection for LSP handlers
function M.init()
  -- Protect common LSP handlers that might fail during client shutdown
  local handlers_to_protect = {
    "textDocument/publishDiagnostics",
    "$/progress",
    "workspace/configuration",
    "window/showMessage",
    "window/logMessage",
  }
  
  for _, handler_name in ipairs(handlers_to_protect) do
    local original = vim.lsp.handlers[handler_name]
    if original and not original_handlers[handler_name] then
      original_handlers[handler_name] = original
      vim.lsp.handlers[handler_name] = function(err, result, ctx, config)
        -- Check if client exists and is valid
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then
          -- Client is gone, skip handling
          return
        end
        
        -- Call original handler with protection
        local ok, handler_err = pcall(original_handlers[handler_name], err, result, ctx, config)
        if not ok then
          -- Log error but don't crash
          vim.schedule(function()
            vim.notify(
              string.format("LSP handler error for %s: %s", handler_name, handler_err),
              vim.log.levels.DEBUG
            )
          end)
        end
      end
    end
  end
  
  -- Override vim.lsp.buf_request_all to add protection
  local original_buf_request_all = vim.lsp.buf_request_all
  vim.lsp.buf_request_all = function(bufnr, method, params, callback)
    return original_buf_request_all(bufnr, method, params, function(results, ctx)
      -- Filter out nil clients
      local filtered_results = {}
      for client_id, result in pairs(results or {}) do
        local client = vim.lsp.get_client_by_id(client_id)
        if client then
          filtered_results[client_id] = result
        end
      end
      
      if callback then
        -- Pass both results and context to the callback
        callback(filtered_results, ctx)
      end
    end)
  end
end

-- Protect individual client on attach
function M.protect_client(client)
  if not client then return end
  
  -- Store original methods
  local original_request = client.request
  local original_request_sync = client.request_sync
  
  -- Wrap request method
  if original_request then
    client.request = function(method, params, handler, bufnr)
      -- Check if client is still valid
      if not client.id or not vim.lsp.get_client_by_id(client.id) then
        return nil
      end
      
      -- Try to call original request
      local ok, request_id = pcall(original_request, method, params, handler, bufnr)
      if ok then
        return request_id
      else
        -- Log error but don't crash
        vim.schedule(function()
          vim.notify(
            string.format("LSP request error for %s: %s", client.name or "unknown", request_id),
            vim.log.levels.DEBUG
          )
        end)
        return nil
      end
    end
  end
  
  -- Wrap request_sync method
  if original_request_sync then
    client.request_sync = function(method, params, timeout_ms, bufnr)
      -- Check if client is still valid
      if not client.id or not vim.lsp.get_client_by_id(client.id) then
        return nil
      end
      
      -- Try to call original request_sync
      local ok, result = pcall(original_request_sync, method, params, timeout_ms, bufnr)
      if ok then
        return result
      else
        return nil
      end
    end
  end
end

return M