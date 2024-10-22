-- https://wezfurlong.org/wezterm/config/files.html
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("JetBrains Mono")
config.font_size = 18

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 10

-- https://wezfurlong.org/wezterm/config/keys.html
config.keys = {
  {
    key = 'm',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- {
  --   key = 'LeftArrow',
  --   action = wezterm.action.DisableDefaultAssignment,
  -- },
  -- {
  --   key = 'RightArrow',
  --   action = wezterm.action.DisableDefaultAssignment,
  -- },
  -- {
  --   key = 'UpArrow',
  --   action = wezterm.action.DisableDefaultAssignment,
  -- },
  -- {
  --   key = 'DownArrow',
  --   action = wezterm.action.DisableDefaultAssignment,
  -- }
}
return config
