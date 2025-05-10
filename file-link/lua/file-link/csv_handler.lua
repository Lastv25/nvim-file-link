-- imports local
local Utils = require("file-link.utils.file_helper")


-- local variables definition
local M = {}
local file_name = ".flnk.csv"
local dir = vim.fn.getcwd()

local function create_csv()
  local full_path = Utils.get_full_path(dir,file_name)
  local existance_bool = Utils.does_file_exist(dir,file_name)
  if existance_bool then
    return full_path
  end
  io.open(full_path, 'w')
  return full_path
end

local function hash(path)
    return vim.fn.sha256(path)
end

function M.append_to_file(new_text)
  local text_value = new_text.fargs[1]
  -- ensuring the csv file exists
  local full_path = create_csv()
  -- create new row
  local current_file_path = Utils.current_file_path(true)
  local hash_index = hash(current_file_path)
  local hash_new_text = hash(text_value)
  local new_line = string.format('%s,%s,%s\n', hash_index,current_file_path,hash_new_text)
  local opened_file = io.open(full_path, "a")
  opened_file:write(new_line)
  opened_file:close()

end


function M.list_from_file()
  local full_path = Utils.get_full_path(dir,file_name)
  local existance_bool = Utils.does_file_exist(dir,file_name)
  if not existance_bool then
    print("No file link file found")
    return
  end
  for line in io.lines(full_path) do
    print(line)
  end
end

return M

