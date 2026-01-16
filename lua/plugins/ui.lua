-- UI plugins: theme, notifications, progress, statusline
return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "catppuccin",
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
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            flavour = "mocha", -- dark with pastel accents
            transparent_background = true,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
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
                background_colour = "#1E1E2E",
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
