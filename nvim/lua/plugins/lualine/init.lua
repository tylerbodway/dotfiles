-- A blazing fast and easy to configure neovim statusline plugin
vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

local codecompanion = require("plugins.lualine.extensions.codecompanion")

require("lualine").setup({
  options = {
    globalstatus = true,
    disabled_filetypes = { "snacks_dashboard", "snacks_picker_list" },
    component_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", file_status = false, path = 1 }, "diagnostics", "diff" },
    lualine_x = { { codecompanion }, "lsp_progress" },
    lualine_y = { "filetype", "encoding", "progress" },
    lualine_z = { "location" },
  },
})
