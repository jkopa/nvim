-- Autocommands
local autocmd = vim.api.nvim_create_autocmd

-- Filetype detection for non-standard extensions
autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.xaml",
    command = "set filetype=xml",
})

-- This is for some legacy project where the dev mixed .cpp with .CPP...
autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.CPP",
    command = "set filetype=cpp",
})
