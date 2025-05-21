return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-3.7-sonnet",
      auto_insert_mode = false,
      show_help = false,
      question_header = " Tyler ",
      window = {
        width = 0.3,
      },
    },
    keys = {
      {
        "<leader>aX",
        function()
          local chat = require("CopilotChat")
          chat.reset()
          chat.toggle()
        end,
        desc = "Clear and Close (CopilotChat)",
        mode = { "n", "v" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = vim.fn.expand("$XDG_DATA_HOME") .. "/asdf/installs/nodejs/23.11.0/bin/node",
    },
  },
}
