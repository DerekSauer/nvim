-- Mason LSP, Formatter, Dap installer configuration
local M = {
    "williamboman/mason.nvim",
    dependencies = "neovim/nvim-lspconfig",
}

function M.config()
    local mason_settings = {
        ui = {
            border = require("globals").border_style,
        },
    }
    require("mason.settings").set(mason_settings)
end

return M
