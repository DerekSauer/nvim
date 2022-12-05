local globals = require("globals")
local packer = require("packer")

-- Configure and initialize Packer
packer.startup({
    -- List plugins to be managed by Packer
    function(use)
        -- Packer will manage itself
        use "wbthomason/packer.nvim"

        -- Impatient - Improve startup time by caching modules
        -- https://github.com/lewis6991/impatient.nvim
        use {
            "lewis6991/impatient.nvim",
            after = "packer.nvim",
            config = function() require("impatient") end
        }

        -- Catppuccin colorscheme
        -- https://github.com/catppuccin/nvim
        use {
            "catppuccin/nvim",
            after = "packer.nvim",
            config = function() require("plugin-config/colorscheme") end
        }

        -- Neo-tree file drawer
        -- https://github.com/nvim-neo-tree/neo-tree.nvim
        use {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = { 
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
            config = function() require("plugin-config/neo-tree") end
        }

        -- Treesitter configurations and abstraction layer
        -- https://github.com/nvim-treesitter/nvim-treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = function() vim.cmd("TSUpdate<CR>") end,
            config = function() require("plugin-config/treesitter") end
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
if PACKER_BOOTSTRAP then
    packer.sync()
end
