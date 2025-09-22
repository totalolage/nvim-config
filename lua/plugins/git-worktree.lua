return {
  "totalolage/git-worktree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    change_directory_command = "lua vim.api.nvim_set_current_dir",
    -- change_directory_command = "lua vim.api.nvim_set_current_dir",
    update_on_change_command = "!fnm use",
  },
  config = function(_, opts)
    local Worktree = require "git-worktree"
    Worktree.setup(opts)
    require("telescope").load_extension "git_worktree"

    -- Function to update Kitty tab title with branch name
    local function update_kitty_tab_title()
      -- Get current git branch
      local handle = io.popen "git rev-parse --abbrev-ref HEAD 2>/dev/null"
      if handle then
        local branch = handle:read "*l"
        handle:close()

        if branch and branch ~= "" then
          -- Get the directory name
          local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

          -- Send OSC escape sequence to set tab title
          -- OSC 0 sets both window and tab title
          local title = string.format("%s", dir)
          local escape_seq = string.format("\027]0;%s\007", title)
          io.write(escape_seq)
        end
      end
    end

    -- Hook into worktree changes
    Worktree.on_tree_change(function(op, metadata)
      if op == Worktree.Operations.Switch then
        -- Update tab title when switching worktrees
        vim.defer_fn(update_kitty_tab_title, 100)
      end
    end)

    -- Also update on initial load
    vim.defer_fn(update_kitty_tab_title, 100)
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
