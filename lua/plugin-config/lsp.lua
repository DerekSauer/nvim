local lsp_ok, lsp_zero = pcall(require, "lsp-zero")

if lsp_ok then
    -- Custom Mason settings must be defined before lsp-zero calls Mason's setup function
    require("plugin-config/lsp-config/mason").setup()

    -- Use recommended LSP settings and add nvim's API
    lsp_zero.preset("recommended")
    lsp_zero.nvim_workspace()

    -- Setup language servers
    require("plugin-config/lsp-config/sumneko_lua").setup(lsp_zero)
    require("plugin-config/lsp-config/rust_analyzer").setup(lsp_zero)
    require("plugin-config/lsp-config/wgsl_analyzer").setup(lsp_zero)

    -- Setup nvim-cmp
    require("plugin-config/lsp-config/cmp").setup(lsp_zero)

    -- Setup navic which shows code context in the winbar
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then navic.setup({ depth_limit = 6, highlight = true }) end

    -- Setup lsp-format for easy code formatting on save
    local lsp_format_ok, lsp_format = pcall(require, "lsp-format")
    if lsp_format_ok then lsp_format.setup() end

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
    end)

    -- Setup lsp-zero once all the preamble is complete
    lsp_zero.setup()

    -- Configure nvim's diagnostics interface
    -- Must be called after lsp-zero's setup to override its settings
    require("plugin-config/lsp-config/diagnostics").setup()

    -- Setup null-ls
    require("plugin-config/lsp-config/null_ls").setup(lsp_zero)

    -- Set Lsp key mappings
    require("plugin-config/lsp-config/keymaps").setup()
else
    vim.notify("Failed to load plugin: lsp-zero.", vim.log.levels.ERROR)
    lsp_zero = nil
end
