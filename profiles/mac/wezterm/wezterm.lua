local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

config.color_scheme = "Tokyo Night"

config.font = wezterm.font("GeistMono Nerd Font", { weight = "Medium" })
config.font_size = 13.0
config.line_height = 1.1
-- config.freetype_load_target = "Light"

config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.initial_cols = 150
config.initial_rows = 40
config.window_padding = {
  left = 30,
  right = 30,
  top = 60,
  bottom = 30,
}

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    background = "#161621",
  },
}

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

return config
