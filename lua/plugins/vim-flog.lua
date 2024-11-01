return {
  "rbong/vim-flog",
  lazy = true,
  cmd = { "Flog", "Flogsplit", "Floggit" },
  dependencies = {
    "tpope/vim-fugitive",
  },
  keys = {
    {
      "<leader>gg",
      "<cmd>Flog<CR>",
      desc = "Open Git Graph",
    },
    {
      "<leader>gf",
      "<cmd>Git fetch<CR>",
      desc = "Fetch from remote",
    },
    {
      "<leader>gpd",
      "<cmd>Git pull<CR>",
      desc = "Pull from remote",
    },
    {
      "<leader>gpu",
      "<cmd>Git push<CR>",
      desc = "Push to remote",
    },
    {
      "<leader>gpf",
      "<cmd>Git push --force-with-lease<CR>",
      desc = "Force push to remote (with lease)",
    },
    {
      "<leader>gc",
      "<cmd>Git commit<CR>",
      desc = "Commit changes",
    },
    {
      "<leader>ga",
      "<cmd>Git commit --amend<CR>",
      desc = "Amend last commit",
    },
    {
      "<leader>ge",
      "<cmd>Git commit --amend --no-edit<CR>",
      desc = "Amend last commit without editing",
    },
    {
      "<leader>gmc",
      "<cmd>Git merge --continue<CR>",
      desc = "Continue merge",
    },
    {
      "<leader>gma",
      "<cmd>Git merge --abort<CR>",
      desc = "Abort merge",
    }
  },
}
