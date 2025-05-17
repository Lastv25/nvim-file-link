-- imports
local Utils = require("file-link.utils.file_helper")

-- local variables definition
local M = {}
local file_name = ".flnk.json"
local dir = vim.fn.getcwd()

-- aliasses
---@alias FlnkData {string:[{string: {string:string, string:[string]}}]}


---@param path string
---@return string
local function hash(path)
    return vim.fn.sha256(path)
end

-- TODO: think about maybe returning only chucks or using the lua equivalent to python generators

---@return FlnkData
function M.list_values_from_file()
  -- STEP 1: Does File exist
  local existance_bool = Utils.does_file_exist(dir,file_name)
  local json_file_path = Utils.get_full_path(dir,file_name)
  if not existance_bool then
    return nil
  end
  -- STEP 2 return decoded data fully
  local raw_data = io.open(json_file_path, 'r'):read()
  local decoded_data = vim.json.decode(raw_data)
  return decoded_data
end


-- TODO: ensure input args type and no wrong input can be added
-- TODO: optimize function if possible

---@param nex_text string
function M.append_to_file(new_text)
  -- data to be used afterward in this function
  local text_value = new_text.fargs[1]
  local json_file_path = Utils.get_full_path(dir,file_name)
  local current_file_path = Utils.current_file_path(dir,file_name)
  local hash_index = hash(current_file_path)
  local hash_new_text = hash(text_value)

  -- STEP 1: If file exist get data
  local existing_data = M.list_values_from_file()
  if existing_data ~= nil then
    -- STEP 2
    -- fetch all values from json
    local hash_not_found = true
    for _,element in ipairs(existing_data.hashes_index) do
      local element_val = element[hash_index]
      if element_val ~= nil then
        -- The current file already has some links defined
        local link_already_exists = false
        -- checking if the link already exists
        for _,link_hash in pairs(element_val.links) do
          if link_hash == hash_new_text then
            link_already_exists = true
          end
        end
        -- if it does not exist, add the new link
        if not link_already_exists then
          element_val['links'][#element_val['links']+1] = hash_new_text 
          Utils.write_to_file(json_file_path, vim.json.encode(existing_data))
        end
        hash_not_found = false
      end
    end
    if hash_not_found then
      -- first time adding links for this file
      existing_data['hashes_index'][#existing_data['hashes_index']+1] = {
          [hash_index] = {
            file_path = current_file_path,
            links = { hash_new_text }
          }
        }
      Utils.write_to_file(json_file_path, vim.json.encode(existing_data))
    end
  else
    -- STEP 2
    -- Create new data structure based on FlnkData
    local data = {
      hashes_index = {
        [1] = {
          [hash_index] = {
            file_path = current_file_path,
            links = { hash_new_text }
          }
        }
      }
    }
    -- create empty file and add data inside
    Utils.write_to_file(json_file_path, vim.json.encode(data))
  end

end

---@param new_text string
function M.remove_leaf_from_file(new_text)
  local file_to_remove = new_text.fargs[1]
  local hash_index = hash(file_to_remove)
  local json_file_path = Utils.get_full_path(dir,file_name)
  local existing_data = M.list_values_from_file()
  -- if file does nox exist then do nothing
  if existing_data == nil then
    return nil
  end
  local idx_found = 0
  for idx,element in ipairs(existing_data.hashes_index) do
    local element_val = element[hash_index]
    if element_val ~= nil then
      idx_found = idx
    end
  end
  if idx_found ~= 0 then
    table.remove(existing_data['hashes_index'], idx_found)
    Utils.write_to_file(json_file_path, vim.json.encode(existing_data))
  end
end


---@param file_to_remove string
---@param link_value string
function M.remove_link_from_leaf(file_to_remove, link_value)
  local hash_index = hash(file_to_remove)
  local json_file_path = Utils.get_full_path(dir,file_name)
  local existing_data = M.list_values_from_file()
  -- if file does nox exist then do nothing
  if existing_data == nil then
    return nil
  end
  local idx_found = 0
  for idx,element in ipairs(existing_data.hashes_index) do
    local element_val = element[hash_index]
    if element_val ~= nil then
      idx_found = idx
    end
  end
  local idx_link_found = 0
  if idx_found ~= 0 then
    for idx_link, link in ipairs(existing_data['hashes_index'][idx_found]['links']) do
      if link == link_value then
        idx_link_found = idx_link
      end
    end
    if idx_link_found ~= 0 then
      table.remove(existing_data['hashes_index'][idx_found]['links'])
      Utils.write_to_file(json_file_path, vim.json.encode(existing_data))
    end
  end
end

return M

