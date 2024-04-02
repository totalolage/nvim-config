local opts = {
  prefix = "<leader>ac",
}

require("textcase").setup(opts)
require("telescope").load_extension "textcase"
