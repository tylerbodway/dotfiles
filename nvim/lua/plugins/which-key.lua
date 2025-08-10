-- Show available keybindings in a popup as you type
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")

wk.setup({
  preset = "helix",
  show_help = false, -- <Esc> to close, <BS> to go back
  delay = 400,
  icons = {
    rules = {
      { pattern = "new", icon = "", color = "cyan" },
      { pattern = "save", icon = "󰆓", color = "blue" },
      { pattern = "delete", icon = "", color = "red" },
      { pattern = "buffer", icon = "", color = "cyan" },
      { pattern = "explorer", icon = "", color = "cyan" },
      { pattern = "command", icon = "", color = "green" },
      { pattern = "keymap", icon = "󰌓", color = "azure" },
    },
  },
})

wk.add({
  { "<leader>a", group = "ai", mode = { "n", "v" } },
  { "<leader>ag", group = "GitHub Copilot" },
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code", mode = { "n", "v" } },
  { "<leader>f", group = "files" },
  { "<leader>g", group = "git" },
  { "<leader>q", group = "quit" },
  { "<leader>r", group = "refactoring" },
  { "<leader>s", group = "search", mode = { "n", "v" } },
  { "<leader>u", group = "ui" },
  { "<leader>w", group = "windows" },
  { "<leader>x", group = "diagnostics" },
  { "g", group = "goto / general" },
  -- mini.surround
  { "gs", group = "surround" },
  { "gsa", desc = "Add surround" },
  { "gsd", desc = "Delete surround" },
  { "gsr", desc = "Replace surround" },
  { "gsf", desc = "Find next surround" },
  { "gsF", desc = "Find previous surround" },
  { "gsh", desc = "Highlight surround" },
  { "gsn", desc = "Update n_lines" },
})
