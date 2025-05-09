local M = {}
-- TODO: Replace all prints by logs
local file_name = ".flnk.txt"

local function nil_if_file_exist(dir)
  local dir = dir or vim.fn.getcwd()
  -- Ensure there is a path separator between dir and file_name
  local sep = package.config:sub(1,1) -- / or \
  -- set full path
  local full_path = dir
  if not dir:match(sep.."$") then
    full_path = dir .. sep
  end
  full_path = full_path .. file_name

  print("We are currently looking for")
  print(full_path)
  -- Returns 1 when found, 0 otherwise
  local exists = vim.fn.filereadable(full_path)
  if exists == 0 then
    print("We did not find the " .. file_name)
    return full_path
  end
  print("We found " .. file_name)
end


function M.create_file_flnk()
  full_path = nil_if_file_exist()
  if full_path ~= nil then
    print("Creating File " .. full_path)
    io.open(full_path, "w")
    return 
  end
  print("File already exists")
end

return M
