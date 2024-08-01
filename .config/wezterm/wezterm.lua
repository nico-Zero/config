local wezterm = require 'wezterm'
local config = {}

config.color_scheme_dirs = { '~/.config/wezterm/iTerm2-Color-Schemes/wezterm/' }
config.color_scheme = 'Tomorrow Night Bright (Gogh)'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.font_size = 10.0
config.window_padding = {
  left = 20,
  right = 0,
  top = 15,
  bottom = 0,
}

config.window_frame = {
  font_size = 10.0,

  active_titlebar_bg = '#333333',

  inactive_titlebar_bg = '#333333',
}

config.window_background_opacity = 0.75
config.font = wezterm.font {
  family = 'JetBrains Mono',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}

return config
