-- LSP configuration (keymaps in keymaps.lua)
--
-- Nvim 0.12 native LSP: servers are declared with `vim.lsp.config()` and turned
-- on with `vim.lsp.enable()`. The old `lspconfig[server].setup()` framework API
-- and mason-lspconfig's `handlers` table are both gone -- mason-lspconfig v2
-- only understands `ensure_installed` and `automatic_enable`.

-- [[ Diagnostics ]]
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true, -- was "always", deprecated in 0.11
        header = "",
        prefix = "",
    },
})

-- [[ Server settings ]]
-- `vim.lsp.config()` merges on top of the defaults nvim-lspconfig ships, so we
-- only need to state what differs.
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config("roslyn", {})

-- [[ Mason ]]
require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

-- `automatic_enable` defaults to true, which calls vim.lsp.enable() for every
-- installed server, picking up the vim.lsp.config() settings above.
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
})

-- [[ Completion ]]
-- Built-in LSP completion replaces nvim-cmp. Snippet expansion is handled by
-- vim.snippet, which is part of core.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspCompletion", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
                autotrigger = true,
            })
        end
    end,
})
