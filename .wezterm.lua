local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "catppuccin-mocha"
config.hide_tab_bar_if_only_one_tab = true
config.window.padding = {
    top = 0
}
return config
