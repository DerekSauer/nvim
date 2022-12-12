local loaded, whichkey = pcall(require, "which-key")

if loaded then
    if whichkey then
        local globals = require("globals")

        local config = {
            plugins = {
                spelling = {
                    enabled = true,
                    suggestions = 10
                }
            },
            window = {
                border = globals.border_style
            },
            layout = {
                spacing = 5
            }
        }

        whichkey.setup(config)
    end
else
    vim.notify("Failed to load plugin: which-key.", vim.log.levels.ERROR)
    whichkey = nil
end
