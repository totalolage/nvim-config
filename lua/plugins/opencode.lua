local opencode_cmd = "opencode --port"
local opencode_terminal_opts = {
  win = {
    position = "float",
    width = 0.85,
    height = 0.85,
    border = "rounded",
    enter = true,
  },
}

return {
  "nickjvandyke/opencode.nvim",

  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },

  config = function()
    require("opencode.config").opts.server.start = function()
      require("snacks.terminal").open(opencode_cmd, opencode_terminal_opts)
    end
  end,

  keys = {
    {
      "<A-a>",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode…",
    },
    {
      "<A-x>",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Execute opencode action…",
    },
    {
      "<A-o>",
      function()
        require("snacks.terminal").toggle(opencode_cmd, opencode_terminal_opts)
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },
    {
      "go",
      function()
        return require("opencode").operator "@this "
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Add range to opencode",
    },
    {
      "gO",
      function()
        return require("opencode").operator "@this " .. "_"
      end,
      mode = "n",
      expr = true,
      desc = "Add line to opencode",
    },
    {
      "<C-S-u>",
      function()
        require("opencode").command "session.half.page.up"
      end,
      desc = "Scroll opencode up",
    },
    {
      "<C-S-d>",
      function()
        require("opencode").command "session.half.page.down"
      end,
      desc = "Scroll opencode down",
    },

    -- override increment/decrement
    { "+", "<A-a>", mode = "n", noremap = true, desc = "Increment under cursor" },
    { "-", "<A-x>", mode = "n", noremap = true, desc = "Decrement under cursor" },
  },
}
