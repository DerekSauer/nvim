local M = {
    -- LSP configuration helper
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 999,
    dependencies = {
        -- LSP installation and management tool
        "williamboman/mason.nvim",

        -- Improved interop between 'nvim-lspconfig' and 'Mason'
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },

        -- Code symbols outline window
        "simrat39/symbols-outline.nvim",

        -- Show function signature help
        "ray-x/lsp_signature.nvim",

        -- Plugin to manage global and project-local settings.
        "folke/neoconf.nvim",
    },
}

vim.g.inlay_hints_visible = false

---Toggle inlay hints (supported in nvim-0.10 or greater).
---@param client number ID of the LSP client.
---@param bufnr number ID of the buffer.
local function toggle_inlay_hints(client, bufnr)
    if vim.g.inlay_hints_visible then
        vim.g.inlay_hints_visible = false
        vim.lsp.inlay_hint(bufnr, false)
    else
        if client.server_capabilities.inlayHintProvider then
            vim.g.inlay_hints_visible = true
            vim.lsp.inlay_hint(bufnr, true)
        else
            print("Inlay hints unavailable.")
        end
    end
end

vim.g.diagnostics_visible = true

--- Toggle diagnostics.
local function toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.diagnostic.disable()
    else
        vim.g.diagnostics_visible = true
        vim.diagnostic.enable()
    end
end

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
        vim.keymap.set("n", "<leader>ld",
            function() require("telescope.builtin").lsp_definitions() end,
            { buffer = bufnr, desc = "Jump symbol definition" })
        has_mappings = true
    end

    if client.server_capabilities.typeDefinitionProvider then
        vim.keymap.set("n", "<leader>lt",
            function() require("telescope.builtin").lsp_type_definitions() end,
            { buffer = bufnr, desc = "Jump type definition" })
        has_mappings = true
    end

    if client.server_capabilities.declarationProvider then
        vim.keymap.set("n", "<leader>lD", function() vim.lsp.buf.declaration() end,
            { buffer = bufnr, desc = "Jump symbol declaration" })
        has_mappings = true
    end

    if client.server_capabilities.implementationProvider then
        vim.keymap.set("n", "<leader>li",
            function() require("telescope.builtin").lsp_implementations() end,
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
        vim.keymap.set("n", "<leader>lr",
            function() require("telescope.builtin").lsp_references() end,
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

    if client.server_capabilities.inlayHintProvider then
        vim.keymap.set("n", "<leader>ly", function()
            toggle_inlay_hints(client, bufnr)
        end
        , { buffer = bufnr, desc = "Toggle inlay hints" })
        has_mappings = true
    end

    if client.supports_method("textDocument/publishDiagnostics") then
        -- Show a list of diagnostics in a Telescope window.
        vim.keymap.set("n", "<leader>lp", function() require("telescope.builtin").diagnostics() end,
            { buffer = bufnr, desc = "List diagnostics" })

        -- Toggle displaying diagnostics.
        vim.keymap.set("n", "<leader>lg", function() toggle_diagnostics() end,
            { buffer = bufnr, desc = "Toggle diagnostics" })

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
    -- Setup `neoconf` before `lspconfig` per neoconf's docs
    -- The default configuration is fine
    require("neoconf").setup({})

    local lsp_config = require("lspconfig")

    -- Extend nvim's LSP client capabilities with those provided by 'nvim-cmp'
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol
        .make_client_capabilities())

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

    -- Initialize code symbols outline utility
    require("symbols-outline").setup()

    -- Config options for lsp_signature
    local lsp_sig_config = {
        bind = true,
        handler_opts = {
            border = require("globals").border_style,
        },
    }

    -- Create an autocommand that will execute additional configuration when an LSP is attached to a buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local buffer_number = args.buf

            -- Add keymaps for LSP features supported by this client.
            lsp_keymaps(client, buffer_number)

            -- Auto-format buffers on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = buffer_number,
                    desc = "Auto format buffer with LSP on save.",
                    callback = function()
                        vim.lsp.buf.format({ bufnr = buffer_number })
                    end,
                })
            end

            -- Show function signature help
            if client.server_capabilities.signatureHelpProvider then
                require("lsp_signature").on_attach(lsp_sig_config, buffer_number)
            end

            -- Enable LSP inlay hints
            if vim.fn.has("nvim-0.10") == 1 then
                if client.server_capabilities.inlayHintProvider then
                    vim.g.inlay_hints_visible = true
                    vim.lsp.inlay_hint(buffer_number, true)
                end
            end
        end,
    })
end

return M
