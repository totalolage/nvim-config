local config = function ()
  local cmp_ai = require('cmp_ai.config')

  cmp_ai:setup({
    max_lines = 100,
    provider = 'Ollama',
    provider_options = {
      model = 'codellama:7b-code',
      prompt = function(lines_before, lines_after)
        -- prompt depends on the model you use. Here is an example for deepseek coder
        return '<PRE> ' .. lines_before .. ' <SUF>' .. lines_after .. ' <MID>' -- for codellama
      end,
    },
    debounce_delay = 600, -- ms llama may be GPU hungry, wait x ms after last key input, before sending request to it
    notify = true,
    notify_callback = function(msg)
      vim.notify(msg)
    end,
    run_on_every_keystroke = true,
  })
end

return config

