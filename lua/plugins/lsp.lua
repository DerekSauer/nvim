local M = {
    -- LSP configuration helper
    "neovim/nvim-lspconfig",
    dependencies = {
        -- LSP installation and management tool
        "williamboman/mason.nvim",

        -- Improved interop between 'nvim-lspconfig' and 'Mason'
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },

        -- Code context from LSP
        "SmiteshP/nvim-navic",

        -- Code symbols outline window
        "simrat39/symbols-outline.nvim",

        -- Automatically format buffers if supported by an attached LSP
        "lukas-reineke/lsp-format.nvim",

        -- Use non-LSP services as though they were an LSP (E.g.: Linters, formatters)
        { "jose-elias-alvarez/null-ls.nvim",   dependencies = "nvim-lua/plenary.nvim" },

        -- Improve interop between 'mason' and 'null-ls'
        { "jay-babu/mason-null-ls.nvim",
            dependencies = { "jose-elias-alvarez/null-ls.nvim", "williamboman/mason.nvim" }, },

        -- Show function signature help
        "ray-x/lsp_signature.nvim",
    },
}

---Creates LSP keymaps for a buffer when an LSP is attached.
---The function will only create maps for functionality the LSP supports.
---@param client number ID of the LSP client.
---@param bufnr number ID of the buffer.
local function lsp_keymaps(client, bufnr)
    -- Tracks if any mappings were created to control if the
    -- LSP group appears in Whichkey for this buffer
    local has_mappings = false

    if client.server_capabilities.hoverProvider then
        vim.keymap.set("n", "<leader>lk", function() vim.lsp.buf.hover() end,
            { buffer = bufnr, desc = "Symbol hover info" })
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
            { buffer = bufnr, desc = "Symbol hover info" })
        has_mappings = true
    end

    if client.server_capabilities.definitionProvider then
        vim.keymap.set("n", "<leader>ld", function() vim.lsp.buf.definition() end,
            { buffer = bufnr, desc = "Jump symbol definition" })
        has_mappings = true
    end

    if client.server_capabilities.typeDefinitionProvider then
        vim.keymap.set("n", "<leader>lt", function() vim.lsp.buf.type_definition() end,
            { buffer = bufnr, desc = "Jump type definition" })
        has_mappings = true
    end

    if client.server_capabilities.declarationProvider then
        vim.keymap.set("n", "<leader>lD", function() vim.lsp.buf.declaration() end,
            { buffer = bufnr, desc = "Jump symbol declaration" })
        has_mappings = true
    end

    if client.server_capabilities.implementationProvider then
        vim.keymap.set("n", "<leader>li", function() vim.lsp.buf.implementation() end,
            { buffer = bufnr, desc = "List symbol implementations" })
        has_mappings = true
    end

    if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set("n", "<leader>lf",
            function() vim.lsp.buf.format({ bufnr = bufnr, id = client.id }) end,
            { buffer = bufnr, desc = "Format buffer" })
        has_mappings = true
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.keymap.set("v", "<leader>lf",
            function() vim.lsp.buf.format({ bufnr = bufnr, id = client.id }) end,
            { buffer = bufnr, desc = "Format selection" })
        has_mappings = true
    end

    if client.server_capabilities.referencesProvider then
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end,
            { buffer = bufnr, desc = "List symbol references" })
        has_mappings = true
    end

    if client.server_capabilities.renameProvider then
        vim.keymap.set("n", "<leader>l<F2>", function() vim.lsp.buf.rename() end,
            { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end,
            { buffer = bufnr, desc = "Rename symbol" })
        has_mappings = true
    end

    if client.server_capabilities.codeActionProvider then
        vim.keymap.set("n", "<leader>l<F4>", function() vim.lsp.buf.code_action() end,
            { buffer = bufnr, desc = "Code actions" })
        vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end,
            { buffer = bufnr, desc = "Code actions" })
        has_mappings = true
    end


    if client.server_capabilities.signatureHelpProvider then
        vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end,
            { buffer = bufnr, desc = "Signature help" })
        has_mappings = true
    end

    if client.server_capabilities.documentSymbolProvider then
        vim.keymap.set("n", "<leader>lo", function()
            vim.cmd("SymbolsOutline")
            vim.cmd("redraw")
        end
            , { buffer = bufnr, desc = "Toggle symbol outline" })
        has_mappings = true
    end

    if client.supports_method("textDocument/publishDiagnostics") then
        vim.keymap.set("n", "<leader>lp", function() require("telescope.builtin").diagnostics() end,
            { buffer = bufnr, desc = "List diagnostics" })
        has_mappings = true
    end

    -- Add to which-key categories
    if has_mappings then
        local whichkey = require("which-key")
        whichkey.register({
            l = { name = "LSP" },
        }, { prefix = "<leader>", buffer = bufnr })
    end
