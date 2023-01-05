-- Configure list of plugins and their dependencies
return {
    -- Kanagawa colorscheme
    -- https://github.com/rebelot/kanagawa.nvim
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function() require("colorscheme") end,
    },

    -- Sync system clipboard with Neovim
    -- https://github.com/EtiamNullam/deferred-clipboard.nvim
    {
        "EtiamNullam/deferred-clipboard.nvim",
        config = function() require("deferred-clipboard").setup() end,
    },

    -- Dressing, improve default UI
    -- https://github.com/stevearc/dressing.nvim
    {
        "stevearc/dressing.nvim",
        config = function() require("plugin-config/dressing") end,
    },

    -- Telescope fuzzy finder
    -- https://github.com/nvim-telescope/telescope.nvim
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            "nvim-telescope/telescope-project.nvim",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-tree/nvim-web-devicons",
            "kkharji/sqlite.lua",
        },
        config = function() require("plugin-config/telescope") end,
    },

    -- Neo-tree file drawer
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function() require("plugin-config/neo-tree") end,
    },

    -- Treesitter configurations and abstraction layer
    -- https://github.com/nvim-treesitter/nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            -- Autoclose HTML,CSS tags
            -- https://github.com/windwp/nvim-ts-autotag
            "windwp/nvim-ts-autotag",

            -- Automatically add closing operators to textual languages (Lua, Ruby, etc...)
            -- https://github.com/RRethy/nvim-treesitter-endwise
            "RRethy/nvim-treesitter-endwise",
        },
        config = function() require("plugin-config/treesitter") end,
    },

    -- Keybinding hint popup window
    -- https://github.com/folke/which-key.nvim
    {
        "folke/which-key.nvim",
        config = function() require("plugin-config/which-key") end,
    },

    -- Git diffs and signs in gutter
    -- https://github.com/lewis6991/gitsigns.nvim
    {
        "lewis6991/gitsigns.nvim",
        event = "BufEnter",
        config = function() require("plugin-config/gitsigns") end,
    },

    -- Smart code commenting
    -- https://github.com/numToStr/Comment.nvim
    {
        "numToStr/Comment.nvim",
        config = function() require("plugin-config/comment") end,
    },

    -- Easy code annotations.
    -- https://github.com/danymat/neogen/
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function() require("plugin-config/neogen") end,
    },

    -- Automatic pair (parens, brackets, etc...) insertion
    -- https://github.com/windwp/nvim-autopairs
    {
        "windwp/nvim-autopairs",
        config = function() require("plugin-config/autopairs") end,
    },

    -- Indent guides
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufEnter",
        config = function() require("plugin-config/indentline") end,
    },

    -- Lsp Setup and completions
    -- https://github.com/VonHeikemen/lsp-zero.nvim
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "lukas-reineke/lsp-format.nvim" },
            {
                "jose-elias-alvarez/null-ls.nvim",
                dependencies = "nvim-lua/plenary.nvim",
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
    },

    -- Debug adapter
    -- https://github.com/mfussenegger/nvim-dap
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function() require("plugin-config/dap") end,
    },
}
