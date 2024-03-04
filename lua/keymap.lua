local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local opts = {noremap = true, silent = true}

-- save with ctrl-s
map('n', '<leader>w', '<cmd>update<CR>', opts)

-- clipboard keybindings
map('', '<leader>y', '"+y', opts)
map('', '<leader>yy', '"+yy', opts)
map('', '<leader>p', '"+p', opts)

-- lsp keybinding
map('n', '<leader>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<leader>.', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
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

map('n', '<leader>m', '<cmd>make<CR>')
