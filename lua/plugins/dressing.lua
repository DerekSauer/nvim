local M = {
    -- Dressing, improve default UI.
    "stevearc/dressing.nvim",
    event = "VeryLazy",
}

function M.config()
    local globals = require("globals")
    local config = {
        input = {
            enabled = true,
            border = globals.border_style,
            default_prompt = ">",
        },
        select = {
            enabled = true,
            backend = { "telescope" },
            telescope = {
                borderchars = globals.telescope_border_style,
                layout_strategy = "cursor",
                layout_config = {
                    width = 0.40,
                    height = 0.25,
                },
            },
        },
    }

    require("dressing").setup(config)
end

return M
