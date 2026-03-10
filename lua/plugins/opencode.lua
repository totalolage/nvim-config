return {
  "nickjvandyke/opencode.nvim",

  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },

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
        require("opencode").toggle()
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
