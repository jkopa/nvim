-- [[ Neovim Options ]]
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt -- Use opt for options

-- [[ Global Variables ]]
g.mapleader = ' ' -- Set leader key to Space
g.maplocalleader = '\\' -- Set local leader key

-- [[ Editor Behavior ]]
opt.termguicolors = true -- Enable true color support
opt.guicursor = "" -- Use terminal cursor shape
opt.wrap = false -- Do not wrap lines
opt.mouse = "a" -- Enable mouse support in all modes
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.undofile = true -- Enable persistent undo
opt.swapfile = false -- Disable swap file (personal preference)
opt.backup = false -- Disable backup file (personal preference)
opt.showmode = false -- Don't show mode indicator (handled by status line)
opt.confirm = true -- Ask for confirmation when quitting with unsaved changes

-- [[ Search ]]
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if search pattern has uppercase letters
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search results incrementally
opt.inccommand = "split" -- Show substitutions live in a preview window

-- [[ Indentation ]]
local indent = 4
opt.tabstop = indent
opt.softtabstop = indent
opt.shiftwidth = indent
opt.expandtab = true -- Use spaces instead of tabs
opt.autoindent = true -- Copy indent from current line when starting a new line
opt.smartindent = true -- Be smarter about indentation

-- [[ Display ]]
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.signcolumn = "yes" -- Always show the sign column (for diagnostics, git signs)
opt.cursorline = true -- Highlight the current line
opt.list = true -- Show invisible characters
opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣', extends = '»', precedes = '«' } -- Define invisible characters
opt.scrolloff = 8 -- Keep cursor 8 lines away from top/bottom edge
opt.sidescrolloff = 8 -- Keep cursor 8 columns away from left/right edge
opt.splitright = true -- Open vertical splits to the right
opt.splitbelow = true -- Open horizontal splits below
opt.colorcolumn = "100" -- Show column marker at 100 columns
opt.pumheight = 10 -- Max number of items in completion menu

-- [[ Performance / Responsiveness ]]
opt.updatetime = 250 -- Faster completion updates, updates SignatureHelp sooner
opt.timeoutlen = 300 -- Shorter timeout for key sequences (e.g., leader key)
opt.ttimeoutlen = 10 -- Time in ms to wait for sequence like <Esc>

opt.cmdheight = 1 -- Always show command line (prevents flickering)

-- [[ Windows Specific Shell Settings ]]
if vim.fn.has("win32") == 1 then
    opt.shell = 'powershell.exe'
    opt.shellquote = ''
    opt.shellxquote = ''
    opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
    opt.shellpipe = '| Out-File -Encoding UTF8 %s'
    opt.shellredir = '| Out-File -Encoding UTF8 %s'
end
