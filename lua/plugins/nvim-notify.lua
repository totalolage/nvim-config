return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 100,
  config = function()
    local notify = require("notify")
    
    notify.setup({
      -- Animation style (see below for details)
      stages = "fade_in_slide_out",
      
      -- Function called when a new window is opened, use for changing win settings/config
      on_open = nil,
      
      -- Function called when a window is closed
      on_close = nil,
      
      -- Render function for notifications. See notify-render()
      render = "default",
      
      -- Default timeout for notifications
      timeout = 3000,
      
      -- For stages that change opacity this is treated as the highlight behind the window
      -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
      background_colour = "Normal",
      
      -- Minimum width for notification windows
      minimum_width = 50,
      
      -- Icons for the different levels
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })
    
    -- Set nvim-notify as the default notification handler
    vim.notify = notify
    
    -- Create a command to test notifications
    vim.api.nvim_create_user_command("NotifyTest", function()
      vim.notify("This is an info notification", vim.log.levels.INFO, { title = "Test" })
      vim.notify("This is a warning notification", vim.log.levels.WARN, { title = "Test" })
      vim.notify("This is an error notification", vim.log.levels.ERROR, { title = "Test" })
    end, { desc = "Test nvim-notify notifications" })
    
    -- Create a command to show messages in notify
    vim.api.nvim_create_user_command("MessagesToNotify", function()
      local messages = vim.fn.execute("messages")
      local lines = vim.split(messages, "\n")
      for _, line in ipairs(lines) do
        if line ~= "" then
          vim.notify(line, vim.log.levels.INFO, { title = "Messages" })
        end
      end
    end, { desc = "Show :messages in nvim-notify" })
  end,
}