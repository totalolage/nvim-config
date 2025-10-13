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

-- Update Kitty tab title with website-style format
vim.api.nvim_create_autocmd({"DirChanged", "BufEnter", "FocusGained", "VimEnter"}, {
  pattern = "*",
  callback = function()
    local title_parts = {}
    local command = "nvim"

    -- Check if we're in a git repo
    local gitdir = vim.fn.system("git rev-parse --git-dir 2>/dev/null"):gsub("\n", "")

    if gitdir ~= "" and not gitdir:match("^fatal:") then
      -- Check if we're in a bare repo or its subdirectory
      local is_bare = vim.fn.system("git rev-parse --is-bare-repository 2>/dev/null"):gsub("\n", "") == "true"

      if is_bare then
        local cwd = vim.fn.getcwd()
        local abs_gitdir = vim.fn.system("git rev-parse --absolute-git-dir 2>/dev/null"):gsub("\n", "")

        if cwd == abs_gitdir then
          -- We're in the root of a bare repo
          local project_root_dir = vim.fn.fnamemodify(cwd, ":t")
          table.insert(title_parts, project_root_dir)
          table.insert(title_parts, command)
        else
          -- We're in a subdirectory of a bare repo
          local current_dir = vim.fn.fnamemodify(cwd, ":t")
          local project_root_dir = vim.fn.fnamemodify(abs_gitdir, ":t")

          table.insert(title_parts, current_dir)
          table.insert(title_parts, project_root_dir)
          table.insert(title_parts, command)
        end
      else
        -- Try to get worktree path
        local worktree_path = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")

        if worktree_path ~= "" and not worktree_path:match("^fatal:") and gitdir:match("/worktrees/") then
          -- We're in a git worktree
          local worktree_dir = vim.fn.fnamemodify(worktree_path, ":t")

          -- Get project root dir (parent of worktrees)
          local project_root = vim.fn.fnamemodify(gitdir:match("(.*)/worktrees/"), ":t")

          table.insert(title_parts, worktree_dir)
          table.insert(title_parts, project_root)
          table.insert(title_parts, command)
        else
          -- Regular git repo (non-worktree)
          local current_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

          -- Get branch name
          local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")

          -- Get the default remote (first remote or upstream of current branch)
          local remote = vim.fn.system("git config branch." .. branch .. ".remote 2>/dev/null"):gsub("\n", "")
          if remote == "" then
            -- If current branch has no remote, get the first available remote
            remote = vim.fn.system("git remote 2>/dev/null | head -n1"):gsub("\n", "")
          end

          -- Get the main branch from remote/HEAD
          local main_branch = ""
          if remote ~= "" then
            main_branch = vim.fn.system("git symbolic-ref refs/remotes/" .. remote .. "/HEAD 2>/dev/null | sed 's@^refs/remotes/" .. remote .. "/@@'"):gsub("\n", "")
          end

          -- Fallback to checking for main or master if remote/HEAD is not set
          if main_branch == "" or main_branch:match("^fatal:") then
            local has_main = vim.fn.system("git rev-parse --verify --quiet refs/heads/main 2>/dev/null"):gsub("\n", "")
            if has_main ~= "" then
              main_branch = "main"
            else
              main_branch = "master"
            end
          end

          -- Only show branch if it's not the main branch
          if branch ~= "" and not branch:match("^fatal:") and branch ~= "HEAD" and branch ~= main_branch then
            table.insert(title_parts, string.format("%s(%s)", current_dir, branch))
          else
            table.insert(title_parts, current_dir)
          end

          table.insert(title_parts, command)
        end
      end
    else
      -- Not in a git repo
      local current_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      table.insert(title_parts, current_dir)
      table.insert(title_parts, command)
    end

    -- Join with pipe separator and send OSC escape sequence
    local title = table.concat(title_parts, " | ")
    local escape_seq = string.format("\027]0;%s\007", title)
    io.write(escape_seq)
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
