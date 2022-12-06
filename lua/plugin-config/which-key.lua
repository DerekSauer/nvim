local globals = require("globals")
local whichkey = require("which-key")

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
-- We'll define the name of keymap groups for the which-key window here.
whichkey.register({
    e = { name = "File Explorer" },
}, { prefix = "<leader>" })
