-- Plugin specifications aggregator
-- lazy.nvim auto-imports all files in this directory
return {
    { import = "plugins.telescope" },
    { import = "plugins.treesitter" },
    { import = "plugins.lsp" },
    { import = "plugins.ui" },
    { import = "plugins.navigation" },
    { import = "plugins.dap" },
}
