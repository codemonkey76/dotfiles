local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "catppuccin-mocha"
config.hide_tab_bar_if_only_one_tab = true
config.keys = {
	{
		key = "F11",
		action = wezterm.action.ToggleFullScreen,
	},
}
config.font_size = 14.0

config.font = wezterm.font_with_fallback({
	"RobotoMono Nerd Font",
	"Hack Nerd Font",
	"FiraCode Nerd Font",
	"Jetbrains Mono",
	"CaskaydiaMono Nerd Font",
})

config.line_height = 1.4

config.window_padding = {
	top = 0,
	bottom = 0,
	left = 0,
	right = 0,
}

return config
