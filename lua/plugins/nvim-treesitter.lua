return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  opts_extend = { "ensure_installed" },
  init = function()
    local treesitter_plugin = require("lazy.core.config").plugins["nvim-treesitter"]
    local runtime_dir = treesitter_plugin and (treesitter_plugin.dir .. "/runtime")

    if runtime_dir and vim.uv.fs_stat(runtime_dir) then
      vim.opt.rtp:append(runtime_dir)
    end

    vim.treesitter.language.register("markdown", "mdx")
  end,
  opts = {
    ensure_installed = {
      "astro",
      "css",
      "graphql",
      "javascript",
      "lua",
      "markdown",
      "markdown_inline",
      "tsx",
      "typescript",
    },
  },
  keys = {
    {
      "<leader>tsp",
      "<cmd>InspectTree<CR>",
      desc = "Inspect Treesitter Tree",
    },
  },
}
