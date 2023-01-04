-- Install Packer if needed
local packer_bootstrap = require("bootstrap").ensure_packer()

local packer_ok, packer = pcall(require, "packer")

if packer_ok then
    local globals = require("globals")

    -- Configure and initialize Packer
    packer.startup({
        -- List of plugins to be managed by Packer
        function(use)
            -- Packer will manage itself
            use("wbthomason/packer.nvim")

            -- Impatient - Improve startup time by caching modules
            -- https://github.com/lewis6991/impatient.nvim
            use({
                "lewis6991/impatient.nvim",
                after = "packer.nvim",
                config = function() require("impatient") end,
            })

            -- Sync system clipboard with Neovim
            -- https://github.com/EtiamNullam/deferred-clipboard.nvim
            use({
                "EtiamNullam/deferred-clipboard.nvim",
                config = function() require("deferred-clipboard").setup() end,
            })

            -- Kanagawa colorscheme
            -- https://github.com/rebelot/kanagawa.nvim
            use({
                "rebelot/kanagawa.nvim",
            })

            -- Dressing, improve default UI
            -- https://github.com/stevearc/dressing.nvim
            use({
                "stevearc/dressing.nvim",
                config = function() require("plugin-config/dressing") end,
            })

            -- Status line
            -- https://github.com/nvim-lualine/lualine.nvim
            use({
                "nvim-lualine/lualine.nvim",
                requires = { "nvim-tree/nvim-web-devicons" },
                config = function() require("plugin-config/lualine") end,
            })

            -- Telescope fuzzy finder
            -- https://github.com/nvim-telescope/telescope.nvim
            use({
                "nvim-telescope/telescope.nvim",
                requires = {
                    "nvim-lua/plenary.nvim",
                    "nvim-telescope/telescope-frecency.nvim",
                    "nvim-telescope/telescope-project.nvim",
                    "nvim-telescope/telescope-dap.nvim",
                    "nvim-tree/nvim-web-devicons",
                    "kkharji/sqlite.lua",
                },
                config = function() require("plugin-config/telescope") end,
            })

            -- Neo-tree file drawer
            -- https://github.com/nvim-neo-tree/neo-tree.nvim
            use({
                "nvim-neo-tree/neo-tree.nvim",
                branch = "v2.x",
                requires = {
                    "nvim-lua/plenary.nvim",
                    "nvim-tree/nvim-web-devicons",
                    "MunifTanjim/nui.nvim",
                },
                config = function() require("plugin-config/neo-tree") end,
            })

            -- Treesitter configurations and abstraction layer
            -- https://github.com/nvim-treesitter/nvim-treesitter
            use({
                "nvim-treesitter/nvim-treesitter",
                run = function() vim.cmd("TSUpdate") end,
                requires = {
                    -- Autoclose HTML,CSS tags
                    -- https://github.com/windwp/nvim-ts-autotag
                    "windwp/nvim-ts-autotag",

                    -- Automatically add closing operators to textual languages (Lua, Ruby, etc...)
                    -- https://github.com/RRethy/nvim-treesitter-endwise
                    "RRethy/nvim-treesitter-endwise",
                },
                config = function() require("plugin-config/treesitter") end,
            })

            -- Keybinding hint popup window
            -- https://github.com/folke/which-key.nvim
            use({
                "folke/which-key.nvim",
                config = function() require("plugin-config/which-key") end,
            })

            -- Git diffs and signs in gutter
            -- https://github.com/lewis6991/gitsigns.nvim
            use({
                "lewis6991/gitsigns.nvim",
                event = "BufEnter",
                config = function() require("plugin-config/gitsigns") end,
            })

            -- Smart code commenting
            -- https://github.com/numToStr/Comment.nvim
            use({
                "numToStr/Comment.nvim",
                config = function() require("plugin-config/comment") end,
            })

            -- Easy code annotations.
            -- https://github.com/danymat/neogen/
            use({
                "danymat/neogen",
                requires = "nvim-treesitter/nvim-treesitter",
                config = function() require("plugin-config/neogen") end,
            })

            -- Automatic pair (parens, brackets, etc...) insertion
            -- https://github.com/windwp/nvim-autopairs
            use({
                "windwp/nvim-autopairs",
                config = function() require("plugin-config/autopairs") end,
            })

            -- Indent guides
            -- https://github.com/lukas-reineke/indent-blankline.nvim
            use({
                "lukas-reineke/indent-blankline.nvim",
                event = "BufEnter",
                config = function() require("plugin-config/indentline") end,
            })

            -- Lsp Setup and completions
            -- https://github.com/VonHeikemen/lsp-zero.nvim
            use({
                "VonHeikemen/lsp-zero.nvim",
                requires = {
                    -- LSP Support
                    { "neovim/nvim-lspconfig" },
                    { "williamboman/mason.nvim" },
                    { "williamboman/mason-lspconfig.nvim" },
                    { "lukas-reineke/lsp-format.nvim" },
                    {
                        "jose-elias-alvarez/null-ls.nvim",
                        requires = "nvim-lua/plenary.nvim",
                    },

                    -- Autocompletion
                    { "hrsh7th/nvim-cmp" },
                    { "hrsh7th/cmp-buffer" },
                    { "hrsh7th/cmp-path" },
                    { "saadparwaiz1/cmp_luasnip" },
                    { "hrsh7th/cmp-nvim-lsp" },
                    { "hrsh7th/cmp-nvim-lua" },
                    { "hrsh7th/cmp-nvim-lsp-signature-help" },
                    { "onsails/lspkind.nvim" },

                    -- Snippets
                    { "L3MON4D3/LuaSnip" },
                    { "rafamadriz/friendly-snippets" },

                    -- Code context
                    { "SmiteshP/nvim-navic" },
                },
                config = function() require("plugin-config/lsp") end,
            })

            -- Debug adapter
            -- https://github.com/mfussenegger/nvim-dap
            use({
                "mfussenegger/nvim-dap",
                requires = {
                    "rcarriga/nvim-dap-ui",
                    "theHamsta/nvim-dap-virtual-text",
                    "nvim-treesitter/nvim-treesitter",
                },
                config = function() require("plugin-config/dap") end,
            })
        end,

        config = {
            max_jobs = 20,
            display = {
                open_fn = function()
                    return require("packer.util").float({ border = globals.border_style })
                end,
                prompt_border = globals.border_style,
            },
            log = { level = "error" },
        },
    })
else
    vim.notify("Failed to load Packer plugin manager.", vim.log.levels.ERROR)
    packer = nil
end

-- If Packer was installed by ensure_packer(), sync our plugins
if packer_bootstrap then
    if packer ~= nil then packer.sync() end
end
