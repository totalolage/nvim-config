local M = {}

function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  require("conform").format {
    async = false,
    bufnr = bufnr,
    lsp_format = "fallback",
  }
end

return M
