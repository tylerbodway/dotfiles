return {
  "ibhagwan/fzf-lua",
  opts = function()
    local actions = require("fzf-lua.actions")
    return {
      files = {
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
          ["ctrl-h"] = { actions.toggle_hidden },
        },
      },
      grep = {
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
          ["ctrl-h"] = { actions.toggle_hidden },
        },
      },
    }
  end,
}
