local Path = require("plenary.path")


local M = {}
-- TODO: Replace all prints by logs
local file_name = ".flnk.txt"
local dir = vim.fn.getcwd()

local function get_full_path()
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

local function does_file_exist()
  local full_path = get_full_path()
  -- Returns 1 when found, 0 otherwise
  local exists = vim.fn.filereadable(full_path)
  if exists == 0 then
    return false
  end
  return true
end

local function current_file_path(is_absolute)
  local file_path = Path:new(vim.api.nvim_buf_get_name(0))
  if is_absolute then
    return file_path:absolute()
  end
   return file_path:make_relative()
end


local function create_file_flnk()
  local file_exists_bool = does_file_exist()
  if not file_exists_bool then
    io.open(full_path, "w")
  end
end

-- TODO: Ensure args type 
function M.append_to_file(new_text)
  -- ensuring flnk file exists
  create_file_flnk()

  -- getting data file path
  local file_path = get_full_path()
  -- fetching file line count 
  local line_count = 0
  for _ in io.lines(file_path) do
      line_count = line_count + 1
  end
  -- creating text to insert
  local current_file_path = current_file_path(true)
  local new_line = string.format("%d,%s,%s\n", line_count, current_file_path, new_text.fargs[1])

  -- append new line
  print("Hi")
  print(file_path)
  print(new_line)
  local opened_file = io.open(file_path, "a")
  opened_file:write(new_line)
  opened_file:close()
end

return M
