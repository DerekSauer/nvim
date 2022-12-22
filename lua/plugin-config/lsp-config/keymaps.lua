local M = {}

function M.setup(client, bufnr)
    -- Tracks if any mappings were created to control if the
    -- LSP group appears in Whichkey for this buffer
    local has_mappings = false

    if client.supports_method("textDocument/hover") then
        vim.keymap.set(
            "n",
            "<leader>lk",
            function() vim.lsp.buf.hover() end,
            { silent = true, buffer = bufnr, desc = "Symbol hover info" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/definition") then
        vim.keymap.set(
            "n",
            "<leader>ld",
            function() vim.lsp.buf.definition() end,
            { silent = true, buffer = bufnr, desc = "Jump symbol definition" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/typeDefinition") then
        vim.keymap.set(
            "n",
            "<leader>lt",
            function() vim.lsp.buf.type_definition() end,
            { silent = true, buffer = bufnr, desc = "Jump type definition" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/declaration") then
        vim.keymap.set(
            "n",
            "<leader>lD",
            function() vim.lsp.buf.declaration() end,
            { silent = true, buffer = bufnr, desc = "Jump symbol declaration" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/implementation") then
        vim.keymap.set(
            "n",
            "<leader>li",
            function() vim.lsp.buf.implementation() end,
            { silent = true, buffer = bufnr, desc = "List symbol implementations" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/formatting") then
        vim.keymap.set(
            "n",
            "<leader>lf",
            function() vim.lsp.buf.format({ bufnr = bufnr, id = client.id }) end,
            { silent = true, buffer = bufnr, desc = "Format buffer" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/rangeFormatting") then
        vim.keymap.set(
            "v",
            "<leader>lf",
            function() vim.lsp.buf.format({ bufnr = bufnr, id = client.id }) end,
            { silent = true, buffer = bufnr, desc = "Format selection" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/references") then
        vim.keymap.set(
            "n",
            "<leader>lr",
            function() vim.lsp.buf.references() end,
            { silent = true, buffer = bufnr, desc = "List symbol references" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/rename") then
        vim.keymap.set(
            "n",
            "<leader>l<F2>",
            function() vim.lsp.buf.rename() end,
            { silent = true, buffer = bufnr, desc = "Rename symbol" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/rename") then
        vim.keymap.set(
            "n",
            "<F2>",
            function() vim.lsp.buf.rename() end,
            { silent = true, buffer = bufnr, desc = "Rename symbol" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/codeAction") then
        vim.keymap.set(
            "n",
            "<leader>l<F4>",
            function() vim.lsp.buf.code_action() end,
            { silent = true, buffer = bufnr, desc = "Code actions" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/codeAction") then
        vim.keymap.set(
            "n",
            "<F4>",
            function() vim.lsp.buf.code_action() end,
            { silent = true, buffer = bufnr, desc = "Code actions" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/publishDiagnostics") then
        vim.keymap.set(
            "n",
            "<leader>lp",
            function() require("telescope.builtin").diagnostics() end,
            { silent = true, buffer = bufnr, desc = "List diagnostics" }
        )
        has_mappings = true
    end

    if client.supports_method("textDocument/signatureHelp") then
        vim.keymap.set(
            "i",
            "<C-k>",
            function() vim.lsp.buf.signature_help() end,
            { silent = true, buffer = bufnr, desc = "Signature help" }
        )
        has_mappings = true
    end

    local lsp_inlay_ok, lsp_inlay = pcall(require, "lsp-inlayhints")
    if lsp_inlay_ok and client.supports_method("textDocument/inlayHint") then
        vim.keymap.set(
            "n",
            "<leader>lh",
            function() lsp_inlay.toggle() end,
            { silent = true, buffer = bufnr, desc = "Toggle inlay hints" }
        )
        has_mappings = true
    end

    -- Add to which-key categories
    local whickey_loaded, whichkey = pcall(require, "which-key")
    if whickey_loaded and has_mappings then
        whichkey.register({
            l = { name = "LSP" },
        }, { prefix = "<leader>", buffer = bufnr })
    end
end

return M
