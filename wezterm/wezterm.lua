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

local isWin = operating_system.isWindows()
config.default_prog = utils.ternary(
  isWin,
  { 'pwsh.exe' },
  { 'bash' }
)

return config
