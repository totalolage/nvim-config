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
      "<leader>gmt",
      "<cmd>Git mergetool<CR>",
      desc = "Mergetool",
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
    },
    {
      "<leader>grc",
      "<cmd>Git rebase --continue<CR>",
      desc = "Continue rebase",
    },
    {
      "<leader>gra",
      "<cmd>Git rebase --abort<CR>",
      desc = "Abort rebase",
    },
    {
      "<leader>gbs",
      "<cmd>Git bisect start<CR>",
      desc = "Bisect start",
    },
    {
      "<leader>gbg",
      "<cmd>Git bisect good<CR>",
      desc = "Bisect good",
    },
    {
      "<leader>gbb",
      "<cmd>Git bisect bad<CR>",
      desc = "Bisect bad",
    },
    {
      "<leader>gbr",
      "<cmd>Git bisect reset<CR>",
      desc = "Bisect reset",
    },
    {
      "<leader>gbp",
      "<cmd>Git bisect visualize<CR>",
      desc = "Bisect visualize",
    },
  },
}
