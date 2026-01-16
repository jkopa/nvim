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
        "polarmutex/git-worktree.nvim",
        version = "^2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("git_worktree")

            local Hooks = require("git-worktree.hooks")

            -- Use built-in hook to update current buffer when switching worktrees
            Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
        end,
    },
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
