local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
    require 'keymap'
else

    require 'plugins'
    require 'opts'
    require 'setup'
    require 'colour'
    require 'telescope-setup'
    require 'treesitter-setup'
    require 'harpoon-setup'
    require 'undotree-setup'
    --require 'lsp-setup'

    require 'compile-mode'

    require 'keymap' -- Keymap should be the last as it depends on other modules
end
