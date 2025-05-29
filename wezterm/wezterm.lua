local wezterm = require'wezterm'

local themes = require'themes'
local binds = require'binds'

-- https://wezfurlong.org/wezterm/config/lua/config/webgpu_preferred_adapter.html
local gpus = wezterm.gui.enumerate_gpus()

wezterm.on('spawn-theme-selector', themes.select)

config = {}

--  front_end = 'WebGpu',
--  webgpu_preferred_adapter = gpus[1],
config.prefer_egl = true
config.font              = wezterm.font('Iosevka', {weight = 'Light',})
config.enable_tab_bar    = false

if type(themes.default) == "string" then
    config.color_scheme = themes.default
    config.colors = nil
else
    config.colors = themes.default
    config.color_scheme = nil
end

config.window_padding = {
  top     = 0,
  left    = 0,
  right   = 0,
  bottom  = 0,
}

config.set_environment_variables = {
    EDITOR='nvim',
    DEV_HOME              = '~/repos',
    SYSTEM_THEME          = themes.system,
    DELTA_FEATURES        = themes.delta,
}
config.keys = binds

return config