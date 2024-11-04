return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
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
