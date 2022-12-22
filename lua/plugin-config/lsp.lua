local lsp_ok, lsp_zero = pcall(require, "lsp-zero")

if lsp_ok then
    -- Custom Mason settings must be defined before lsp-zero calls Mason's setup function
    require("plugin-config/lsp-config/mason").setup()

    -- Use recommended LSP settings and add nvim's API
    lsp_zero.preset("recommended")
    lsp_zero.nvim_workspace()

    -- We'll create our own keymaps based on LSP capabilities
    lsp_zero.set_preferences({
        set_lsp_keymaps = false,
    })

    -- Setup language servers
    require("plugin-config/lsp-config/sumneko_lua").setup(lsp_zero)
    require("plugin-config/lsp-config/rust_analyzer").setup(lsp_zero)
    require("plugin-config/lsp-config/wgsl_analyzer").setup(lsp_zero)

    -- Setup navic which shows code context in the winbar
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then navic.setup({ depth_limit = 6, highlight = true }) end

    -- Setup lsp-format for easy code formatting on save
    local lsp_format_ok, lsp_format = pcall(require, "lsp-format")
    if lsp_format_ok then lsp_format.setup() end

    -- Setup lsp-inlayhints
    local lsp_inlay_ok, lsp_inlay = pcall(require, "lsp-inlayhints")
    if lsp_inlay_ok then lsp_inlay.setup() end

    -- Attach additional LSP functionality
    lsp_zero.on_attach(function(client, bufnr)
        -- Feed LSP data to navic if the LSP has a symbol provider
        if client.server_capabilities.documentSymbolProvider and navic_ok then
            navic.attach(client, bufnr)
        end

        -- Add auto formatting to LSPs that support formatting
        if client.supports_method("textDocument/formatting") and lsp_format_ok then
            lsp_format.on_attach(client)
        end

        -- Add LSP inlays
        if client.supports_method("textDocument/inlayHint") and lsp_inlay_ok then
            lsp_inlay.on_attach(client, bufnr)
        end

        -- Add keymaps to the buffer for LSP features supported by this client
        require("plugin-config/lsp-config/keymaps").setup(client, bufnr)
    end)

    -- Setup lsp-zero once all the preamble is complete
    lsp_zero.setup()

    -- Extend lsp-zero's nvim-cmp settings with our own
    require("plugin-config/lsp-config/cmp").setup(lsp_zero)

    -- Configure nvim's diagnostics interface
    -- Must be called after lsp-zero's setup to override its settings
    require("plugin-config/lsp-config/diagnostics").setup()

    -- Setup null-ls
    require("plugin-config/lsp-config/null_ls").setup(lsp_zero)
else
    vim.notify("Failed to load plugin: lsp-zero.", vim.log.levels.ERROR)
    lsp_zero = nil
end
