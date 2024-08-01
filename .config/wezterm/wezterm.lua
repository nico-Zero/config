local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Batman'
-- config.hide_tab_bar_if_only_one_tab = false
config.enable_tab_bar = false
config.font_size = 10.0

config.window_frame = {
  font_size = 10.0,

  active_titlebar_bg = '#333333',

  inactive_titlebar_bg = '#333333',
}

config.window_background_opacity = 0.8
return config
