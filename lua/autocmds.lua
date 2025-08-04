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
    -- Use pcall to safely get clients in case LSP isn't ready
    local ok, clients = pcall(vim.lsp.get_clients, { name = "biome" })
    if not ok or #clients == 0 then
      return
    end
    
    -- Track buffers that had Biome attached
    local affected_buffers = {}
    for _, client in ipairs(clients) do
      for buf, _ in pairs(client.attached_buffers or {}) do
        table.insert(affected_buffers, buf)
      end
    end
    
    -- Stop all Biome clients
    for _, client in ipairs(clients) do
      -- Use pcall to handle any errors during stop
      pcall(function() client.stop() end)
    end
    
    -- Only restart if we had affected buffers
    if #affected_buffers > 0 then
      vim.defer_fn(function()
        -- Restart for one of the affected buffers
        for _, buf in ipairs(affected_buffers) do
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_call(buf, function()
              -- Use silent to avoid error messages
              vim.cmd("silent! LspStart biome")
            end)
            return -- Only need to start once
          end
        end
      end, 500) -- Increased delay to ensure clean shutdown
    end
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
