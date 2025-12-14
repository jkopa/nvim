-- Debug Adapter Protocol (disabled - enable when ready)
return {
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        config = function()
            require("config.dap")
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        enabled = false,
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    },
}
