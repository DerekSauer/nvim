-- Configure list of plugins and their dependencies
return {

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
}
