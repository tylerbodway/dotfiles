-- Lightweight yet powerful formatter plugin
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

if vim.g.autoformat == nil then vim.g.autoformat = true end
-- See auto format toggles in snacks.lua

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
  },
  -- Sets up autocmd to format on buffer save
  format_on_save = function(bufnr)
    local gaf = vim.g.autoformat
    local baf = vim.b[bufnr].autoformat

    if baf == false or (baf == nil and not gaf) then return end

    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function() conform.format() end, { desc = "Format" })
