-- Centralized keymaps
local map = vim.keymap.set

-- [[ Clipboard ]]
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- [[ Window Management ]]
map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>we", "<C-w>=", { desc = "Make windows equal size" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close current window" })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })

-- [[ File Explorer (oil.nvim) ]]
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer (Oil)" })
map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory (Oil)" })

-- [[ Telescope ]]
local builtin = require("telescope.builtin")
map("n", "<leader>pf", function()
    builtin.find_files({
        layout_strategy = "vertical",
        layout_config = {
            width = 0.95,
            height = 0.95,
            preview_height = 0.4,
        },
        path_display = { "absolute" },
        dynamic_preview_title = true,
    })
end, { desc = "Find files" })
map("n", "<C-p>", builtin.git_files, { desc = "Git files" })
map("n", "<leader>pws", function()
    builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
map("n", "<leader>pWs", function()
    builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
end, { desc = "Grep WORD under cursor" })
map("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep search" })
map("v", "<leader>ps", function()
    vim.cmd('noau normal! "vy')
    local selection = vim.fn.getreg("v")
    selection = selection:gsub("\n", "")
    builtin.grep_string({ search = selection })
end, { desc = "Grep visual selection" })

-- [[ Harpoon ]]
local harpoon = require("harpoon")
map("n", "<leader>a", function()
    harpoon:list():add()
end, { desc = "Harpoon: Add file" })
map("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })
map("n", "<leader>1", function()
    harpoon:list():select(1)
end, { desc = "Harpoon: File 1" })
map("n", "<leader>2", function()
    harpoon:list():select(2)
end, { desc = "Harpoon: File 2" })
map("n", "<leader>3", function()
    harpoon:list():select(3)
end, { desc = "Harpoon: File 3" })
map("n", "<leader>4", function()
    harpoon:list():select(4)
end, { desc = "Harpoon: File 4" })
map("n", "<C-S-P>", function()
    harpoon:list():prev()
end, { desc = "Harpoon: Previous" })
map("n", "<C-S-N>", function()
    harpoon:list():next()
end, { desc = "Harpoon: Next" })

-- [[ Undotree ]]
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

-- [[ Git (Fugitive) ]]
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git pull" })
map("n", "<leader>ga", "<cmd>Git add %<CR>", { desc = "Git add current file" })

-- [[ LSP ]]
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- [[ Diagnostics ]]
map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- [[ Quickfix ]]
map("n", "<leader>cn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "<leader>cp", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- [[ Compile Mode ]]
local compile_mode = require("compile-mode")
compile_mode.setup() -- Initialize with defaults
map("n", "<leader>mc", compile_mode.compile, { desc = "Compile" })
map("n", "<leader>mr", compile_mode.recompile, { desc = "Recompile" })
map("n", "<leader>mk", compile_mode.kill, { desc = "Kill compilation" })
map("n", "<leader>mt", compile_mode.toggle_window, { desc = "Toggle compilation window" })
map("n", "<M-n>", compile_mode.next_error, { desc = "Next error" })
map("n", "<M-p>", compile_mode.prev_error, { desc = "Previous error" })

-- [[ Terminal ]]
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Help ]]
map("n", "<leader>?", builtin.keymaps, { desc = "Search keymaps" })
