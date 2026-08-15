-- LSP (completion is built in as of 0.12, see config/lsp.lua)
return {
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "razor" },
        opts = {
            choose_target = function(targets)
                local cache_file = vim.fn.stdpath("data") .. "/roslyn_solution_cache.json"
                local cwd = vim.fn.getcwd()

                -- Load cache
                local cache = {}
                local f = io.open(cache_file, "r")
                if f then
                    local content = f:read("*a")
                    f:close()
                    cache = vim.json.decode(content) or {}
                end

                -- Check if we have a cached solution for this directory
                local cached = cache[cwd]
                if cached then
                    for _, target in ipairs(targets) do
                        if target == cached then
                            return target
                        end
                    end
                end

                -- Not cached or invalid, prompt user
                local choices = { "Select solution:" }
                for i, target in ipairs(targets) do
                    table.insert(choices, string.format("%d. %s", i, vim.fn.fnamemodify(target, ":~:.")))
                end

                local choice = vim.fn.inputlist(choices)
                if choice > 0 and choice <= #targets then
                    local selected = targets[choice]
                    -- Save to cache
                    cache[cwd] = selected
                    f = io.open(cache_file, "w")
                    if f then
                        f:write(vim.json.encode(cache))
                        f:close()
                    end
                    return selected
                end

                return targets[1]
            end,
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- mason moved from williamboman/ to the mason-org/ organisation
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            require("config.lsp")
        end,
    },
}
