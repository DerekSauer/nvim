local M = {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
        { "lukas-reineke/lsp-format.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
        { "jose-elias-alvarez/null-ls.nvim", dependencies = "nvim-lua/plenary.nvim" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer", dependencies = "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-path", dependencies = "hrsh7th/nvim-cmp" },
        { "saadparwaiz1/cmp_luasnip", dependencies = "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp", dependencies = "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua", dependencies = "hrsh7th/nvim-cmp" },
        { "onsails/lspkind.nvim", dependencies = "hrsh7th/nvim-cmp" },
        { "ray-x/lsp_signature.nvim", dependencies = "hrsh7th/nvim-cmp" },

        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets", dependencies = "L3MON4D3/LuaSnip" },

        -- Context
        { "SmiteshP/nvim-navic" },
        { "kosayoda/nvim-lightbulb" },
        { "simrat39/symbols-outline.nvim" },
    },
}

function M.config()
    local lsp_zero = require("lsp-zero")

    -- Use recommended LSP settings and add nvim's API
    lsp_zero.preset("recommended")
    lsp_zero.nvim_workspace()

    -- We'll create our own keymaps based on LSP capabilities
    lsp_zero.set_preferences({
        set_lsp_keymaps = false,
    })

    -- Setup language servers
    require("plugins/lsp/sumneko_lua").setup(lsp_zero)
    require("plugins/lsp/rust_analyzer").setup(lsp_zero)
    require("plugins/lsp/wgsl_analyzer").setup(lsp_zero)

    -- Setup navic which shows code context in the winbar
    local navic = require("nvim-navic")
    navic.setup({ depth_limit = 6, highlight = true })

    -- Setup lsp-format for easy code formatting on save
    local lsp_format = require("lsp-format")
    lsp_format.setup()

    -- Setup code action light bulb
    -- Todo: See if there's a similar plugin available that can be attached to LSP clients
    -- that support code actions, instead of being a global hook
    require("nvim-lightbulb").setup({ autocmd = { enabled = true } })

    -- Attach additional LSP functionality
    lsp_zero.on_attach(function(client, bufnr)
        -- Feed LSP data to navic and symbol outline if the LSP has a symbol provider
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
            require("plugins.lsp.symbolsoutline").setup(bufnr)
        end

        -- Add auto formatting to LSPs that support formatting
        if client.supports_method("textDocument/formatting") then lsp_format.on_attach(client) end

        -- Add function signature help
        if client.server_capabilities.signatureHelpProvider then
            require("lsp_signature").on_attach(
                { bind = true, handler_opts = { border = require("globals").border_style } },
                bufnr
            )
        end

        -- Add keymaps to the buffer for LSP features supported by this client
        require("plugins/lsp/keymaps").setup(client, bufnr)
    end)

    -- Setup lsp-zero once all the preamble is complete
    lsp_zero.setup()

    -- Extend lsp-zero's nvim-cmp settings with our own
    require("plugins/lsp/nvim_cmp").setup(lsp_zero)

    -- Configure nvim's diagnostics interface
    -- Must be called after lsp-zero's setup to override its settings
    require("plugins/lsp/diagnostics").setup()

    -- Setup null-ls
    require("plugins/lsp/null_ls").setup(lsp_zero)
end

return M
