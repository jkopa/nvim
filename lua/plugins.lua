-- This file defines the plugins managed by lazy.nvim

return { -- Return the plugin list for lazy.nvim

    -- Core dependencies / Utilities
    'nvim-lua/plenary.nvim', -- Utility library required by Telescope, etc.

    -- Filetype specific (keep if needed, LSP/Treesitter handle much now)
    'rust-lang/rust.vim',

    -- Telescope (Fuzzy Finder)
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Optional: for icons in Telescope (ensure Nerd Font installed)
            { 'nvim-tree/nvim-web-devicons', enabled = true },
        },
        -- Configuration is now handled in lua/telescope-setup.lua,
        -- but you could move it here if preferred.
        -- config = function() ... end
    },

    -- Treesitter (Syntax engine)
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        -- Configuration is handled in lua/treesitter-setup.lua
        -- config = function() ... end
    },
    { -- Optional: Show Treesitter context
        'nvim-treesitter/nvim-treesitter-context',
        opts = {}, -- Enable with default settings
    },
    'nvim-treesitter/playground', -- Treesitter helper/visualizer

    -- Navigation / Workflow
    'theprimeagen/harpoon', -- Configuration in lua/harpoon-setup.lua
    'mbbill/undotree', -- Configuration in lua/undotree-setup.lua
    'tpope/vim-fugitive', -- Git wrapper (config via keymap.lua)

    -- UI / Theme
    { -- Colorscheme - Load first
        'blazkowolf/gruber-darker.nvim',
        lazy = false, -- Make sure it loads first
        priority = 1000, -- Make sure it loads before other plugins
        config = function()
            -- Load the colorscheme
            vim.cmd.colorscheme 'gruber-darker'
            -- Apply transparency settings (moved from colour.lua)
            vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
            vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none"}) -- Example for NvimTree if you use it
        end,
    },
    { -- LSP progress indicator
        'j-hui/fidget.nvim',
        opts = {
            -- Fidget options can be configured here
            -- notification = { window = { winblend = 0 } } -- Example option
        },
    },
    { -- Notification manager
        "rcarriga/nvim-notify",
        opts = {
            stages = "fade_in_slide_out",
            timeout = 3000,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width = function() return math.floor(vim.o.columns * 0.75) end,
            render = "minimal",
            minimum_width = 50,
        },
        config = function(_, opts)
            vim.notify = require("notify")
            require("notify").setup(opts)
        end,
    },

    -- LSP / Language Support Setup
    'williamboman/mason.nvim',           -- Installs LSPs, Linters, Formatters
    'williamboman/mason-lspconfig.nvim', -- Bridges mason and lspconfig
    'neovim/nvim-lspconfig',             -- Core LSP configuration

    -- Autocompletion Engine
    'hrsh7th/nvim-cmp', -- Core completion engine
    'hrsh7th/cmp-buffer', -- Buffer completions
    'hrsh7th/cmp-path',   -- Path completions
    'hrsh7th/cmp-nvim-lsp', -- LSP completions
    'hrsh7th/cmp-nvim-lua', -- Lua completions (for Neovim config)
    'saadparwaiz1/cmp_luasnip', -- Snippet completions for LuaSnip
    -- Removed duplicate hrsh7th/cmp-nvim-lsp

    -- In lua/plugins.lua
    {
        'L3MON4D3/LuaSnip',
        -- follow latest release.
        version = "v2.*",
        -- build = "make install_jsregexp", -- Build step removed/commented out
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            -- Tell LuaSnip to load snippets from friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Optional: Adjust LuaSnip options if needed
            require("luasnip").config.setup({
                -- history = true,
                -- updateevents = "TextChanged,TextChangedI"
            })
        end,
    },
    'rafamadriz/friendly-snippets', -- Snippet collection

    -- Optional: Icons for completion menu
    { 'onsails/lspkind.nvim' },


    -- LSP/CMP Configuration Block
    -- This entry configures lspconfig, mason, cmp after they are loaded
    {
        'neovim/nvim-lspconfig', -- Specify again to attach config logic
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'j-hui/fidget.nvim',
            'L3MON4D3/LuaSnip', -- Ensure LuaSnip is loaded for cmp setup
            -- Optional: lspkind for icons
            'onsails/lspkind.nvim',
        },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local lspconfig = require("lspconfig")
            local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

            -- Define the on_attach function for common LSP setup (keymaps, etc.)
            local on_attach = function(client, bufnr)
                -- Standard LSP keymaps (use buffer-local mappings)
                local opts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- Use Ctrl-k instead of C-h if preferred
                vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts) -- Use <leader> instead of <space>
                vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
                vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts) -- Use <leader>
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Use <leader>
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts) -- Use <leader>

                -- Diagnostic keymaps (use <leader>d prefix)
                vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts) -- <leader>diagnostic prev
                vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, opts) -- <leader>diagnostic next
                vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, opts) -- <leader>diagnostic error/float
                vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts) -- <leader>diagnostic list

                -- Fidget attach
                -- Inside the on_attach function:
                local fidget_ok, fidget = pcall(require, 'fidget')
                if fidget_ok and fidget and fidget.attach then -- Also check if attach function exists
                    fidget.attach(client)
                end

            end

            -- Configure diagnostics
            vim.diagnostic.config({
                virtual_text = false, -- Disable virtual text diagnostics
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Setup Mason
            require("mason").setup()

            -- Setup Mason-LSPConfig
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    -- Add other LSPs here e.g., "pyright", "gopls", "clangd"
                },
                handlers = {
                    -- Default handler: Sets up servers with capabilities and on_attach
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,
                    -- Custom handler for lua_ls
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    runtime = { version = 'LuaJIT' }, -- Match Neovim's Lua
                                    diagnostics = { globals = { 'vim' } },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false, -- Avoid indexing huge directories
                                    },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                    end,
                },
            })

            -- Configure nvim-cmp
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind') -- Requires 'onsails/lspkind.nvim'

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection with Enter
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { "i", "s" }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { "i", "s" }),
                    -- Your previous C-p/C-n/C-y mappings can be added back here if preferred
                    -- ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    -- ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    -- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                }, {
                        { name = 'buffer', keyword_length = 5 }, -- Show buffer completions after 5 chars
                    }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text', -- Show symbol and text
                        maxwidth = 50,
                        ellipsis_char = '...',
                        -- Optional: Menu highlighting based on completion kind
                        -- LspKind can be used to override preset symbols and customize formatting
                        -- LspKind = { ... }
                    })
                }
            })
        end, -- End of LSP/CMP config function
    }, -- End of LSP/CMP plugin block

    -- AIIIIII
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        build = "make", 
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim',
            'MunifTanjim/nui.nvim',
            'MeanderingProgrammer/render-markdown.nvim',
            'hrsh7th/nvim-cmp',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            provider = "gemini", -- Set Gemini as the default provider
            gemini = {
                -- As found in search results
                model = "gemini-2.5-pro-exp-03-25",
                timeout = 30000, -- Timeout in milliseconds
                temperature = 0,
                max_tokens = 8192, -- Max tokens for the response
            },
        },
        config = function(_, opts)
            require("avante").setup(opts)
        end
    },

} -- End of plugin list
