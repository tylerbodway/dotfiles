-- This is the setup for native LSP in Neovim
--
-- LSP configs are sourced from nvim-lspconfig:
-- See :help lspconfig-all for available servers
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

-- LSP setting overrides
vim.lsp.config("jsonls", {
  settings = {
    format = { enable = false },
  },
})

vim.lsp.config("ruby_lsp", {
  cmd_env = {
    GEM_HOME = vim.env.RUBY_CONFDIR,
  },
  init_options = {
    formatter = "syntax_tree",
    linters = { "rubocop" },
  },
})

-- LSP setup
vim.lsp.enable({
  "emmet_language_server",
  "eslint",
  "jsonls",
  "lua_ls",
  "ruby_lsp",
  "vtsls",
  "yamlls",
})

vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<CR>", { desc = "LSP info" })

-- Customizations run on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable inlay hints by default
    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    -- Diagnostics
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "󰌵",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
    })
    -- Keymaps
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
  end,
})
