-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- config.enable_wayland = true
-- config.font = wezterm.font 'Aporetic Sans Mono'
config.font = wezterm.font 'TX-02 SemiLight'
config.font_size = 14

config.color_scheme = 'Windows NT (base16)'

-- config.initial_cols = 120
-- config.initial_rows = 30

-- theme
--[[
config.colors = {
    ansi = {
    '#1e1e1e',
    '#ff5f59',
    '#44bc44',
    '#d0bc00',
    '#2fafff',
    '#feacd0',
    '#00d3d0',
    '#303030'
    },
    brights = {
    '#535353',
    '#ff5f5f',
    '#44df44',
    '#efef00',
    '#338fff',
    '#ff66ff',
    '#00eff0',
    '#646464'
    },
    cursor_bg = '#00eff0',
    cursor_border = '#ff66ff',
    cursor_fg = '#000000',
    background = '#000000',
    foreground = '#ffffff',
    selection_bg = '#00eff0',
    selection_fg = '#000000',
    }
]]
-- window
config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"

-- close tab without confirmation
-- config.keys = {
-- 	{
-- 		key = 'w',
-- 		mods = 'CTRL|SHIFT',
-- 		action = wezterm.action.CloseCurrentPane { confirm = false },
-- 	},
-- }

return config
