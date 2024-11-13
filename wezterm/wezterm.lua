local wezterm = require 'wezterm'
local action = wezterm.action

local config = {}

config.audible_bell = 'Disabled'
config.color_scheme = 'Default Dark (base16)'
-- config.font = wezterm.font 'Menlo'
config.font = wezterm.font {
	family = 'JetBrains Mono',
	harfbuzz_features = { 'calt=0', 'clig=1', 'liga=1' },
}
-- config.font_size = 12.0 -- When using as a laptop
-- config.font_size = 12.4 -- When the comp is a 1440p second screen
-- config.line_height = 1.1

-- When the comp is a 4k second screen
config.font_size = 14
config.line_height = 1.0
-- End when the comp is a 4k second screen

config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.92
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	-- Move tabs keybindings
	{ key = '{', mods = 'SHIFT|ALT', action = action.MoveTabRelative(-1) },
	{ key = '}', mods = 'SHIFT|ALT', action = action.MoveTabRelative(1) },
	{ key = '-', mods = 'CMD',       action = action.DisableDefaultAssignment },
	{ key = '=', mods = 'CMD',       action = action.DisableDefaultAssignment },
	{ key = '-', mods = 'CTRL',      action = action.DisableDefaultAssignment },
	{ key = '=', mods = 'CTRL',      action = action.DisableDefaultAssignment },
}

return config
