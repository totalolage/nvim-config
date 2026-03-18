return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = function(_, opts)
    -- Extend existing options
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      mappings = {
        n = {
          ["<Up>"] = false,
          ["<Down>"] = false,
        },
      },
    })

    -- Add notify extension config
    opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
      notify = {
        -- Telescope notify extension config
      },
    })

    return opts
  end,
  config = function(_, opts)
    -- Ensure NvChad's base46 Telescope highlights are applied even though
    -- we override the upstream NvChad telescope config.
    local function load_base46_cache(cache_name)
      local cache_dir = vim.g.base46_cache
      if type(cache_dir) ~= "string" or cache_dir == "" then
        return
      end

      local cache_path = cache_dir .. cache_name
      local uv = vim.uv or vim.loop
      if not (uv and type(uv.fs_stat) == "function" and uv.fs_stat(cache_path)) then
        vim.notify(("base46 cache missing (%s); continuing without it"):format(cache_path), vim.log.levels.WARN)
        return
      end

      local ok, err = pcall(dofile, cache_path)
      if not ok then
        vim.notify(
          ("failed to load base46 cache (%s); continuing without it: %s"):format(cache_path, tostring(err)),
          vim.log.levels.WARN
        )
        return
      end
    end

    load_base46_cache "telescope"

    local telescope = require "telescope"
    telescope.setup(opts)

    -- Load the notify extension
    telescope.load_extension "notify"
  end,
  keys = {
    {
      "<leader>fe",
      "<cmd>Telescope grep_string<CR>",
      desc = "Find word",
      mode = { "n", "v" },
    },
    {
      "<leader>fr",
      "<cmd>Telescope lsp_references<CR>",
      desc = "Find references",
    },
    {
      "<leader>fd",
      "<cmd>Telescope lsp_definitions<CR>",
      desc = "Find definitions",
    },
    {
      "<leader>te",
      "<cmd>Telescope resume<CR>",
      desc = "Resume last telescope session",
    },
    {
      "<leader>fn",
      "<cmd>Telescope notify<CR>",
      desc = "Find notifications",
    },
  },
}
