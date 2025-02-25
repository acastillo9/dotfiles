local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Catppuccin Mocha"
config.background = {
	{
		source = { Color = '#1E1E2E' },
		width = '100%',
		height = '100%'
	},
	{
		source = {
			File = '/Users/andres.castilloe/Pictures/bg_13.png'
		},
		horizontal_align = 'Center',
		opacity = 0.2
	}
}
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}
config.max_fps = 120

return config
