--local telescope = require("telescope.builtin")

local M = {}

-- Cache for the last used command
local last_cmd = nil

function M.compile()

  local cmd = nil

  if not last_cmd then
     cmd = vim.fn.input("Enter command: ")
  else
     cmd = vim.fn.input("Enter command: ", last_cmd)
  end

  -- If user just pressed Enter, use the cached command
  if cmd == "" then
    cmd = last_cmd
  end

  if not cmd then
    print("No command entered.")
    return
  end

  last_cmd = cmd

  vim.api.nvim_exec(cmd, false)

end

return M
