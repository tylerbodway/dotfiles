-- AI coding, Vim style
vim.pack.add({ "https://github.com/olimorris/codecompanion.nvim" })
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })
vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

-- better chat buffer styling
require("render-markdown").setup({
  file_types = { "markdown", "codecompanion" },
})

require("codecompanion").setup({
  display = {
    chat = {
      auto_scroll = false,
      fold_content = true,
      intro_message = " Press ? for options",
      window = {
        width = 0.33,
        opts = {
          cursorline = true,
          numberwidth = 3,
        },
      },
    },
    diff = {
      provider = "mini_diff",
    },
  },
  strategies = {
    inline = {
      adapter = {
        name = "copilot",
        model = "claude-sonnet-4",
      },
    },
    chat = {
      adapter = {
        name = "copilot",
        model = "claude-sonnet-4",
      },
      roles = {
        user = "  Me",
        llm = function(adapter) return "󱙺  AI (" .. adapter.formatted_name .. ": " .. adapter.model.name .. ")" end,
      },
    },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>ak", "<cmd>CodeCompanionActions<CR>", { desc = "AI actions" })
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "AI chat" })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add AI chat context" })
vim.keymap.set({ "n", "v" }, "<leader>ai", function()
  local mode = vim.fn.mode()
  vim.ui.input({ prompt = "Ask AI 󱙺 ", win = { style = "above_cursor" } }, function(input)
    if input and input ~= "" then
      if mode:match("[vV\22]") then
        vim.cmd("'<,'>CodeCompanion " .. input)
      else
        vim.cmd("CodeCompanion " .. input)
      end
    end
  end)
end, { desc = "AI inline assistant" })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd.cab("cc", "CodeCompanion")
