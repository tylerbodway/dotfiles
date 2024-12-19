return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
        init_options = {
          linters = { "rubocop" },
          formatter = "syntax_tree",
        },
      },

      emmet_language_server = {},

      jsonls = {
        settings = {
          format = {
            enable = false,
          },
        },
      },
    },
  },
}
