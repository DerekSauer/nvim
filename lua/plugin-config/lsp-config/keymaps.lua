local M = {}

function M.setup()
    vim.keymap.set(
        "n",
        "<leader>lk",
        function() vim.lsp.buf.hover() end,
        { silent = true, desc = "Symbol hover info" }
    )
    vim.keymap.set(
        "n",
        "<leader>ld",
        function() vim.lsp.buf.definition() end,
        { silent = true, desc = "Jump symbol definition" }
    )
    vim.keymap.set(
        "n",
        "<leader>lD",
        function() vim.lsp.buf.declaration() end,
        { silent = true, desc = "Jump symbol declaration" }
    )
    vim.keymap.set(
        "n",
        "<leader>li",
        function() vim.lsp.buf.implementation() end,
        { silent = true, desc = "List symbol implementations" }
    )
    vim.keymap.set(
        "n",
        "<leader>lt",
        function() vim.lsp.buf.type_definition() end,
        { silent = true, desc = "Jump type definition" }
    )
    vim.keymap.set(
        "v",
        "<leader>lf",
        function() vim.lsp.buf.range_formatting() end,
        { silent = true, desc = "Format selection" }
    )
    vim.keymap.set(
        "n",
        "<leader>lr",
        function() vim.lsp.buf.references() end,
        { silent = true, desc = "List symbol references" }
    )
    vim.keymap.set(
        "n",
        "<leader>l<F2>",
        function() vim.lsp.buf.rename() end,
        { silent = true, desc = "Rename symbol" }
    )
    vim.keymap.set(
        "n",
        "<leader>l<F4>",
        function() vim.lsp.buf.code_action() end,
        { silent = true, desc = "Code actions" }
    )
    vim.keymap.set(
        "n",
        "<leader>lp",
        function() require("telescope.builtin").diagnostics() end,
        { silent = true, desc = "List diagnostics" }
    )
    vim.keymap.set("n", "<leader>lf", ":LspZeroFormat<CR>", { silent = true, desc = "Format file" })
    vim.keymap.set(
        "i",
        "<C-k>",
        function() vim.lsp.buf.signature_help() end,
        { silent = true, desc = "Signature help" }
    )

    vim.keymap.set(
        { "s", "n" },
        "]s",
        function() require("luasnip").jump(1) end,
        { silent = true, desc = "Next snippet placeholder" }
    )

    vim.keymap.set(
        { "s", "n" },
        "[s",
        function() require("luasnip").jump(-1) end,
        { silent = true, desc = "Next snippet placeholder" }
    )

    vim.keymap.set(
        { "s", "n" },
        "<C-]>",
        function() require("luasnip").jump(1) end,
        { silent = true, desc = "Next snippet placeholder" }
    )

    vim.keymap.set(
        { "s", "n" },
        "<C-[>",
        function() require("luasnip").jump(-1) end,
        { silent = true, desc = "Next snippet placeholder" }
    )

    local lsp_inlay_ok, lsp_inlay = pcall(require, "lsp-inlayhints")
    if lsp_inlay_ok then
        vim.keymap.set(
            "n",
            "<leader>lh",
            function() lsp_inlay.toggle() end,
            { silent = true, desc = "Toggle inlay hints" }
        )
    end

    -- Add to which-key categories
    local whickey_loaded, whichkey = pcall(require, "which-key")
    if whickey_loaded then
        whichkey.register({
            l = { name = "LSP" },
        }, { prefix = "<leader>" })
    end
end

return M
