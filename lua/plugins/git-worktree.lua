return {
  "totalolage/git-worktree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    change_directory_command = "lua vim.api.nvim_set_current_dir",
  },
  config = function(_, opts)
    local Worktree = require("git-worktree")

    local function run_worktree_command(operation, command_env_var, metadata)
      local cmd = os.getenv(command_env_var)
      if not cmd or cmd == "" then
        return
      end

      metadata = metadata or {}
      vim.system({ "sh", "-c", cmd }, {
        env = {
          GIT_WORKTREE_PATH = metadata.path or "",
          GIT_WORKTREE_PREV_PATH = metadata.prev_path or "",
          GIT_WORKTREE_BRANCH = metadata.branch or "",
          GIT_WORKTREE_UPSTREAM = metadata.upstream or "",
        },
      }, function(result)
        local signal = result.signal
        local failed = result.code ~= 0 or (signal ~= nil and signal ~= 0)
        if not failed then
          return
        end

        local stderr = result.stderr and vim.trim(result.stderr) or ""
        local message = string.format("git-worktree %s hook failed: %s (exit=%d", operation, command_env_var, result.code)
        if signal ~= nil and signal ~= 0 then
          message = message .. string.format(", signal=%d", signal)
        end
        message = message .. ")"
        if stderr ~= "" then
          message = message .. "\n" .. stderr
        end

        vim.notify(message, vim.log.levels.WARN)
      end)
    end

    Worktree.setup(opts)

    require("telescope").load_extension "git_worktree"

    -- Hooks
    Worktree.on_tree_change(function(op, metadata)
      if op == Worktree.Operations.Switch then
        run_worktree_command("switch", "GIT_WORKTREE_ON_SWITCH", metadata)
      elseif op == Worktree.Operations.Create then
        run_worktree_command("create", "GIT_WORKTREE_ON_CREATE", metadata)
      elseif op == Worktree.Operations.Delete then
        run_worktree_command("delete", "GIT_WORKTREE_ON_DELETE", metadata)
      end
    end)
  end,
  keys = {
    {
      "<leader>gw",
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      desc = "List git worktrees",
    },
    {
      "<leader>gW",
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      desc = "Create git worktree",
    },
    -- {
    --   "<leader>gq",
    --   function()
    --     -- If we are not in a worktree, print an error and exits
    --     assert(
    --       vim.system({ "git", "-C", vim.fn.getcwd(), "rev-parse", "--is-inside-work-tree" }):wait().stdout == "true\n",
    --       "Not in a git worktree"
    --     )
    --     local git_root = vim.system({ "git", "-C", vim.fn.getcwd(), "rev-parse", "--show-toplevel" }):wait().stdout
    --     vim.cmd("cd " .. git_root)
    --   end,
    --   desc = "Quit out of git worktree (and go to repo root)",
    -- },
  },
}
