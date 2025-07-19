return {
  {
    "catppuccin/nvim",
    opts = {
      flavor = "mocha",
      transparent_background = true,
      color_overrides = {
        mocha = {
          base = "#171922",
          text = "#eef1fc",
          mantle = "#13151c",
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
