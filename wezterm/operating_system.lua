local wezterm = require'wezterm'

local M = {}

function M.isWindows()
  print(wezterm.target_triple)
  return wezterm.target_triple == 'x86_64-pc-windows-msvc'
end

return M
