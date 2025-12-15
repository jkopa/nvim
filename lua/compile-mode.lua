local M = {}

-- Configuration with defaults
M.config = {
  auto_scroll = true,           -- Auto-scroll to bottom of compilation buffer
  auto_close_on_success = false, -- Close buffer on successful compilation
  split_direction = "botright",  -- Where to open the compilation buffer
  split_size = 15,               -- Height of the compilation window
  save_before_compile = true,    -- Save all modified buffers before compiling
}

-- State
local state = {
  last_cmd = nil,
  current_job_id = nil,
  compile_buf = nil,
  compile_win = nil,
  compile_dir = nil,
}

-- Buffer name for compilation output
local COMPILE_BUF_NAME = "*compilation*"

-- ANSI color code to Neovim highlight group mapping
local ansi_highlights = {
  [30] = "CompileBlack",
  [31] = "CompileRed",
  [32] = "CompileGreen",
  [33] = "CompileYellow",
  [34] = "CompileBlue",
  [35] = "CompileMagenta",
  [36] = "CompileCyan",
  [37] = "CompileWhite",
  [90] = "CompileBrightBlack",
  [91] = "CompileBrightRed",
  [92] = "CompileBrightGreen",
  [93] = "CompileBrightYellow",
  [94] = "CompileBrightBlue",
  [95] = "CompileBrightMagenta",
  [96] = "CompileBrightCyan",
  [97] = "CompileBrightWhite",
}

-- Define highlight groups for ANSI colors
local function setup_highlights()
  local colors = {
    CompileBlack = { fg = "#555555" },
    CompileRed = { fg = "#ff5555" },
    CompileGreen = { fg = "#50fa7b" },
    CompileYellow = { fg = "#f1fa8c" },
    CompileBlue = { fg = "#6272a4" },
    CompileMagenta = { fg = "#ff79c6" },
    CompileCyan = { fg = "#8be9fd" },
    CompileWhite = { fg = "#f8f8f2" },
    CompileBrightBlack = { fg = "#6272a4" },
    CompileBrightRed = { fg = "#ff6e6e" },
    CompileBrightGreen = { fg = "#69ff94" },
    CompileBrightYellow = { fg = "#ffffa5" },
    CompileBrightBlue = { fg = "#d6acff" },
    CompileBrightMagenta = { fg = "#ff92df" },
    CompileBrightCyan = { fg = "#a4ffff" },
    CompileBrightWhite = { fg = "#ffffff" },
    CompileBold = { bold = true },
  }
  for name, opts in pairs(colors) do
    vim.api.nvim_set_hl(0, name, opts)
  end
end

