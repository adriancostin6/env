local M = {}

function M.ternary(condition, a, b)
  if condition then 
    return a
  else 
    return b 
  end
end

return M
