return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-sonnet-4",
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
}