-- Parse ANSI codes and return stripped text + highlight regions
local function parse_ansi(str)
  local regions = {}
  local clean = ""
  local pos = 1
  local current_hl = nil
  local is_bold = false

  -- Remove carriage returns first
  str = str:gsub("\r", "")

  while pos <= #str do
    -- Look for escape sequence
    local esc_start, esc_end, codes = str:find("\027%[([0-9;]*)m", pos)

    if esc_start then
      -- Add text before escape sequence
      if esc_start > pos then
        local text = str:sub(pos, esc_start - 1)
        local start_col = #clean
        clean = clean .. text
        if current_hl then
          table.insert(regions, { start_col, #clean, current_hl })
        end
      end

      -- Parse the SGR codes
      for code in (codes .. ";"):gmatch("([^;]*);") do
        local n = tonumber(code) or 0
        if n == 0 then
          current_hl = nil
          is_bold = false
        elseif n == 1 then
          is_bold = true
        elseif ansi_highlights[n] then
          current_hl = ansi_highlights[n]
          if is_bold and n >= 30 and n <= 37 then
            -- Bold + normal color = bright color
            current_hl = ansi_highlights[n + 60]
          end
        end
      end

      pos = esc_end + 1
    else
      -- No more escape sequences, add remaining text
      local text = str:sub(pos)
      local start_col = #clean
      clean = clean .. text
      if current_hl then
        table.insert(regions, { start_col, #clean, current_hl })
      end
      break
    end
  end

  -- Also strip other non-SGR escape sequences
  clean = clean:gsub("\027%[[0-9;]*[ABCDHJ]", "")
  clean = clean:gsub("\027%[[0-9;]*K", "")
  clean = clean:gsub("\027%[%?[0-9;]*[hl]", "")
  clean = clean:gsub("\027%([AB0-9]", "")

  -- Strip OSC (Operating System Command) sequences
  -- Format: ESC ] ... BEL  or  ESC ] ... ESC \
  -- Common OSC sequences: hyperlinks (OSC 8), window title (OSC 0/2), progress (OSC 9)
  clean = clean:gsub("\027%][^\007\027]*\007", "")      -- OSC terminated by BEL
  clean = clean:gsub("\027%][^\027]*\027\\", "")        -- OSC terminated by ST (ESC \)
  clean = clean:gsub("%]8;[^;]*;[^\007]*\007?", "")     -- OSC 8 hyperlinks (sometimes missing ESC)
  clean = clean:gsub("%]8;;[^\007]*\007?", "")          -- OSC 8 end marker
  clean = clean:gsub("%]9;[^\007\\]*[\007\\]?", "")

  return clean, regions
end

-- Get or create the compilation buffer
local function get_compile_buffer()
  -- Check if buffer exists and is valid
  if state.compile_buf and vim.api.nvim_buf_is_valid(state.compile_buf) then
    return state.compile_buf
  end

  -- Try to find existing buffer by name
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match(COMPILE_BUF_NAME .. "$") then
      state.compile_buf = buf
      return buf
    end
  end

  -- Create new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, COMPILE_BUF_NAME)

  -- Set buffer options
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "compilation"

  state.compile_buf = buf
  return buf
end

-- Open the compilation window
local function open_compile_window()
  local buf = get_compile_buffer()

  -- Check if window is already open with the compilation buffer
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      state.compile_win = win
      return win
    end
  end

  -- Open new split
  vim.cmd(M.config.split_direction .. " " .. M.config.split_size .. "split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)

  -- Set window options
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = true
  vim.wo[win].winfixheight = true

  state.compile_win = win
  return win
end

-- Append lines to the compilation buffer with ANSI color support
local function append_to_buffer(lines, highlights)
  local buf = state.compile_buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local start_line = vim.api.nvim_buf_line_count(buf)

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- Apply highlights if provided
  if highlights then
    for i, regions in ipairs(highlights) do
      local line_num = start_line + i - 1
      for _, region in ipairs(regions) do
        local start_col, end_col, hl_group = region[1], region[2], region[3]
        vim.api.nvim_buf_add_highlight(buf, -1, hl_group, line_num, start_col, end_col)
      end
    end
  end

  -- Auto-scroll if enabled and window is valid
  if M.config.auto_scroll and state.compile_win and vim.api.nvim_win_is_valid(state.compile_win) then
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(state.compile_win, { line_count, 0 })
  end
end

-- Clear the compilation buffer
local function clear_buffer()
  local buf = get_compile_buffer()
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.bo[buf].modifiable = false
end

-- Write header to compilation buffer
local function write_header(cmd, dir)
  local timestamp = os.date("%a %b %d %H:%M:%S")
  local lines = {
    "-*- mode: compilation; default-directory: \"" .. dir .. "\" -*-",
    "Compilation started at " .. timestamp,
    "",
    cmd,
    "",
  }
  vim.bo[state.compile_buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.compile_buf, 0, -1, false, lines)
  vim.bo[state.compile_buf].modifiable = false
end

-- Write footer to compilation buffer
local function write_footer(exit_code)
  local timestamp = os.date("%a %b %d %H:%M:%S")
  local status = exit_code == 0 and "finished" or "exited abnormally with code " .. exit_code
  local lines = {
    "",
    "Compilation " .. status .. " at " .. timestamp,
  }
  append_to_buffer(lines)
end

-- Handle output from the job (real-time streaming)
local function on_output(_, data, _)
  if not data then return end

  local lines = {}
  local all_highlights = {}

  for _, line in ipairs(data) do
    -- jobstart sends empty string as last element for incomplete lines
    if line ~= "" then
      local clean, regions = parse_ansi(line)
      table.insert(lines, clean)
      table.insert(all_highlights, regions)
    end
  end

  if #lines > 0 then
    append_to_buffer(lines, all_highlights)
  end
end

-- Handle job exit
local function on_exit(_, exit_code, _)
  state.current_job_id = nil

  write_footer(exit_code)

  -- Parse errors into quickfix list
  if state.compile_buf and vim.api.nvim_buf_is_valid(state.compile_buf) then
    local lines = vim.api.nvim_buf_get_lines(state.compile_buf, 0, -1, false)
    vim.fn.setqflist({}, " ", {
      title = "Compilation: " .. (state.last_cmd or ""),
      lines = lines,
    })
  end

  if exit_code == 0 then
    vim.notify("Compilation finished successfully", vim.log.levels.INFO)
    if M.config.auto_close_on_success and state.compile_win and vim.api.nvim_win_is_valid(state.compile_win) then
      vim.api.nvim_win_close(state.compile_win, true)
      state.compile_win = nil
    end
  else
    vim.notify("Compilation exited with code " .. exit_code, vim.log.levels.WARN)
  end
end

-- Save all modified buffers
local function save_all_buffers()
  if not M.config.save_before_compile then return end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent write")
        end)
      end
    end
  end
end

-- Kill the current compilation job
function M.kill()
  if state.current_job_id then
    vim.fn.jobstop(state.current_job_id)
    state.current_job_id = nil
    append_to_buffer({ "", "Compilation interrupted" })
    vim.notify("Compilation killed", vim.log.levels.WARN)
    return true
  end
  return false
end

-- Main compile function
function M.compile(cmd)
  -- Kill existing job if running
  if state.current_job_id then
    local choice = vim.fn.confirm("A compilation is running. Kill it?", "&Yes\n&No", 2)
    if choice == 1 then
      M.kill()
    else
      return
    end
  end

  -- Get command from argument or prompt
  if not cmd then
    local prompt = "Compile command"
    if state.last_cmd then
      prompt = prompt .. " [" .. state.last_cmd .. "]"
    end
    prompt = prompt .. ": "

    cmd = vim.fn.input(prompt, "", "shellcmd")
    vim.cmd("redraw") -- Clear the command line

    if cmd == "" then
      if state.last_cmd then
        cmd = state.last_cmd
      else
        vim.notify("No compile command given", vim.log.levels.WARN)
        return
      end
    end
  end

  -- Store command and directory
  state.last_cmd = cmd
  state.compile_dir = vim.fn.getcwd()

  -- Save buffers before compiling
  save_all_buffers()

  -- Prepare compilation buffer
  clear_buffer()
  open_compile_window()
  write_header(cmd, state.compile_dir)

  -- Start the job
  local job_opts = {
    cwd = state.compile_dir,
    on_exit = on_exit,
  }

  -- On Windows, PTY mode causes issues with line wrapping and duplicate chars
  -- Use non-PTY mode with merged stdout/stderr instead
  if vim.fn.has("win32") == 1 then
    job_opts.stdout_buffered = false
    job_opts.stderr_buffered = false
    job_opts.on_stdout = on_output
    job_opts.on_stderr = on_output
    -- Force ANSI color output even without a TTY
    job_opts.env = {
      DOTNET_SYSTEM_CONSOLE_ALLOW_ANSI_COLOR_REDIRECTION = "1",
      FORCE_COLOR = "1",
      CLICOLOR_FORCE = "1",
    }
  else
    -- On Unix, use PTY for real-time unbuffered output with colors
    job_opts.pty = true
    job_opts.on_stdout = on_output
  end

  local job_id = vim.fn.jobstart(cmd, job_opts)

  if job_id <= 0 then
    append_to_buffer({ "Failed to start compilation: " .. cmd })
    vim.notify("Failed to start compilation", vim.log.levels.ERROR)
    return
  end

  state.current_job_id = job_id
end

-- Recompile with last command
function M.recompile()
  if not state.last_cmd then
    vim.notify("No previous compile command", vim.log.levels.WARN)
    M.compile()
    return
  end

  -- Kill existing job without prompting
  if state.current_job_id then
    M.kill()
  end

  M.compile(state.last_cmd)
end

-- Navigate to next error (wraps :cnext)
function M.next_error()
  local ok, err = pcall(vim.cmd, "cnext")
  if not ok then
    vim.notify("No more errors", vim.log.levels.INFO)
  end
end

-- Navigate to previous error (wraps :cprev)
function M.prev_error()
  local ok, err = pcall(vim.cmd, "cprev")
  if not ok then
    vim.notify("No previous errors", vim.log.levels.INFO)
  end
end

-- Go to first error
function M.first_error()
  local ok, err = pcall(vim.cmd, "cfirst")
  if not ok then
    vim.notify("No errors", vim.log.levels.INFO)
  end
end

-- Toggle the compilation window
function M.toggle_window()
  if state.compile_win and vim.api.nvim_win_is_valid(state.compile_win) then
    vim.api.nvim_win_close(state.compile_win, true)
    state.compile_win = nil
  else
    open_compile_window()
  end
end

-- Setup function for configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Initialize ANSI color highlight groups
  setup_highlights()

  -- Set up syntax highlighting for compilation buffer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "compilation",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()

      -- Basic highlighting using vim.fn.matchadd in the window
      vim.api.nvim_create_autocmd("BufWinEnter", {
        buffer = buf,
        callback = function()
          -- Error patterns (red)
          vim.fn.matchadd("DiagnosticError", "\\v^[^:]+:\\d+:\\d*:?\\s*error:.*")
          vim.fn.matchadd("DiagnosticError", "\\v^error(\\[[^\\]]+\\])?:.*")

          -- Warning patterns (yellow)
          vim.fn.matchadd("DiagnosticWarn", "\\v^[^:]+:\\d+:\\d*:?\\s*warning:.*")
          vim.fn.matchadd("DiagnosticWarn", "\\v^warning(\\[[^\\]]+\\])?:.*")

          -- Note/info patterns (blue)
          vim.fn.matchadd("DiagnosticInfo", "\\v^[^:]+:\\d+:\\d*:?\\s*note:.*")

          -- File:line:col patterns (make them stand out)
          vim.fn.matchadd("Directory", "\\v^[^:\\s]+:\\d+")

          -- Compilation status lines
          vim.fn.matchadd("Comment", "\\v^-\\*-.*-\\*-$")
          vim.fn.matchadd("Comment", "\\v^Compilation (started|finished|interrupted).*")
          vim.fn.matchadd("ErrorMsg", "\\v^Compilation exited abnormally.*")
        end,
      })

      -- Buffer-local keymaps for the compilation buffer
      local opts = { buffer = buf, silent = true }
      vim.keymap.set("n", "q", M.toggle_window, opts)
      vim.keymap.set("n", "g", M.kill, opts)
      vim.keymap.set("n", "<CR>", function()
        -- Try to jump to error under cursor
        local line = vim.api.nvim_get_current_line()
        local file, lnum = line:match("^([^:]+):(%d+)")
        if file and lnum then
          -- Close or keep compile window based on preference
          local target_file = file
          if not vim.fn.filereadable(file) then
            target_file = state.compile_dir .. "/" .. file
          end
          if vim.fn.filereadable(target_file) == 1 then
            vim.cmd("wincmd p") -- Go to previous window
            vim.cmd("edit " .. vim.fn.fnameescape(target_file))
            vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
          end
        end
      end, opts)
    end,
  })
end

return M
