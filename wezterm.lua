-- https://wezfurlong.org/wezterm/config/files.html

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local is_darwin = wezterm.target_triple:find('darwin') ~= nil

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.default_prog = require('shell')
config.font = wezterm.font 'JetBrains Mono'
if is_darwin then
    config.font_size = 16.0
else 
    config.font_size = 14.0
end
config.color_scheme = 'Orangish (terminal.sexy)'
-- The set of schemes that we like and want to put in our rotation
local schemes = {}
for name, scheme in pairs(wezterm.get_builtin_color_schemes()) do
  table.insert(schemes, name)
end

local enable_random_scheme = false

wezterm.on('window-config-reloaded', function(window, pane)
    -- If there are no overrides, this is our first time seeing
    -- this window, so we can pick a random scheme.
    if not window:get_config_overrides() and enable_random_scheme then
        -- Pick a random scheme name
        local scheme = schemes[math.random(#schemes)]
        window:set_config_overrides {
            color_scheme = scheme,
        }
    end
    -- To check scheme name, use CTRL-SHIFT-L to open the debug overlay,
    -- then type in 
    --     window:get_config_overrides().color_scheme
    -- https://github.com/wez/wezterm/discussions/5024
end)

config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
}
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Fix the rendering issue on NixOS https://github.com/NixOS/nixpkgs/issues/336069
-- config.front_end = "WebGpu"
config.enable_wayland = true

-- and finally, return the configuration to wezterm
return config
