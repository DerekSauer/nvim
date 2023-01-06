-- Configure list of plugins and their dependencies
return {
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

    -- Automatic pair (parens, brackets, etc...) insertion
    -- https://github.com/windwp/nvim-autopairs
    {
        "windwp/nvim-autopairs",
        config = function() require("plugin-config/autopairs") end,
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
