-- Treesitter configuration
--
-- The `main` branch of nvim-treesitter is a full rewrite: `setup()` accepts only
-- `install_dir`, parsers are installed with `install()`, and no features are
-- enabled automatically. Highlighting itself is core's (`vim.treesitter.start()`),
-- so we opt in per-buffer below.

local languages = {
    "bash",
    "c",
    "cpp",
    "css",
    "c_sharp",
    "dockerfile",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
}

-- Asynchronous, and a no-op for parsers that are already installed.
require("nvim-treesitter").install(languages)

-- Start treesitter highlighting for any buffer whose language has a parser.
-- pcall keeps filetypes without a parser silent rather than erroring.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- Treesitter indentation is still experimental upstream, so it stays off and
-- 'smartindent' (see opts.lua) keeps handling indents. To try it, add this to
-- the callback above:
--     vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
