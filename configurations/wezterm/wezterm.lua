local wezterm = require'wezterm'

local themes = require'themes'
local binds = require'binds'
local utils = require'utils'
local operating_system = require'operating_system'

-- +--------+
-- | events |
-- +--------+-------------------------------------------------------------------
wezterm.on('spawn-theme-selector', themes.select)

-- +--------+
-- | config |
-- +--------+-------------------------------------------------------------------
config = {}

config.prefer_egl = true
config.enable_tab_bar = false

config.font = wezterm.font_with_fallback({
  { family='IosevkaTermSlab Nerd Font', weight='Light' },
  'Cascadia Code',
})

config.color_scheme = themes.default

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
}

config.keys = binds

if operating_system.isWindows() then
  config.default_prog = { 'pwsh.exe' }
else
  config.default_prog = { 'bash' }
end

return config
