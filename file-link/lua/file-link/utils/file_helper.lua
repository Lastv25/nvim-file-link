local Path = require("plenary.path")


local M = {}
-- TODO: Replace all prints by logs

function M.get_full_path(dir,file_name)
  -- Ensure there is a path separator between dir and file_name
  local sep = package.config:sub(1,1) -- / or \
  -- set full path
  local full_path = dir
  if not dir:match(sep.."$") then
    full_path = dir .. sep
  end
  full_path = full_path .. file_name
  return full_path
end

function M.does_file_exist(dir, file_name)
  local full_path = M.get_full_path(dir,file_name)
  -- Returns 1 when found, 0 otherwise
  local exists = vim.fn.filereadable(full_path)
  if exists == 0 then
    return false
  end
  return true
end

function M.get_row_count(file_path)
  local line_count = 0
  for _ in io.lines(file_path) do
      line_count = line_count + 1
  end
  return line_count
end

function M.current_file_path(is_absolute)
  local file_path = Path:new(vim.api.nvim_buf_get_name(0))
  if is_absolute then
    return file_path:absolute()
  end
   return file_path:make_relative()
end

return M
