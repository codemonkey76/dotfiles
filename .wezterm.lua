local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "catppuccin-mocha"
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = true
config.front_end = "WebGpu"
return config
