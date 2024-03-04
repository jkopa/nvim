local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

package.path = package.path .. "~/.config/nvim/"

if vim.g.vscode then
    require 'keymap'
else
    require 'plugins'
    require 'opts'
    require 'setup'
    require 'keymap'
    require 'colour'
    require 'telescope-setup'
    require 'treesitter-setup'
    require 'harpoon-setup'
    require 'undotree-setup'
    require 'lsp-setup'
end
