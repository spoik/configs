local wezterm = require 'wezterm'
local action = wezterm.action

local config = {}

-- disabling wayland could cause issues. Seems to be necessary for wezterm to be able to run in hyprland.
config.enable_wayland = false
config.audible_bell = 'Disabled'
config.color_scheme = 'Default Dark (base16)'
-- config.font = wezterm.font 'Menlo'
config.font = wezterm.font {
	family = 'JetBrains Mono',
	harfbuzz_features = { 'calt=0', 'clig=1', 'liga=1' },
}
config.font_size = 12
config.line_height = 1.1

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.native_macos_fullscreen_mode = true
config.show_new_tab_button_in_tab_bar = false
config.window_background_opacity = 0.8
-- config.window_background_opacity = 0.60
config.window_decorations = "NONE"
config.window_frame = {
	font_size = 12
}
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	-- Move tabs keybindings
	{ key = '{', mods = 'SHIFT|CMD',  action = action.MoveTabRelative(-1) },
	{ key = '}', mods = 'SHIFT|CMD',  action = action.MoveTabRelative(1) },
	{ key = '{', mods = 'SHIFT|ALT',  action = action.ActivateTabRelative(-1) },
	{ key = '}', mods = 'SHIFT|ALT',  action = action.ActivateTabRelative(1) },
	{ key = '-', mods = 'CMD',        action = action.DisableDefaultAssignment },
	{ key = '=', mods = 'CMD',        action = action.DisableDefaultAssignment },
	{ key = '-', mods = 'CTRL',       action = action.DisableDefaultAssignment },
	{ key = '=', mods = 'CTRL',       action = action.DisableDefaultAssignment },
	{ key = 'l', mods = 'SHIFT|CTRL', action = action.DisableDefaultAssignment },
}

return config
