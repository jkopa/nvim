-- This file configures nvim-treesitter
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here
  ensure_installed = {
    "bash",
    "c",
    "cpp", -- Added C++
    "css",
    "c_sharp",
    "dockerfile",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline", -- Required for viewing md files properly
    "python",
    "query", -- Required for Treesitter queries development
    "regex",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
    -- Add any other languages you frequently use
   },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you manage parsers manually via :TSInstall
  auto_install = true,

  -- Module configurations
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (e.g., for indentation)
    -- Setting this to true enables both Tree-sitter and regex highlighting,
    -- but might impact performance and cause minor highlighting overlaps.
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true, -- Enable Treesitter-based indentation
  },
  -- Other modules can be enabled here, e.g.:
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = { ... }
  -- },
  -- textobjects = {
  --   select = { ... },
  --   move = { ... },
  -- },
}
