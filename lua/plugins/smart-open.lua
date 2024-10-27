return {
  enabled = false,
  "danielfalk/smart-open.nvim",
  branch = "0.3.x",
  dependencies = {
    "totalolage/sqlite.lua",
    -- Only required if using match_algorithm fzf
    -- "nvim-telescope/telescope-fzf-native.nvim", build = "make",
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    "nvim-telescope/telescope-fzy-native.nvim",
  },
  config = function()
    require("telescope").load_extension "smart_open"
  end,
  keys = {
    {
      "<leader><leader>",
      function()
        require("telescope").extensions.smart_open.smart_open()
      end,
      noremap = true,
      silent = true,
      desc = "Smart open",
    },
  },
}
