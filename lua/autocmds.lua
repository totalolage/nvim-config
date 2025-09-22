require "nvchad.autocmds"

-- CD to directory in which nvim is opened
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand "%:p:h")
  end,
})

-- Kitty padding in intergrated terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.system {
      "kitty",
      "@",
      "set-spacing",
      "padding=0",
      "margin=0",
    }
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function()
    vim.system {
      "kitty",
      "@",
      "padding=default",
      "margin=default",
    }
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {
      higroup = (vim.fn.hlexists "HighlightedyankRegion" > 0 and "HighlightedyankRegion" or "IncSearch"),
      timeout = 300,
    }
  end,
})

-- Fold diff views
vim.api.nvim_create_autocmd("FileType", {
  pattern = "git",
  callback = function()
    vim.opt_local.foldmethod = "syntax"
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- fnm integration - use correct node version when changing directories
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  pattern = "*",
  callback = function()
    local cwd = vim.fn.getcwd()
    local nvmrc_path = cwd .. "/.nvmrc"

    -- Check if .nvmrc exists in current directory
    if vim.fn.filereadable(nvmrc_path) == 1 then
      -- Source zshenv and use fnm
      vim.fn.system "source ~/.zshenv && fnm use --silent-if-unchanged"
    end
  end,
})

-- Handle Biome LSP formatting based on project configuration
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- For Biome, check if we should disable formatting
    if client.name == "biome" then
      local root_dir = vim.fn.getcwd()
      local has_prettier = false

      -- Check for Prettier config
      local prettier_configs = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.js",
        ".prettierrc.cjs",
        "prettier.config.js",
        "prettier.config.cjs",
      }
      for _, config in ipairs(prettier_configs) do
        if vim.fn.filereadable(root_dir .. "/" .. config) == 1 then
          has_prettier = true
          break
        end
      end

      -- If project has Prettier config, disable Biome formatting to let conform.nvim decide
      if has_prettier then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end
  end,
})
