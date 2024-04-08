local M = {}

M.general = {
  n = {
    ["ypn "] = {
      "<cmd>let @+ = expand('%:t')<CR>",
      "Yank Filename",
    },
    ["ypnn"] = {
      "<cmd>let @+ = join([expand('%:t'), line('.')], ':')<CR>",
      "Yank Filename with line number",
    },
    ["ypnc"] = {
      "<cmd>let @+ = join([expand('%:t'), line('.'), col('.')], ':')<CR>",
      "Yank Filename with line and column number",
    },
    ["ypr "] = {
      "<cmd>let @+ = expand('%:~:.')<CR>",
      "Yank Path Relative",
    },
    ["yprn"] = {
      "<cmd>let @+ = join([expand('%:~:.'), line('.')], ':')<CR>",
      "Yank Path Relative with line number",
    },
    ["yprc"] = {
      "<cmd>let @+ = join([expand('%:~:.'), line('.'), col('.')], ':')<CR>",
      "Yank Path Relative with line and column number",
    },
    ["ypf "] = {
      "<cmd>let @+ = expand('%:p')<CR>",
      "Yank Path Full" ,
    },
    ["ypfn"] = {
      "<cmd>let @+ = join([expand('%:p'), line('.')], ':')<CR>",
      "Yank Path Full with line number",
    },
    ["ypfc"] = {
      "<cmd>let @+ = join([expand('%:p'), line('.'), col('.')], ':')<CR>",
      "Yank Path Full with line and column number",
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
    },
    ["<leader>of"] = {
      function ()
        local clipboard = vim.fn.getreg("+")

        local filename_dirty, line_dirty, column_dirty

        -- Clipboard path should be in format `file[:line[:column]]`
        if not filename_dirty then
          filename_dirty, line_dirty, column_dirty = clipboard:match("(.+):(%d*):(%d*)")
        end

        -- Clipboard can alternatively be in the format `file(line,column)`
        if not filename_dirty then
          filename_dirty, line_dirty, column_dirty = clipboard:match("(.+)%((%d+),(%d+)%)")
        end

        -- If all else fails, just use the clipboard as the filename
        if not filename_dirty then
          filename_dirty = clipboard
        end

        local filename = vim.fn.expand(vim.fn.fnameescape(filename_dirty))
        if not vim.fn.filereadable(filename) then
          vim.api.nvim_err_writeln("File does not exist: " .. filename)
        end

        local line = tonumber(line_dirty) or 1
        local column = tonumber(column_dirty) or 1

        vim.cmd("e " .. filename)
        vim.fn.cursor(line, column)
      end,
      "Open last yanked file",
    }
  }
}

M.conform = {
  n = {
    ["<leader>fm"] = {
      function()
        require("conform").format({ async = true })
      end,
      "Format current buffer",
    },
  },
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

M.textCase = {
  v = {
    ["<leader>ac."] = {
      "<cmd>TextCaseOpenTelescope<CR>",
      "Text Case Telescope",
    },
  },
}

return M
