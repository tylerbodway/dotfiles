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
  filetypes = { "ruby" }, -- excludes eruby to avoid conflicts with herb_ls
  cmd_env = {
    GEM_HOME = vim.env.RUBY_CONFDIR,
  },
  init_options = {
    linters = { "rubocop" },
    formatter = (function()
      if vim.fn.executable("rubotree") == 1 then return "rubotree" end -- https://github.com/planningcenter/edna?tab=readme-ov-file#rubotree
      if vim.fn.executable("stree") == 1 then return "syntax_tree" end
      if vim.fn.executable("rubocop") == 1 then return "rubocop" end
      return "auto"
    end)(),
  },
})

vim.lsp.config("herb_ls", {
  settings = {
    languageServerHerb = {
      formatter = {
        enabled = true,
        maxLineLength = 100,
      },
    },
  },
})

-- LSP setup
vim.lsp.enable({
  "emmet_language_server",
  "eslint",
  "herb_ls",
  "jsonls",
  "lua_ls",
  "ruby_lsp",
  "stylelint_lsp",
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

    -- stylelint_lsp doesn't implement textDocument/formatting, so conform's
    -- lsp_format fallback can't drive it. Instead, run its source.fixAll
    -- code action on save (mirrors VS Code's editor.codeActionsOnSave).
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "stylelint_lsp" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("UserStylelintFixOnSave_" .. ev.buf, { clear = true }),
        buffer = ev.buf,
        callback = function()
          local gaf = vim.g.autoformat
          local baf = vim.b[ev.buf].autoformat
          if baf == false or (baf == nil and not gaf) then return end

          vim.lsp.buf.code_action({
            context = { only = { "source.fixAll.stylelint" }, diagnostics = {} },
            apply = true,
          })
        end,
      })
    end
  end,
})
