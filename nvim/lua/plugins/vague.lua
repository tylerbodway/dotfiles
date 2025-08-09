-- A cool, dark, low contrast colorscheme
vim.pack.add({ "https://github.com/vague2k/vague.nvim" })

require("vague").setup({ transparent = true })

vim.cmd.colorscheme("vague")

-- Scheduled to run after all plugins load
vim.schedule(function()
  -- Removes distracting purple statusline bg
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })

  -- Trigger ColorScheme autocmd for any plugins that depend on it
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "vague" })
end)
