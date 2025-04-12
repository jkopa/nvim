local M = {}

-- Cache for the last used command
local last_cmd = nil
-- Store the job ID of the running compilation
local current_job_id = nil

-- Function to handle the output data (both stdout and stderr)
local function handle_output(job_id, data, event, buffer)
  -- data is a table of strings, might contain empty strings from trimming.
  if data then
    for _, line in ipairs(data) do
      if line and #line > 0 then -- Check if line is not nil and not empty
        table.insert(buffer, line)
      end
    end
  end
end

-- Function to be called when the job exits
local function on_exit(job_id, code, event, output_buffer)
  current_job_id = nil -- Clear the job ID

  if code == 0 then
    vim.notify("Compilation finished successfully.", vim.log.levels.INFO)
  else
    vim.notify("Compilation finished with errors (code: " .. code .. ").", vim.log.levels.WARN)
  end

  -- If there was output, process it for the quickfix list
  if #output_buffer > 0 then
    -- Use Neovim's built-in parsing based on 'errorformat'
    -- setqflist replaces the list, [] means replace
    vim.fn.setqflist({}, ' ', { title = "Compilation Output", lines = output_buffer })
    vim.cmd('copen') -- Open the quickfix window
    -- vim.cmd('cwindow') -- Alternative: Open quickfix only if there are errors/valid locations
  else
    vim.notify("Compilation finished with no output.", vim.log.levels.INFO)
    -- Optionally close the quickfix window if it was open and is now empty
    -- This checks if the quickfix window is open and if the list is empty
    if vim.fn.getqflist({winid = 0,nr = 0}).winid ~= 0 and vim.fn.empty(vim.fn.getqflist()) == 1 then
        vim.cmd('cclose')
    end
  end

  -- Optional: Add a hook/autocmd event here if needed
  -- vim.api.nvim_exec_autocmds("User", { pattern = "CompileFinished" })

end

-- The main compilation function
function M.compile()
  -- If a job is already running, optionally ask the user if they want to kill it
  if current_job_id then
    local choice = vim.fn.input("A compile job is already running. Kill it? (y/n): ")
    if choice:lower() == 'y' then
      vim.fn.jobstop(current_job_id)
      vim.notify("Stopped previous compilation job.", vim.log.levels.WARN)
      current_job_id = nil
    else
      vim.notify("Compilation aborted, another job is running.", vim.log.levels.INFO)
      return
    end
  end

  local cmd_input = nil
  local prompt = "Compile command"
  if last_cmd then
    prompt = prompt .. " [" .. last_cmd .. "]"
  end
  prompt = prompt .. ": "

  cmd_input = vim.fn.input(prompt)

  -- If user just pressed Enter, use the cached command
  -- If they entered something, use that. If they cancelled (Ctrl+C), abort.
  if cmd_input == "" then
    if not last_cmd then
      vim.notify("No command entered and no previous command.", vim.log.levels.WARN)
      return
    end
    -- Use the last command if input is empty
    cmd_input = last_cmd
  elseif cmd_input == nil then -- This check might be redundant depending on vim.fn.input behavior, but safe
     vim.notify("Compilation cancelled.", vim.log.levels.INFO)
     return
  end

  -- Update the last command cache
  last_cmd = cmd_input

  vim.notify("Starting compilation: " .. cmd_input, vim.log.levels.INFO)

  -- Buffer to store combined stdout/stderr
  local output_buffer = {}

  -- Start the job asynchronously
  local job_id = vim.fn.jobstart(cmd_input, {
    -- Combine stdout and stderr for simplicity in parsing
    stdout_buffered = true,
    stderr_buffered = true,
    -- Use pty for more terminal-like behavior (optional, might affect output/colors)
    -- pty = true,
    on_stdout = function(id, data, event) handle_output(id, data, event, output_buffer) end,
    on_stderr = function(id, data, event) handle_output(id, data, event, output_buffer) end,
    on_exit = function(id, code, event) on_exit(id, code, event, output_buffer) end,
  })

  if not job_id or job_id == 0 or job_id == -1 then
      vim.notify("Failed to start compilation job for: " .. cmd_input, vim.log.levels.ERROR)
      current_job_id = nil
      last_cmd = nil -- Clear last command if it failed to start
  else
      current_job_id = job_id
      -- Clear the quickfix list immediately *before* starting the new job
      vim.fn.setqflist({}, 'f') -- 'f' clears the list without showing message
      -- Optional: Open the quickfix window immediately, it will be populated when done.
      -- vim.cmd('copen')
  end

end

-- Optional: Add a function to re-run the last command directly
function M.recompile()
  if not last_cmd then
    vim.notify("No command to recompile.", vim.log.levels.WARN)
    -- Optionally call M.compile() to prompt for a command
    -- M.compile()
    return
  end

  -- Clear previous output before rerunning (mimics Emacs behavior)
  vim.fn.setqflist({}, 'f') -- Clear quickfix list silently

  -- Reuse the compile logic, but force using last_cmd
  local original_last_cmd = last_cmd -- Store it in case compile modifies it unexpectedly
  local temp_input_fn = vim.fn.input -- Backup original input function
  vim.fn.input = function() return original_last_cmd end -- Temporarily override input
  M.compile()
  vim.fn.input = temp_input_fn -- Restore original input function
end


return M