end

function M.config()
    local lsp_config = require("lspconfig")

    -- Extend nvim's LSP client capabilities with those provided by 'nvim-cmp'
    local lsp_capabilities = vim.deepcopy(lsp_config.util.default_config.capabilities)
    lsp_capabilities = vim.tbl_deep_extend("force", lsp_capabilities,
        require("cmp_nvim_lsp").default_capabilities())

    -- Initialize 'mason'
    require("mason").setup()
    require("mason.settings").set({ ui = { border = require("globals").border_style } })

    -- Initialize the 'mason' & 'lspconfig' interop helper
    require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "rust_analyzer", "taplo" } })

    -- Setup installed LSPs
    require("mason-lspconfig").setup_handlers({
        -- Default handler will automatically setup any server without a custom setup function
        function(server_name)
            require("lspconfig")[server_name].setup({ capabilities = lsp_capabilities })
        end,
        -- Override the defaults with our own settings for select servers
        ["rust_analyzer"] = function()
            require("plugins/lsp_servers/rust_analyzer").setup(lsp_config
                , lsp_capabilities)
        end,
        ["lua_ls"] = function()
            require("plugins/lsp_servers/lua_ls").setup(lsp_config,
                lsp_capabilities)
        end,
        ["wgsl_analyzer"] = function()
            require("plugins/lsp_servers/wgsl_analyzer").setup(lsp_config
                , lsp_capabilities)
        end,
    })

    -- Initialize the interop handler for 'mason' and 'null-ls'
    local null_ls = require("null-ls")
    require("mason-null-ls").setup({ ensure_installed = {}, automatic_setup = true })

    -- Setup installed 'null-ls' sources
    require("mason-null-ls").setup_handlers({
        -- Default handler will automatically setup any source without a custom setup function
        function(source_name, methods)
            require("mason-null-ls.automatic_setup")(source_name, methods)
        end,
        -- Disable Taplo as a null-ls source, its already an LSP source
        ["taplo"] = function()
            null_ls.disable(null_ls.builtins.formatting.taplo)
        end,
        -- Example override
        -- ["stylua"] = function(source_name, methods)
        --     null_ls.register(null_ls.builtins.formatting.stylua)
        -- end,
    })

    -- Initialize 'null-ls'
    null_ls.setup()

    -- Initialize buffer auto-formatting utility
    local lsp_format = require("lsp-format")
    lsp_format.setup()

    -- Initialize 'navic' so we can show code context in the winbar
    local navic = require("nvim-navic")
    navic.setup({ depth_limit = 6, highlight = true })

    -- Initialize code symbols outline utility
    require("symbols-outline").setup()

    -- Config options for lsp_signature
    local lsp_sig_config = {
        bind = true,
        handler_opts = {
            border = require("globals").border_style,
        },
    }

    -- Create an autocommand that will execute additional configuration when an LSP is attached to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local buffer_number = args.buf

            -- Add LSP keymaps
            lsp_keymaps(client, buffer_number)

            -- Auto-format buffers on save
            if client.server_capabilities.documentFormattingProvider then
                lsp_format.on_attach(client)
            end

            -- Get code context from the LSP
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, buffer_number)
            end

            -- Show function signature help
            if client.server_capabilities.signatureHelpProvider then
                require("lsp_signature").on_attach(lsp_sig_config, buffer_number)
            end
        end,
    })
end

return M
