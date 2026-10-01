return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  main = "nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
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
  config = function(_, opts)
    local treesitter = require "nvim-treesitter"
    treesitter.setup { install_dir = vim.fn.stdpath("data") .. "/site" }
    treesitter.install(opts.ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        local ok, available = pcall(vim.treesitter.language.add, lang or "")
        if lang and ok and available then
          vim.treesitter.start(args.buf, lang)
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>tsp",
      "<cmd>InspectTree<CR>",
      desc = "Inspect Treesitter Tree",
    },
  },
}
