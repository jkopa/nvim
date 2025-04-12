-- [[ Set up lazy.nvim package manager ]]
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

-- [[ Basic Settings ]]
-- Load options early, before plugins if they don't depend on plugin features
require 'opts'

-- [[ Configure and Load Plugins with lazy.nvim ]]
-- Setup lazy.nvim and pass the plugin list returned by require('plugins')
require('lazy').setup(require('plugins'), {
  -- Optional: Add lazy.nvim configuration options here if needed
  -- checker = { enabled = true, notify = false }, -- Check for updates daily
  -- performance = { rtp = { disabled_plugins = { ... } } }
})

-- [[ Load Remaining Configurations ]]
-- Load these *after* lazy.nvim has been set up, as they might depend on plugins
if vim.g.vscode then
    -- Special handling for VSCode Neovim integration if needed
    require 'keymap' -- Load keymaps even in VSCode? Adjust as needed.
else
    -- Load configurations for standard Neovim
    require 'setup' -- Load general setup (autocmds)

    -- Load plugin-specific setups (ensure these files exist or comment out)
    require 'telescope-setup'
    require 'treesitter-setup'
    require 'harpoon-setup'
    require 'undotree-setup'

    -- Load custom modes/features
    require 'compile-mode'

    -- Load keymaps last
    require 'keymap'
end

-- Optional: Add a confirmation message at the end
-- print("Neovim config loaded!")
