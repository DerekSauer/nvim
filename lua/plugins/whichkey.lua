local M = {
    -- Keybinding hint popup window.
    "folke/which-key.nvim",
}

function M.config()
    local whichkey = require("which-key")

    local config = {
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 10,
            },
        },
        window = {
            border = require("globals").border_style,
        },
        layout = {
            spacing = 5,
        },
    }

    whichkey.setup(config)
end

return M
