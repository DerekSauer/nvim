-- Mason LSP, Formatter, Dap installer configuration
local M = {}

function M.setup()
    local mason_ok, mason = pcall(require, "mason.settings")
    if mason_ok then
        local mason_settings = {
            ui = {
                border = require("globals").border_style,
            },
        }
        mason.set(mason_settings)
    end
end

return M
