return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      solargraph = {
        mason = false,
        autostart = false,
      },
      ruby_lsp = {
        init_options = {
          linters = { "rubocop" },
          formatter = "rubocop",
        },
      },
      syntax_tree = {
        cmd = { "bundle", "exec", "stree", "lsp" },
      },
      emmet_language_server = {},
    },
  },
}
