return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      solargraph = {
        mason = false,
        autostart = false,
      },
      ruby_lsp = {
        mason = false, -- gem install ruby-lsp
        init_options = {
          linters = { "rubocop" },
          formatter = "rubocop",
        },
      },
      syntax_tree = {
        mason = false, -- gem install syntax_tree
        cmd = { "bundle", "exec", "stree", "lsp" },
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
