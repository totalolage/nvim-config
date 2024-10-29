local duration = 100

return {
  "karb94/neoscroll.nvim",
  opts = {
    easing = "sine",
    mappings = {}, -- disable default mappings
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
  end,
  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").ctrl_u { duration = duration }
      end,
      desc = "Scroll up",
      mode = { 'n', 'v', 'x' },
    },
    {
      "<C-d>",
      function()
        require("neoscroll").ctrl_d { duration = duration }
      end,
      desc = "Scroll down",
      mode = { 'n', 'v', 'x' },
    },
    {
      "<C-b>",
      function()
        require("neoscroll").ctrl_b { duration = duration }
      end,
      desc = "Cursor to top",
      mode = { 'n', 'v', 'x' },
    },
    {
      "<C-f>",
      function()
        require("neoscroll").ctrl_f { duration = duration }
      end,
      desc = "Cursor to bottom",
      mode = { 'n', 'v', 'x' },
    },
    {
      "<C-y>",
      function()
        require("neoscroll").scroll(-0.1, { move_cursor = false, duration = duration })
      end,
      desc = "Scroll up slow",
      mode = { 'n', 'v', 'x' },
    },
    {
      "<C-e>",
      function()
        require("neoscroll").scroll(0.1, { move_cursor = false, duration = duration })
      end,
      desc = "Scroll down slow",
      mode = { 'n', 'v', 'x' },
    },
    {
      "zt",
      function()
        require("neoscroll").zt { half_win_duration = duration / 2 }
      end,
      desc = "Snap to top",
      mode = { 'n', 'v', 'x' },
    },
    {
      "zz",
      function()
        require("neoscroll").zz { half_win_duration = duration / 2 }
      end,
      desc = "Snap to center",
      mode = { 'n', 'v', 'x' },
    },
    {
      "zb",
      function()
        require("neoscroll").zb { half_win_duration = duration / 2 }
      end,
      desc = "Snap to bottom",
      mode = { 'n', 'v', 'x' },
    },
  },
}
