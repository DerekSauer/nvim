local M = {
    -- LSP configuration helper
    "neovim/nvim-lspconfig",

    -- Force LSP configuration to load early so that debuggers are
    -- available for DAP configuration, and it stops complaining
    -- about `codelldb` not being found.
    lazy = false,
    priority = 1000,

    dependencies = {
        -- LSP installation and management tool
        "williamboman/mason.nvim",

        -- Improved interoperation between `nvim-lspconfig` and `Mason`
        "williamboman/mason-lspconfig.nvim",

        -- Show function signature help
        "ray-x/lsp_signature.nvim",

        -- Plugin to manage global and project-local settings.
        "folke/neoconf.nvim",

        -- Lsp diagnostics pointing to the problems
        {
            name = "lsp_lines",
            url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        },
    },
}

-- Default to LSP inlay hints being off, they're useful but distracting.
vim.g.inlay_hints_visible = false

---Toggle inlay hints (supported in nvim-0.10 or greater).
---@param bufnr number ID of the buffer.
local function toggle_inlay_hints(bufnr)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

vim.g.diagnostics_visible = true

---Creates LSP keymaps for a buffer when an LSP is attached.
---The function will only create maps for functionality the LSP supports.
---@param client table ID of the LSP client.
---@param bufnr number ID of the buffer.
local function lsp_keymaps(client, bufnr)
    -- Tracks if any mappings were created to control if the
    -- LSP group appears in Which-key for this buffer
    local has_mappings = false

    -- Get additional information about the symbol under the cursor.
    -- SHIFT-K quick shortcut.
    if client.server_capabilities.hoverProvider then
        vim.keymap.set("n", "<leader>lk", function()
            vim.lsp.buf.hover()
        end, { buffer = bufnr, desc = "Symbol hover info" })
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, { buffer = bufnr, desc = "Symbol hover info" })
        has_mappings = true
    end

    -- Jump to where the symbol is defined or display a list for multiple definitions.
    if client.server_capabilities.definitionProvider then
        vim.keymap.set("n", "<leader>ld", function()
            require("telescope.builtin").lsp_definitions()
        end, { buffer = bufnr, desc = "Jump symbol definition" })
        has_mappings = true
    end

    -- Jump to where the symbol's type is defined or display a list for multiple definitions.
    if client.server_capabilities.typeDefinitionProvider then
        vim.keymap.set("n", "<leader>lt", function()
            require("telescope.builtin").lsp_type_definitions()
        end, { buffer = bufnr, desc = "Jump type definition" })
        has_mappings = true
    end

    -- Jump to where the symbol is declared.
    if client.server_capabilities.declarationProvider then
        vim.keymap.set("n", "<leader>lD", function()
            vim.lsp.buf.declaration()
        end, { buffer = bufnr, desc = "Jump symbol declaration" })
        has_mappings = true
    end

    -- Jump to the symbols implementation or display a list if more than one implementation.
    if client.server_capabilities.implementationProvider then
        vim.keymap.set("n", "<leader>li", function()
            require("telescope.builtin").lsp_implementations()
        end, { buffer = bufnr, desc = "List symbol implementations" })
        has_mappings = true
    end

    -- Format the entire buffer.
    if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set("n", "<leader>lf", function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, { buffer = bufnr, desc = "Format buffer" })
        has_mappings = true
    end

    -- Display a list of references to the symbol.
    if client.server_capabilities.referencesProvider then
        vim.keymap.set("n", "<leader>lr", function()
            require("telescope.builtin").lsp_references()
        end, { buffer = bufnr, desc = "List symbol references" })
        has_mappings = true
    end

    -- Rename the symbol under the cursor.
    -- F2 quick shortcut.
    if client.server_capabilities.renameProvider then
        vim.keymap.set("n", "<leader>l<F2>", function()
            vim.lsp.buf.rename()
        end, { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "<F2>", function()
            vim.lsp.buf.rename()
        end, { buffer = bufnr, desc = "Rename symbol" })
        has_mappings = true
    end

    -- Display a list of code actions that may be performed at the cursor's position.
    -- F4 quick shortcut.
    if client.server_capabilities.codeActionProvider then
        vim.keymap.set("n", "<leader>l<F4>", function()
            vim.lsp.buf.code_action()
        end, { buffer = bufnr, desc = "Code actions" })
        vim.keymap.set("n", "<F4>", function()
            vim.lsp.buf.code_action()
        end, { buffer = bufnr, desc = "Code actions" })
        has_mappings = true
    end

    -- Open the signature help overlay.
    if client.server_capabilities.signatureHelpProvider then
        vim.keymap.set("i", "<C-k>", function()
            vim.lsp.buf.signature_help()
        end, { buffer = bufnr, desc = "Signature help" })
        has_mappings = true
    end

    -- Toggle inlay hints on or off.
    if client.server_capabilities.inlayHintProvider then
        vim.keymap.set("n", "<leader>ly", function()
            toggle_inlay_hints(bufnr)
        end, { buffer = bufnr, desc = "Toggle inlay hints" })
        has_mappings = true
    end

    if client.supports_method("textDocument/publishDiagnostics") then
        -- Show a list of diagnostics in a Telescope window.
        vim.keymap.set("n", "<leader>lp", function()
            require("telescope.builtin").diagnostics()
        end, { buffer = bufnr, desc = "List diagnostics" })

        -- Toggle displaying diagnostics.
        vim.keymap.set("n", "<leader>lg", function()
            require("lsp_lines").toggle()
        end, { buffer = bufnr, desc = "Toggle diagnostics" })

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
    -- Setup `neoconf` before `lspconfig` per `neoconf's` docs
    -- The default configuration is fine
    require("neoconf").setup({})

    local lsp_config = require("lspconfig")

    -- Retrieve Neovim's native LSP capabilities and extend them with additional functionality provided by `nvim-cmp`.
    local lsp_capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Initialize 'mason'
    require("mason").setup()
    require("mason.settings").set({
        ui = { border = require("globals").border_style, width = 0.75, height = 0.75 },
    })

    -- Initialize the `Mason` & `lspconfig` interoperation helper
    require("mason-lspconfig").setup()

    -- Setup installed LSPs
    require("mason-lspconfig").setup_handlers({
        -- The default setup handler will automatically set up, with default settings, any LSP server
        -- that does not have an override below.
        function(server_name)
            require("lspconfig")[server_name].setup({ capabilities = lsp_capabilities })
        end,

        -- Override the defaults with our own settings for select servers
        ["clangd"] = function()
            require("plugins/lsp_servers/clangd").setup(lsp_config, lsp_capabilities)
        end,

        ["rust_analyzer"] = function()
            require("plugins/lsp_servers/rust_analyzer").setup(lsp_config, lsp_capabilities)
        end,

        ["lua_ls"] = function()
            require("plugins/lsp_servers/lua_ls").setup(lsp_config, lsp_capabilities)
        end,

        ["wgsl_analyzer"] = function()
            require("plugins/lsp_servers/wgsl_analyzer").setup(lsp_config, lsp_capabilities)
        end,
    })

    -- Disable logging LSP errors.
    vim.lsp.set_log_level("OFF")

    -- Config options for `LSP_signature`.
    local lsp_sig_config = {
        bind = true,
        handler_opts = {
            border = require("globals").border_style,
        },
    }

    -- Enable LSP diagnostic helper text, starts disabled
    require("lsp_lines").setup()
    vim.diagnostic.config({ virtual_lines = false })

    -- Create an auto command that will execute additional configuration when an LSP is attached to a buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            -- Nil check to keep `lua_ls` happy.
            -- `LspAttach` will never be called if there's no LSP client to attach to.
            if client then
                local buffer_number = args.buf

                -- Add key maps for LSP features supported by this client.
                lsp_keymaps(client, buffer_number)

                -- Show function signature help
                if client.server_capabilities.signatureHelpProvider then
                    require("lsp_signature").on_attach(lsp_sig_config, buffer_number)
                end

                -- Display inlay hints
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(vim.g.inlay_hints_visible)
                end
            end
        end,
    })
end

return M
