-- Telescope fuzzy finder
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-tree/nvim-web-devicons", enabled = true },
    },
    opts = {
        defaults = {
            file_ignore_patterns = { ".git/", ".vs/", ".vscode/", "obj/", "bin/" },
        },
    },
}
