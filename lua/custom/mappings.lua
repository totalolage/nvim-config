local M = {}

M.general = {
  n = {
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },
    ["<leader>yn"] = {
      "<cmd>let @+ = expand('%:t')<CR>",
      "Yank Filename",
    },
    ["<leader>yp"] = {
      "<cmd>let @+ = expand('%:~:.')<CR>",
      "Yank Relative Path",
    },
    ["<leader>yf"] = {
      "<cmd>let @+ = expand('%:p')<CR>",
      "Yank Full Path",
    },
  }
}

-- Copilot
vim.api.nvim_set_keymap("i", "<D-Enter>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

M.telescope = {
  n = {
    ["<leader>fe"] = {
      function()
        require("telescope.builtin").grep_string()
      end,
      "Find word",
    },
    ["<leader>fr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "Find references",
    },
    ["<leader>fd"] = {
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      "Find definitions",
    },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true, timeout = 5000 }
      end,
      "LSP formatting",
    },
  },
  v = {
    ["<leader>fe"] = {
      function()
        require("telescope.builtin").grep_string()
      end,
      "Find word",
    },
    ["<leader>fr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "Find references",
    },
    ["<leader>fd"] = {
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      "Find definitions",
    },
  },
}

M.minimap = {
  n = {
    ["<leader>mm"] = {
      function()
        MiniMap.toggle()
      end,
      "Toggle minimap",
    },
  },
}

return M
