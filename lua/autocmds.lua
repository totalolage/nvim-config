require "nvchad.autocmds"

-- CD to directory in which nvim is opened
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand "%:p:h")
  end,
})

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
