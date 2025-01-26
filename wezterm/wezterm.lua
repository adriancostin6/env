local wezterm = require'wezterm'

local themes = require'themes'
local binds = require'binds'

-- https://wezfurlong.org/wezterm/config/lua/config/webgpu_preferred_adapter.html
local gpus = wezterm.gui.enumerate_gpus()
local system_theme = wezterm.gui.get_appearance()

wezterm.on('spawn-theme-selector', themes.select)

return {
--  front_end = 'WebGpu',
--  webgpu_preferred_adapter = gpus[1],
  font              = wezterm.font('Iosevka NF', {weight = 'Light',}),
  enable_tab_bar    = false,
  color_scheme = themes.default,

  window_padding = {
    top     = 0,
    left    = 0,
    right   = 0,
    bottom  = 0,
  },

  set_environment_variables = {
      EDITOR='nvim',
      DEV_HOME              = '~/repos',
      SYSTEM_THEME          = themes.system,
      DELTA_FEATURES        = themes.delta,
  },
  keys = binds,
}
