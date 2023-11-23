-- Let the user know that need at least Neovim v0.10.
if vim.fn.has("nvim-0.10") == 0 then
    vim.notify(string.format("Nvim version 0.10 or greater required."), vim.log.levels.ERROR)
end

-- Setup Neovim options.
require("nvim_options").setup()

-- Set up my own functions.
require("functions").setup()

-- Set up my own auto commands
require("autocmds").setup()

-- Set up the diagnostics interface.
require("diagnostics").setup()

-- Set up key mappings not handled by Which-key.
require("mappings").setup()

-- Set up Lazy to manage plugin installation and configuration.
require("plugin_manager").setup()

-- Set colour scheme.
vim.cmd("colorscheme kanagawa")
