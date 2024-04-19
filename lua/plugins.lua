require('lazy').setup({
    'nvim-lua/plenary.nvim',
    'wbthomason/packer.nvim',
    --use 'rust-lang/rust.vim'

    { 'nvim-telescope/telescope.nvim', tag = '0.1.6' },
    { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" },

    'nvim-treesitter/nvim-treesitter-context',

    'nvim-treesitter/playground',
    'theprimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',

    'github/copilot.vim',

    'effkay/argonaut.vim',

    'j-hui/fidget.nvim',

      -- LSP Support
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',

      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',

    {'neovim/nvim-lspconfig',
          config = function()
              local cmp = require('cmp')
              local cmp_lsp = require("cmp_nvim_lsp")
              local capabilities = vim.tbl_deep_extend(
              "force",
              {},
              vim.lsp.protocol.make_client_capabilities(),
              cmp_lsp.default_capabilities())

              require("fidget").setup({})
              require("mason").setup()
              require("mason-lspconfig").setup({
                  ensure_installed = {
                      "lua_ls",
                      "rust_analyzer",
                      "gopls",
                  },
                  handlers = {
                      function(server_name) -- default handler (optional)

                          require("lspconfig")[server_name].setup {
                              capabilities = capabilities
                          }
                      end,

                      ["lua_ls"] = function()
                          local lspconfig = require("lspconfig")
                          lspconfig.lua_ls.setup {
                              capabilities = capabilities,
                              settings = {
                                  Lua = {
                                      runtime = { version = "Lua 5.1" },
                                      diagnostics = {
                                          globals = { "vim", "it", "describe", "before_each", "after_each" },
                                      }
                                  }
                              }
                          }
                      end,
                  }
              })

              local cmp_select = { behavior = cmp.SelectBehavior.Select }

              cmp.setup({
                  snippet = {
                      expand = function(args)
                          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                      end,
                  },
                  mapping = cmp.mapping.preset.insert({
                      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                      ["<C-Space>"] = cmp.mapping.complete(),
                  }),
                  sources = cmp.config.sources({
                      { name = 'nvim_lsp' },
                      { name = 'luasnip' }, -- For luasnip users.
                  }, {
                      { name = 'buffer' },
                  })
              })

              vim.diagnostic.config({
                  -- update_in_insert = true,
                  float = {
                      focusable = false,
                      style = "minimal",
                      border = "rounded",
                      source = "always",
                      header = "",
                      prefix = "",
                  },
              })
          end


      }
})
