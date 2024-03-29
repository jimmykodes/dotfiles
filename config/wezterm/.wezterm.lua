local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.keys = {
  {
    key = 'p',
    mods = 'SUPER',
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'd',
    mods = 'SUPER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'D',
    mods = 'SUPER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'J',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'K',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'H',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'L',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
}

config.color_scheme = 'System76'
config.font = wezterm.font 'Monaspace Neon'
config.font_size = 16
return config
