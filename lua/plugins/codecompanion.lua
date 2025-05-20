local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = {
    -- log_level = "TRACE",

    display = {
      chat = {
        window = {
          layout = "float",
        },
        render_headers = false,
      },
    },

    prompt_library = {
      ["Generate a Commit Message"] = {
        strategy = "inline",
        description = "Generate a commit message",
        opts = {
          index = 10,
          is_default = true,
          is_slash_cmd = true,
          short_name = "commit",
          auto_submit = true,
        },
        prompts = {
          {
            role = constants.SYSTEM_ROLE,
            content = function()
              return fmt(
                [[You are an expert at following the Conventional Commit specification. Given the provided by the user below, please generate a commit message for me using the supplied editor tool.]]
              )
            end,
            opts = {
              visible = false,
            },
          },
          {
            role = constants.USER_ROLE,
            content = function()
              return fmt(
                [[
Diff of changes:  
```diff
%s
```

Current branch:  
%s

The last 10 commit messages, your commit message should match their format:  
```text
%s
```
]],
                vim.fn.system "git diff --no-ext-diff --staged",
                vim.fn.system "git rev-parse --abbrev-ref HEAD",
                vim.fn.system "git for-each-ref --count 10 --sort=-creatordate --format='%(refname:short)' refs/heads/ | xargs -n 1 git log --author=\"$(git config user.name)\" --pretty=format:'%G? %s' -n 100 | awk '$1==\"G\" {$1=\"\";sub(/^ /, \"\");print}' | head -n10"
              )
            end,
            opts = {
              contains_code = false,
            },
          },
        },
      },
    },

    strategies = {
      chat = {
        adapter = "openai",
      },
      inline = {
        adapter = "openai",
      },
      agent = {
        adapter = "openai",
      },
      cmd = {
        adapter = "openai",
      },
    },

    adapters = {
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = "cmd:security find-generic-password -a openai_api_key -s codecompanion.nvim -w",
          },
        })
      end,
    },
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    {
      "<leader>cc<CR>",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Toggle CodeCompanion",
      mode = { "n", "v" },
    },
    {
      "<leader>cci",
      "<cmd>CodeCompanion<CR>",
      desc = "CodeCompanion",
      mode = { "n", "v" },
    },
    {
      "<leader>cc ",
      "<cmd>CodeCompanion ",
      desc = "CodeCompanion command",
      mode = { "n", "v" },
    },
    {
      "<leader>ccc",
      "<cmd>CodeCompanion /commit<CR>",
      desc = "CodeCompanion /commit",
      mode = { "n", "v" },
    },
    {
      "<leader>cch",
      function()
        require("codecompanion").chat()
      end,
      desc = "CodeCompanionChat",
      mode = { "n", "v" },
    },
    {
      "<leader>cca",
      function()
        require("codecompanion").actions()
      end,
      desc = "CodeCompanionActions",
      mode = { "n", "v" },
    },
    {
      "<leader>cce",
      function()
        require("codecompanion").prompt "explain"
      end,
      desc = "Explain",
      mode = { "n", "v" },
    },
  },
}
