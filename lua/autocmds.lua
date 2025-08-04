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
vim.api.nvim_create_autocmd({"DirChanged", "VimEnter"}, {
  pattern = "*",
  callback = function()
    local cwd = vim.fn.getcwd()
    local nvmrc_path = cwd .. "/.nvmrc"
    
    -- Check if .nvmrc exists in current directory
    if vim.fn.filereadable(nvmrc_path) == 1 then
      -- Source zshenv and use fnm
      vim.fn.system("source ~/.zshenv && fnm use --silent-if-unchanged")
    end
  end,
})

-- Restart Biome LSP when directory changes
-- This ensures the correct local/global binary is used when switching between projects
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    local clients = vim.lsp.get_clients({ name = "biome" })
    if #clients == 0 then
      return
    end
    
    -- Stop all Biome clients to force re-evaluation of which binary to use
    for _, client in ipairs(clients) do
      client.stop(true)
    end
    
    -- Restart LSP for JavaScript/TypeScript buffers after a short delay
    vim.defer_fn(function()
      local ft_patterns = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" }
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype then
          for _, pattern in ipairs(ft_patterns) do
            if vim.bo[buf].filetype == pattern then
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("LspStart biome")
              end)
              return -- Only need to start once
            end
          end
        end
      end
    end, 200)
  end,
  desc = "Restart Biome LSP to use correct binary version"
})

-- Disable Biome LSP formatting when Prettier is present
-- This prevents conflicts and lets conform.nvim handle formatter selection
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "biome" then
      return
    end
    
    local biome_util = require "utils.biome"
    
    -- Disable LSP formatting if we shouldn't use Biome as formatter
    -- This lets conform.nvim handle all formatting decisions
    if not biome_util.should_use_biome_formatter() then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
  desc = "Configure Biome LSP formatting capabilities"
})
