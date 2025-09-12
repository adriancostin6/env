local M = {}

local wezterm = require'wezterm'

local appearance = wezterm.gui.get_appearance()

local pine_dawn = wezterm.plugin.require('https://github.com/neapsix/wezterm').dawn
local pine_moon = wezterm.plugin.require('https://github.com/neapsix/wezterm').moon
local pine = wezterm.plugin.require('https://github.com/neapsix/wezterm').main
local schemes = wezterm.get_builtin_color_schemes()

M.default = appearance:find('Dark') and pine.colors() or pine_dawn.colors()
M.delta = appearance:find('Dark') and 'catppuccin-frappe' or 'catppuccin-latte'
M.system = appearance:find('Dark') and 'dark' or 'light'

local themes = {
    'Catppuccin Latte',
    'Catppuccin Frappe',
    'Catppuccin Macchiato',
    'Catppuccin Mocha',
    'Rose Pine',
    'Rose Pine Dawn',
    'Rose Pine Moon',
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

  wezterm.log_info("Selected theme " .. label)

  local overrides = window:get_config_overrides{} or {}
  local cases = {
    ['Rose Pine'] = function()
      overrides.colors = pine.colors()
    end,
    ['Rose Pine Dawn'] = function() 
      overrides.colors = pine_dawn.colors()
    end,
    ['Rose Pine Moon'] = function()
      overrides.colors = pine_moon.colors()
    end,
  }

  local pick = cases[label] or function()
    overrides.color_scheme = label
  end
  if not overrides then
    pick()
  end

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
      fuzzy_description = "Fuzzy select color scheme.",
    }),
    pane
  )
end

return M
