return {
  "nvimtools/none-ls.nvim",
  event = "VeryLazy",
  config = function(_, default_opts)
    local null_ls = require "null-ls"

    null_ls.setup(vim.tbl_extend("force", default_opts, {
      sources = {
        null_ls.builtins.formatting.prettierd,
      },
      -- on_attach = function (client, bufnr)
      --   if client.supports_method("textDocument/formatting") then
      --     vim.api.nvim_clear_autocmds({
      --       group = augroup,
      --       buffer = bufnr,
      --     })
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = augroup,
      --       buffer = bufnr,
      --       callback = function ()
      --         vim.lsp.buf.format({ bufnr = bufnr })
      --       end,
      --     })
      --   end
      -- end,
    }))
  end,
}
