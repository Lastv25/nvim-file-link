local Files = require("file-link.file_helper")

local M = {}

function M.print_message()
  print("Hello from your Neovim plugin!")
end

function M.setup()
  -- Create a user command :PrintMessage
  vim.api.nvim_create_user_command("PrintMessage", M.print_message, {})
  vim.api.nvim_create_user_command("Append", Files.append_to_file, {nargs=1})

  -- Optional: Create a key mapping (e.g., <leader>pm)
  vim.keymap.set('n', '<leader>zm', M.print_message, { desc = "Print a message from plugin" })
end

return M


