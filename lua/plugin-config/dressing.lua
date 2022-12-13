local dressing_ok, dressing = pcall(require, "dressing")

if dressing_ok then
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
                borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                layout_strategy = "cursor",
                layout_config = {
                    width = 0.40,
                    height = 0.25,
                },
            },
        },
    }

    dressing.setup(config)
else
    vim.notify("Failed to load plugin: dressing.", vim.log.levels.ERROR)
    dressing = nil
end
