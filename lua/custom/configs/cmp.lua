local cmp = require "cmp"
local nvchad_opts = require "plugins.configs.cmp"

local opts = vim.tbl_deep_extend("force", nvchad_opts, {
  -- sources = table.insert(nvchad_opts.sources, 1, { name = "cmp_ai" }),
  experimental = {
    ghost_text = true,
  },
  mapping = {
    ['<C-x>'] = cmp.mapping(
      cmp.mapping.complete({
        config = {
          sources = cmp.config.sources({
            { name = 'cmp_ai' },
          }),
        },
      }),
      { 'i' }
    ),
  },
})

return opts
