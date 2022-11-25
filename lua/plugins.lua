local packer = require("packer")
local globals = require("globals")

-- Install Packer if needed
local packer_bootstrap = require("bootstrap").ensure_packer()

-- Configure and initialize Packer
packer.startup({
    -- List plugins to be managed by Packer
    function(use)
        -- Packer will manage itself
        use "wbthomason/packer.nvim"

        -- Nightfox colorscheme
        -- https://github.com/EdenEast/nightfox.nvim
        use {
            "EdenEast/nightfox.nvim",
            after = "packer.nvim",
            config = function() require("plugin-config/nightfox") end
        }
    end,

    config = {
        max_jobs = 20,
        display = {
            open_fn = function()
                return require("packer.util").float({ border = globals.border_style })
            end,
            prompt_border = globals.border_style
        },
        log = { level = "error" }
    }
})

-- If Packer was installed by ensure_packer(), sync our plugins
if packer_bootstrap then
    packer.sync()
end
