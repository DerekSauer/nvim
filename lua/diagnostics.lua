local M = {}

function M.setup()
    local globals = require("globals")

    vim.diagnostic.config({
        underline = true,
        virtual_text = {
            source = "if_many",
            prefix = "●",
        },
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = globals.border_style,
            source = "if_many",
        },
    })

    -- Add the global border style to the popup window providing LSP hover text.
    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = globals.border_style })

    -- Add the global border style to the popup window showing function signature help.
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = globals.border_style })

    -- Define the icons used for displaying diagnostics errors.
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    -- Jump to the next diagnostic issue in the buffer.
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_next()
    end, { silent = true, desc = "Jump to next diagnostic" })

    -- Jump to the previous diagnostic issue in the buffer.
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_prev()
    end, { silent = true, desc = "Jump to previous diagnostic" })

    -- Open a diagnostic floating window only if no other float is open.
    -- https://www.reddit.com/r/neovim/comments/tvy18v/comment/i3cfsr5/?utm_source=share&utm_medium=web2x&context=3
    local function open_diag_float()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            focusable = false,
            scope = "line",
            severity_sort = true,
            source = "if_many",
        })
    end

    -- Create an auto command to show the diagnostics window when the cursor is hovering over an issue.
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = require("globals").user_au_group,
        pattern = { "*" },
        callback = open_diag_float,
    })
end

return M
