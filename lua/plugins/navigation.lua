-- Navigation and workflow plugins
return {
    "nvim-lua/plenary.nvim",
    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("config.harpoon")
        end,
    },
    "mbbill/undotree",
    "tpope/vim-fugitive",
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local columns = { "icon", "size", "mtime" }
            if vim.fn.has("unix") == 1 then
                table.insert(columns, 2, "permissions")
            end
            require("oil").setup({
                default_file_explorer = true,
                columns = columns,
                view_options = { show_hidden = true },
                keymaps = {
                    ["<CR>"] = "actions.select",
                    ["-"] = "actions.parent",
                    ["g."] = "actions.toggle_hidden",
                },
            })
        end,
    },
}
