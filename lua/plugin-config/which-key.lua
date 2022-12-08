local loaded, whichkey = pcall(require, "which-key")

if not loaded then 
    vim.notify("Failed to load plugin: which-key", vim.log.levels.ERROR)
    whichkey = nil
end

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

    -- Most mappings are defined using the lower level vim.keymap.set() function.
    -- We'll define the name of keymap groups for non-plugin keymaps here
    whichkey.register({
        b = { name = "Buffers" },
    }, { prefix = "<leader>" })
end
