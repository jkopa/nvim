-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load options first (sets leader key)
require("opts")

-- Setup plugins
require("lazy").setup("plugins")

-- Load remaining config (after plugins)
if not vim.g.vscode then
    require("autocmds")
    require("keymaps")
end
