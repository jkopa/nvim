local map = vim.keymap.set -- Use vim.keymap.set directly
local opts = { noremap = true, silent = true }

-- [[ General ]]
-- Set leader key (ensure this is set before mappings, usually in opts.lua or init.lua)
-- vim.g.mapleader = ' '

-- [[ Clipboard ]]
map({'n', 'v'}, '<leader>y', '"+y', { noremap = true, desc = "Yank to system clipboard" }) -- Yank normal/visual
map('n', '<leader>Y', '"+Y', { noremap = true, desc = "Yank linewise to system clipboard" }) -- Yank line
map({'n', 'v'}, '<leader>p', '"+p', { noremap = true, desc = "Paste from system clipboard" }) -- Paste after
map({'n', 'v'}, '<leader>P', '"+P', { noremap = true, desc = "Paste before from system clipboard" }) -- Paste before

-- [[ LSP Keymaps ]]
-- NOTE: Most LSP keymaps are now defined in the `on_attach` function
-- within the LSP configuration block in `lua/plugins.lua`.
-- This ensures they are only active when an LSP server is attached.
-- You can add buffer-local mappings there if needed for specific LSPs.

-- Keep diagnostic mappings consistent if you prefer them here globally,
-- but defining them in on_attach is generally preferred.
-- map('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
-- map('n', '<leader>dn', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
-- map('n', '<leader>de', vim.diagnostic.open_float, { desc = "Show diagnostic error" })
-- map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Window Management ]]
map('n', '<leader>wv', '<C-w>v', { desc = "Split window vertically" }) -- Easier mnemonic
map('n', '<leader>ws', '<C-w>s', { desc = "Split window horizontally" }) -- Easier mnemonic
map('n', '<leader>we', '<C-w>=', { desc = "Make windows equal size" })
map('n', '<leader>wc', '<C-w>c', { desc = "Close current window" }) -- Easier mnemonic
map('n', '<leader>wh', '<C-w>h', { desc = "Go to left window" })
map('n', '<leader>wj', '<C-w>j', { desc = "Go to lower window" })
map('n', '<leader>wk', '<C-w>k', { desc = "Go to upper window" })
map('n', '<leader>wl', '<C-w>l', { desc = "Go to right window" })

-- [[ File Explorer (Netrw / Oil / NvimTree) ]]
map('n', '<leader>e', '<cmd>Ex<CR>', { desc = "Open File Explorer (Netrw)" }) -- Keep Ex for default

-- [[ Vim Fugitive (Git) ]]
map('n', '<leader>gs', '<cmd>Git<CR>', { desc = "Git Status" })
map('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = "Git Commit" })
map('n', '<leader>gp', '<cmd>Git push<CR>', { desc = "Git Push" })
map('n', '<leader>gl', '<cmd>Git pull<CR>', { desc = "Git Pull" }) -- Add pull
map('n', '<leader>ga', '<cmd>Git add %<CR>', { desc = "Git Add Current File" }) -- Add current file

-- [[ Compile Mode (Custom) ]]
local compile_mode = require("compile-mode")
map('n', '<leader>mc', compile_mode.compile, { noremap = true, silent = true, desc = "Compile Project" })
map('n', '<leader>mr', compile_mode.recompile, { noremap = true, silent = true, desc = "Recompile Project" })

-- [[ Quickfix List Navigation ]]
map('n', '<leader>cn', '<cmd>cnext<CR>', { desc = "Next Quickfix Item" })
map('n', '<leader>cp', '<cmd>cprevious<CR>', { desc = "Previous Quickfix Item" })
map('n', '<leader>co', '<cmd>copen<CR>', { desc = "Open Quickfix List" })
map('n', '<leader>cc', '<cmd>cclose<CR>', { desc = "Close Quickfix List" })

-- [[ Other Mappings ]]
-- (Harpoon, Undotree mappings are in their respective setup files)

-- Map Esc in terminal mode
map('t', '<Esc>', '<C-\\><C-n>', opts)

-- Remap hjkl to neio
-- map('n', 'n', 'h', opts)
-- map('n', 'e', 'j', opts)
-- map('n', 'i', 'k', opts)
-- map('n', 'o', 'l', opts)

-- Remap neio back to hjkl
-- map('n', 'h', 'n', opts)
-- map('n', 'j', 'e', opts)
-- map('n', 'k', 'i', opts)
-- map('n', 'l', 'o', opts)

-- Remap hjkl to neio
-- map('v', 'n', 'h', opts)
-- map('v', 'e', 'j', opts)
-- map('v', 'i', 'k', opts)
-- map('v', 'o', 'l', opts)

-- Remap neio back to hjkl
-- map('v', 'h', 'n', opts)
-- map('v', 'j', 'e', opts)
-- map('v', 'k', 'i', opts)
-- map('v', 'l', 'o', opts)
