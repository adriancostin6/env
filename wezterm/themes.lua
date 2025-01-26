local M = {}

local wezterm = require'wezterm'

local appearance = wezterm.gui.get_appearance()

M.default = appearance:find('Dark') and 'Catppuccin Frappe' or 'Catppuccin Latte'
M.delta = appearance:find('Dark') and 'delta-dark' or 'delta-light'
M.system = appearance:find('Dark') and 'dark' or 'light'

local themes = {
    'Catppuccin Latte',
    'Catppuccin Frappe',
    'Catppuccin Macchiato',
    'Catppuccin Mocha',
}

local function get_choices()
  local choices = {}
  for _, theme in ipairs(themes) do
    table.insert(choices, { label = theme, id = theme})
  end
  return choices
end

local function switch(window, pane, id, label)
  if not i and not label then
    wezterm.log_error("Theme is undefined.")
    return
  end

  local theme = label
  window:set_config_overrides({ color_scheme = theme })
end

function M.select(window, pane)
  local choices = get_choices()
  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(switch),
      title = 'Color schemes',
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Fuzzy select color scheme.",
    }),
    pane
  )
end


return M
