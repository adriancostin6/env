local wezterm = require'wezterm'
-- https://wezfurlong.org/wezterm/config/lua/config/webgpu_preferred_adapter.html
local gpus = wezterm.gui.enumerate_gpus()
local theme = wezterm.gui.get_appearance()

return {
--  front_end = 'WebGpu',
--  webgpu_preferred_adapter = gpus[1],
  font              = wezterm.font('Iosevka NF', {weight = 'Light',}),
  color_scheme      = theme:find('Dark') and 'Catppuccin Frappe' or 'Catppuccin Latte',
  enable_tab_bar    = false,

  window_padding = {
    top     = 0,
    left    = 0,
    right   = 0,
    bottom  = 0,
  },

  set_environment_variables = {
      EDITOR='nvim',

      DEV_HOME              = '~/repos',
      SYSTEM_THEME          = theme:find('Dark') and 'dark' or 'light',
      DELTA_FEATURES        = theme:find('Dark') and 'delta-dark' or 'delta-light',

      PATH = 'C:/Users/adrianc/repos/scripts;'
          .. os.getenv('PATH')
  },

  keys = {
    -- Tabs
    {
        key   = 'n',
        mods  = 'META|SHIFT',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key   = 'r',
        mods  = 'META|SHIFT',
        action = wezterm.action.ReloadConfiguration,
    },
    {
        key   = 'c',
        mods  = 'META|SHIFT',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    {
        key   = 'l',
        mods  = 'META|SHIFT',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key   = 'h',
        mods  = 'META|SHIFT',
        action = wezterm.action.ActivateTabRelative(-1),
    },

    -- Scrollback
    {
        key   = 'j',
        mods  = 'META|SHIFT',
        action = wezterm.action.ScrollByLine(1),
    },
    {
        key   = 'k',
        mods  = 'META|SHIFT',
        action = wezterm.action.ScrollByLine(-1),
    },
    {
        key   = 'j',
        mods  = 'SUPER|SHIFT',
        action = wezterm.action.ScrollByPage(0.5),
    },
    {
        key   = 'k',
        mods  = 'SUPER|SHIFT',
        action = wezterm.action.ScrollByPage(-0.5),
    },

    -- Fullscreen
    {
        key   = 'f',
        mods  = 'META|SHIFT',
        action = wezterm.action.ToggleFullScreen
    },
  },

  -- TODO: Add key tables for Search Mode and Copy Mode to mak it more VI like

}
