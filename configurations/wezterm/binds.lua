local wezterm = require'wezterm'

return {
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

  -- Panes
  {
    key   = 'h',
    mods  = 'META',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key   = 'j',
    mods  = 'META',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key   = 'k',
    mods  = 'META',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key   = 'l',
    mods  = 'META',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key   = 'v',
    mods  = 'META',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key   = 'o',
    mods  = 'META',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key   = 'c',
    mods  = 'META',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key   = 'f',
    mods  = 'META',
    action = wezterm.action.TogglePaneZoomState,
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
}
