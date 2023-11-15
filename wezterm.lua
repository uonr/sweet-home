-- https://wezfurlong.org/wezterm/config/files.html

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14
config.color_scheme = 'Tokyo Night'

config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
}
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
-- and finally, return the configuration to wezterm
return config