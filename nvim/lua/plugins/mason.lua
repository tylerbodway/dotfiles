-- Mason is a package manager for LSP servers, linters, and formatters
-- https://github.com/williamboman/mason.nvim

return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    local mason = require 'mason'
    local mason_lspconfig = require 'mason-lspconfig'
    local mason_tool_installer = require 'mason-tool-installer'

    mason.setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    mason_lspconfig.setup {
      ensure_installed = {
        'css_variables',
        'emmet_ls',
        'gopls',
        'rubocop',
        'rubocop',
        'ruby_lsp',
        'stimulus_ls',
        'tailwindcss',
        'tsserver',
        'yamlls',
        'lua_ls',
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        'eslint_d', -- javascript linter
        'markdownlint', -- markdown linter
        'prettier', -- prettier formatter
        'stylua', -- lua formatter
      },
    }
  end,
}
