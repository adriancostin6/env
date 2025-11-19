local M = {}

local wezterm = require'wezterm'

local appearance = wezterm.gui.get_appearance()
local schemes = wezterm.get_builtin_color_schemes()

if appearance:find('Dark') then
  M.default = 'rose-pine'
  M.system = 'dark'
else
  M.default = 'rose-pine-dawn'
  M.system = 'light'
end

local function get_choices()
  local choices = {}
  for theme, _ in pairs(schemes) do
    table.insert(choices, { label = theme})
  end
  return choices
end

local function switch(window, pane, id, label)
  if not id and not label then
    wezterm.log_error("Theme is undefined.")
    return
  end

  wezterm.log_info("Selected theme " .. label)
  local overrides = window:get_config_overrides{} or {}

  overrides.color_scheme = label
  window:set_config_overrides(overrides)
end

function M.select(window, pane)
  local choices = get_choices()
  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(switch),
      title = 'Color schemes',
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Select color scheme.",
    }),
    pane
  )
end

return M
