local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Kanagawa Dragon"

config.font = wezterm.font("GeistMono Nerd Font", { weight = "Medium" })
config.font_size = 14.5
config.line_height = 1.1

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

config.default_prog = { "zsh", "-l", "-c", "zellij" }

return config
