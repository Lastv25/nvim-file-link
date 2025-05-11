local JsonHandler = require("file-link.json_handler")

local M = {}

function M.print_message()
  print("Hello from your Neovim plugin!")
end

function M.setup()
  -- Create a user command :PrintMessage
  vim.api.nvim_create_user_command("PrintMessage", M.print_message, {})
  vim.api.nvim_create_user_command("Append", JsonHandler.append_to_file, {nargs=1})
  vim.api.nvim_create_user_command("List", JsonHandler.list_values_from_file, {})
  vim.api.nvim_create_user_command("RemoveLeaf", JsonHandler.remove_leaf_from_file, {nargs=1})

  -- Optional: Create a key mapping (e.g., <leader>pm)
  vim.keymap.set('n', '<leader>zm', M.print_message, { desc = "Print a message from plugin" })
end

return M


