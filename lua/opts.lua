local cmd           = vim.cmd
local fn            = vim.fn
local g             = vim.g

local indent        = 4

vim.opt.termguicolors = true

vim.opt.guicursor   = ""
vim.opt.wrap        = false


vim.o.ruler         = false
vim.o.wildmode      = 'list:longest'
vim.o.hidden        = true
vim.o.joinspaces    = false
vim.o.completeopt   = 'menuone,noinsert,noselect'

--vim.wo.number       = false
vim.o.number            = true
vim.wo.relativenumber   = true

vim.o.tabstop       = indent
vim.bo.tabstop      = indent
vim.o.softtabstop   = indent
vim.bo.softtabstop  = indent
vim.o.shiftwidth    = indent
vim.bo.shiftwidth   = indent
vim.o.autoindent    = true
vim.bo.autoindent   = true
vim.o.expandtab     = true
vim.bo.expandtab    = true

--enable mouse inputs
vim.o.mouse         = 'a'

-- sets space as leader key for use in binds.lua
g.mapleader         = ' '

cmd('language en_GB.utf-8')
cmd('set colorcolumn=90')
--vim.g.spell.spelllang = 'en_gb'
vim.o.listchars     = 'tab:|-,nbsp:~,trail:$'
vim.wo.list         = true

-- Plugin options
--g.rustfmt_autosave = 1
--g['deoplete#enable_at_startup'] = 1

-- theme, colorscheme, color
--cmd('colorscheme peachpuff')

if (vim.fn.has('win32')) then
    vim.opt.shellcmdflag = '-c'
end
