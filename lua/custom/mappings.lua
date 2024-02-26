local M = {}

M.general = {
  n = {
    ["<leader>fm"] = {
      function()
        require("conform").format({async = true})
      end,
      "Format current buffer",
    },
    ["ypn"] = {
      "<cmd>let @+ = expand('%:t')<CR>",
      "Yank Filename",
    },
    ["ypr"] = {
      "<cmd>let @+ = expand('%:~:.')<CR>",
      "Yank Path Relative",
    },
    ["ypf"] = {
      "<cmd>let @+ = expand('%:p')<CR>",
      "Yank Path Full" ,
    },
    ["g["] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "Jump to previous issue"
    },
    ["g]"] = {
      function ()
        vim.diagnostic.goto_next()
      end,
      "Jump to next issue"
    }
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
    -- ["<leader>fm"] = {
    --   function()
    --     vim.lsp.buf.format { async = true, timeout = 5000 }
    --   end,
    --   "LSP formatting",
    -- },
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

-- M.minimap = {
--   n = {
--     ["<leader>mm"] = {
--       function()
--         MiniMap.toggle()
--       end,
--       "Toggle minimap",
--     },
--   },
-- }

M.vimflog = {
  n = {
    ["<leader>gg"] = {
      "<cmd>Flog -all<CR>",
      "Open Git Graph"
    }
  }
}

M.markdownPreview = {
  n = {
    ["<leader>mp"] = {
      "<cmd>MarkdownPreview<CR>",
      "Preview markdown",
    },
  },
}

-- M.text_case = {
--   n = {
--     ["<leader>ac"] = {
--       '<cmd>TextCaseOpenTelescope<CR>',
--       "Amend case",
--     },
--   },
--   v = {
--     ["<leader>ac"] = {
--       '<cmd>TextCaseOpenTelescope<CR>',
--       "Amend case",
--     },
--   },
-- }

return M
