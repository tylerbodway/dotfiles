-- Conform is a lightweight but powerful formatter engine
-- https://github.com/stevearc/conform.nvim

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'
    local opts = { lsp_fallback = true, async = false, timeout_ms = 1000 }

    conform.setup {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        svelte = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        liquid = { 'prettier' },
        lua = { 'stylua' },
      },
      format_on_save = opts,
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
      conform.format(opts)
    end, { desc = '[F]ormat buffer' })
  end,
}
