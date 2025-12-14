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
}
