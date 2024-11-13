local wezterm = require("wezterm")
local config = {}

-- Text
config.font = wezterm.font("GeistMono Nerd Font", { weight = "Medium" })
config.font_size = 14.0
config.line_height = 1.1

-- Window
config.initial_cols = 300
config.initial_rows = 100
config.window_padding = {
  left = "1.5cell",
  right = "1.5cell",
  top = "0.5cell",
  bottom = 0,
}
config.enable_tab_bar = false
config.window_decorations = "RESIZE" -- disables title bar, but window is resizable
config.force_reverse_video_cursor = true -- reverses color under cursor, rather than always use theme color
config.send_composed_key_when_right_alt_is_pressed = false -- right option is treated like Alt, not AltGr
config.window_close_confirmation = "NeverPrompt"

-- Theme
config.color_scheme = "Kanagawa Dragon"
config.color_schemes = {
  ["Kanagawa Dragon"] = {
    foreground = "#c5c9c5",
    background = "#181616",

    cursor_bg = "#C8C093",
    cursor_fg = "#181616",
    cursor_border = "#C8C093",

    selection_fg = "#C8C093",
    selection_bg = "#2D4F67",

    scrollbar_thumb = "#16161D",
    split = "#16161D",

    ansi = {
      "#0D0C0C",
      "#C4746E",
      "#8A9A7B",
      "#C4B28A",
      "#8BA4B0",
      "#A292A3",
      "#8EA4A2",
      "#C8C093",
    },
    brights = {
      "#A6A69C",
      "#E46876",
      "#87A987",
      "#E6C384",
      "#7FB4CA",
      "#938AA9",
      "#7AA89F",
      "#C5C9C5",
    },
    indexed = { [16] = "#B6927B", [17] = "#B98D7B" },
  },
}

return config
