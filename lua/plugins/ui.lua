-- UI plugins: theme, notifications, progress, statusline

-- Custom lualine theme matching retro-phosphor (military pale green)
local retro_lualine = {
    normal = {
        a = { fg = "#0a0f0a", bg = "#a0c4a0", gui = "bold" },
        b = { fg = "#a0c4a0", bg = "#0d1a0d" },
        c = { fg = "#7a9a7a", bg = "#0a0f0a" },
    },
    insert = {
        a = { fg = "#0a0f0a", bg = "#ff9500", gui = "bold" },
        b = { fg = "#ff9500", bg = "#0d1a0d" },
    },
    visual = {
        a = { fg = "#0a0f0a", bg = "#7fbf9f", gui = "bold" },
        b = { fg = "#7fbf9f", bg = "#0d1a0d" },
    },
    replace = {
        a = { fg = "#0a0f0a", bg = "#ff6b35", gui = "bold" },
        b = { fg = "#ff6b35", bg = "#0d1a0d" },
    },
    command = {
        a = { fg = "#0a0f0a", bg = "#ffaa33", gui = "bold" },
        b = { fg = "#ffaa33", bg = "#0d1a0d" },
    },
    inactive = {
        a = { fg = "#5a7a5a", bg = "#0a0f0a" },
        b = { fg = "#5a7a5a", bg = "#0a0f0a" },
        c = { fg = "#5a7a5a", bg = "#0a0f0a" },
    },
}

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = retro_lualine,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                    },
                    {
                        -- Show worktree folder name
                        function()
                            local cwd = vim.fn.getcwd()
                            return vim.fn.fnamemodify(cwd, ":t")
                        end,
                        icon = "",
                        cond = function()
                            -- Only show if in a git worktree (not the main repo)
                            local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
                            return git_dir == "" or vim.fn.isdirectory(git_dir) == 0
                        end,
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                    },
                },
                lualine_c = {
                    { "filename", path = 1 }, -- relative path
                },
                lualine_x = { "diagnostics", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },
    {
        -- Retro Phosphor colorscheme (local)
        dir = vim.fn.stdpath("config"),
        name = "retro-phosphor",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("retro-phosphor")
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require("notify")
            notify.setup({
                background_colour = "#0a0f0a",
                stages = "fade_in_slide_out",
                timeout = 3000,
                max_height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
                max_width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
                render = "minimal",
                minimum_width = 50,
            })
            vim.notify = notify
        end,
    },
}
