local M = {}

M.general = {
  n = {
    -- Path yanks
    ["ypl "] = {
      "<cmd>let @+ = expand('%:t')<CR>",
      "Yank Filename",
    },
    ["ypnl"] = {
      "<cmd>let @+ = join([expand('%:t'), line('.')], ':')<CR>",
      "Yank Filename with line number",
    },
    ["yplc"] = {
      "<cmd>let @+ = join([expand('%:t'), line('.'), col('.')], ':')<CR>",
      "Yank Filename with line and column number",
    },
    ["ypr "] = {
      "<cmd>let @+ = expand('%:~:.')<CR>",
      "Yank Path Relative",
    },
    ["yprl"] = {
      "<cmd>let @+ = join([expand('%:~:.'), line('.')], ':')<CR>",
      "Yank Path Relative with line number",
    },
    ["yprc"] = {
      "<cmd>let @+ = join([expand('%:~:.'), line('.'), col('.')], ':')<CR>",
      "Yank Path Relative with line and column number",
    },
    ["ypa "] = {
      "<cmd>let @+ = expand('%:p')<CR>",
      "Yank Path Absolute",
    },
    ["ypal"] = {
      "<cmd>let @+ = join([expand('%:p'), line('.')], ':')<CR>",
      "Yank Path Absolute with line number",
    },
    ["ypac"] = {
      "<cmd>let @+ = join([expand('%:p'), line('.'), col('.')], ':')<CR>",
      "Yank Path Absolute with line and column number",
    },

    -- Diagnostics
    ["g["] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "Jump to previous issue",
    },
    ["g]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "Jump to next issue",
    },

    -- File opening
    ["<leader>of"] = {
      function()
        local clipboard = vim.fn.getreg "+"

        local filename_dirty, line_dirty, column_dirty

        -- src/views/DocumentCreate/DocumentFill/index.tsx:29
        -- Clipboard path should be in format `file[:line[:column]]`
        if not filename_dirty then
          filename_dirty, line_dirty, column_dirty = clipboard:match "^(.+):([1-9]%d*):([1-9]%d*)$"
        end
        if not filename_dirty then
          filename_dirty, line_dirty = clipboard:match "^(.+):([1-9]%d*)$"
        end

        -- Clipboard can alternatively be in the format `file(line[,:]column)`
        if not filename_dirty then
          filename_dirty, line_dirty, column_dirty = clipboard:match "^(.+)%s*%(([1-9]%d*)[,:]([1-9]%d*)%)$"
        end

        -- If all else fails, just use the clipboard as the filename
        if not filename_dirty then
          filename_dirty = clipboard
        end

        local filename = vim.fn.expand(vim.fn.fnameescape(filename_dirty))
        if not vim.fn.filereadable(filename) then
          vim.api.nvim_err_writeln("File does not exist: " .. filename)
          return
        end

        local line = tonumber(line_dirty) or 1
        local column = tonumber(column_dirty) or 1

        vim.cmd("e " .. filename)
        vim.fn.cursor(line, column)
      end,
      "Open last yanked file",
    },
  },
  v = {
    ["g["] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "Jump to previous issue",
    },
    ["g]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "Jump to next issue",
    },
  },
}

M.conform = {
  n = {
    ["<leader>fm"] = {
      function()
        require("conform").format { async = true }
      end,
      "Format current buffer",
    },
  },
}

-- -- Copilot
-- vim.api.nvim_set_keymap("i", "<c-Y>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

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
    ["<leader>tr"] = {
      "<cmd>Telescope resume<CR>",
      "Resume last telescope session",
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
    ["<leader>tr"] = {
      "<cmd>Telescope resume<CR>",
      "Resume last telescope session",
    },
  },
}

M.vimflog = {
  n = {
    ["<leader>gg"] = {
      "<cmd>Flog<CR>",
      "Open Git Graph",
    },
    ["<leader>gf"] = {
      "<cmd>Git fetch<CR>",
      "Fetch from remote",
    },
    ["<leader>gpd"] = {
      "<cmd>Git pull<CR>",
      "Pull from remote",
    },
    ["<leader>gpu"] = {
      "<cmd>Git push<CR>",
      "Push to remote",
    },
    ["<leader>gpf"] = {
      "<cmd>Git push --force-with-lease<CR>",
      "Force push to remote (with lease)",
    },
    ["<leader>gc"] = {
      "<cmd>Git commit<CR>",
      "Commit changes",
    },
    ["<leader>ga"] = {
      "<cmd>Git commit --amend<CR>",
      "Amend last commit",
    },
    ["<leader>ge"] = {
      "<cmd>Git commit --amend --no-edit<CR>",
      "Amend last commit without editing",
    },
  },
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

-- M.undotree = {
--   n = {
--     ["<leader>u"] = {
--       function()
--         require("undotree").toggle()
--       end,
--       "UndoTree toggle",
--     },
--   },
-- }

M.gitsigns = {
  plugin = true,
  n = {
    ["<leader>rb"] = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "Reset buffer",
    },
    ["<leader>sh"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage hunk",
   },
    ["<leader>uh"] = {
      -- "<cmd>Gitsigns undo_stage_hunk<CR>",
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo stage hunk",
    },
    ["<leader>sb"] = {
      -- "<cmd>Gitsigns stage_buffer<CR>",
      function()
        require("gitsigns").stage_buffer()
      end,
      "Stage buffer",
    },
    ["<leader>ub"] = {
      -- "<cmd>Gitsigns reset_buffer_index<CR>",
      function()
        require("gitsigns").reset_buffer_index()
      end,
      "Undo stage buffer",
    },
  },
}

return M
