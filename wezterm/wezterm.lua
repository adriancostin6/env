local wezterm = require'wezterm'
-- https://wezfurlong.org/wezterm/config/lua/config/webgpu_preferred_adapter.html
local gpus = wezterm.gui.enumerate_gpus()
local theme = wezterm.gui.get_appearance()

local themes = {
    'Catppuccin Latte',
    'Catppuccin Frappe',
    'Catppuccin Macchiato',
    'Catppuccin Mocha',
}
wezterm.on('spawn-theme-selector', function(window, pane)
  local choices = {}
  for _, theme in ipairs(themes) do
    table.insert(choices, { label = theme, id = theme})
  end
  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id and not label then
            return
        end
        local theme = label
        wezterm.log_info(theme)
        window:set_config_overrides({ color_scheme = theme })
      end),
      title = 'Color schemes',
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Fuzzy select color scheme.",
    }),
    pane
  )
end)

return {
--  front_end = 'WebGpu',
--  webgpu_preferred_adapter = gpus[1],
  font              = wezterm.font('Iosevka NF', {weight = 'Light',}),
  enable_tab_bar    = false,
  color_scheme = theme:find('Dark') and 'Catppuccin Frappe' or 'Catppuccin Latte',

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

    {
      key = 's',
      mods  = 'META|SHIFT',
      action = wezterm.action.EmitEvent("spawn-theme-selector")
    },
  },

  -- TODO: Add key tables for Search Mode and Copy Mode to mak it more VI like

}
