return {
  enabled = "false",
  "mfussenegger/nvim-dap",
  ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  config = function(_, opts)
    local dap = require "dap"

    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { os.getenv "HOME" .. "/.local/opt/vscode-node-debug2/out/src/nodeDebug.js" },
    }
    dap.configurations.javascript = {
      {
        name = "Launch",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = { os.getenv "HOME" .. "/.config/opt/vscode-chrome-debug/out/src/chromeDebug.js" }, -- TODO adjust
    }

    dap.configurations.javascriptreact = { -- change this to javascript if needed
      {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }

    dap.configurations.typescriptreact = { -- change to typescript if needed
      {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }

    dap.setup(opts)
  end,
}
