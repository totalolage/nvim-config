return {
  "totalolage/git-worktree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    change_directory_command = "lua vim.api.nvim_set_current_dir",
    -- change_directory_command = "lua vim.api.nvim_set_current_dir",
    update_on_change_command = "!fnm use"
  },
  setup = function(_, opts)
    require("git-worktree").setup(opts)
    require("telescope").load_extension "git_worktree"
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
