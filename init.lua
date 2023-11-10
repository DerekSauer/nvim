-- Let the user know that need at least Nvim v0.10.
if vim.fn.has("nvim-0.10") == 0 then
    vim.notify(string.format("Nvim version 0.10 or greater required."), vim.log.levels.ERROR)
end

-- Setup neovim options.
require("nvim_options").setup()

-- Setup my own functions.
require("functions").setup()

-- Setup my own auto comma.nds
require("autocmds").setup()

-- Setup the diagnostics interface.
require("diagnostics").setup()

-- Setup key mappings not handled by Which-key
require("mappings").setup()

-- Setup Lazy to manage plugin installation and configuration.
require("plugin_manager").setup()

-- Set colorscheme
vim.cmd("colorscheme kanagawa")
