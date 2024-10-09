local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local opts = {noremap = true, silent = true}

-- clipboard keybindings
map('', '<leader>y', '"+y', opts)
map('', '<leader>yy', '"+yy', opts)
map('', '<leader>p', '"+p', opts)

-- lsp keybinding
map('n', '<leader>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<leader>.', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<leader>ho', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>re', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-- windowing
map('n', '<leader>w', '<C-w>')

-- netrw
map('n', '<leader>pv', '<cmd>Ex<CR>')

-- vim fugitive
map('n', '<leader>gs', '<cmd>Git<CR>')
map('n', '<leader>gc', '<cmd>Git commit<CR>')
map('n', '<leader>gp', '<cmd>Git push<CR>')

--map('n', '<C-m>', '<cmd>m -2<CR>')
--map('n', '<C-n>', '<cmd>m +1<CR>')

map('n', '<leader>c', ':lua require("compile-mode").compile()<CR>', opts)
map('n', '<leader>n', '<CMD>cnext<CR>', opts)

-- Remap hjkl to neio
--map('n', 'n', 'h', opts)
--map('n', 'e', 'j', opts)
--map('n', 'i', 'k', opts)
--map('n', 'o', 'l', opts)

-- Remap neio back to hjkl
--map('n', 'h', 'n', opts)
--map('n', 'j', 'e', opts)
--map('n', 'k', 'i', opts)
--map('n', 'l', 'o', opts)

-- Remap hjkl to neio
--map('v', 'n', 'h', opts)
--map('v', 'e', 'j', opts)
--map('v', 'i', 'k', opts)
--map('v', 'o', 'l', opts)

-- Remap neio back to hjkl
--map('v', 'h', 'n', opts)
--map('v', 'j', 'e', opts)
--map('v', 'k', 'i', opts)
--map('v', 'l', 'o', opts)
