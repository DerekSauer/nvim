local M = {}

local float_ns = vim.api.nvim_create_namespace "lsp_float"

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `noice` and `MariaSolOs`.
---https://github.com/lukas-reineke/dotfiles/blob/3a1afd9bad999cc2cdde98851c2a5066f60fc193/vim/lua/lsp/init.lua#L163
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@return function
local function enhanced_float_handler(handler)
    return function(err, result, ctx, config)
        local buf, win = handler(
            err,
            result,
            ctx,
            vim.tbl_deep_extend("force", config or {}, {
                border = vim.g.floating_window_border,
                max_height = math.floor(vim.o.lines * 0.5),
                max_width = math.floor(vim.o.columns * 0.4),
            })
        )

        if not buf or not win then
            return
        end

        -- Extra highlights.
        for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
            for pattern, hl_group in pairs {
                ["|%S-|"] = "@text.reference",
                ["@%S+"] = "@parameter",
                ["^%s*(Parameters:)"] = "@text.title",
                ["^%s*(Return:)"] = "@text.title",
                ["^%s*(See also:)"] = "@text.title",
                ["{%S-}"] = "@parameter",
            } do
                local from = 1 ---@type integer?
                while from do
                    local to
                    from, to = line:find(pattern, from)
                    if from then
                        vim.api.nvim_buf_set_extmark(buf, float_ns, l - 1, from - 1, {
                            end_col = to,
                            hl_group = hl_group,
                        })
                    end
                    from = to and to + 1 or nil
                end
            end
        end

        -- Add keymaps for opening links.
        if not vim.b[buf].markdown_keys then
            vim.keymap.set("n", "<CR>", function()
                -- Vim help links.
                local url = (vim.fn.expand "<cWORD>" --[[@as string]]):match "|(%S-)|"
                if url then
                    return vim.cmd.help(url)
                end

                -- Markdown links.
                local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                local from, to
                from, to, url = vim.api.nvim_get_current_line():find "%[.-%]%((%S-)%)"
                if from and col >= from and col <= to then
                    vim.system({ "open", url }, nil, function(res)
                        if res.code ~= 0 then
                            vim.notify("Failed to open URL" .. url, vim.log.levels.ERROR)
                        end
                    end)
                end
            end, { buffer = buf, silent = true })
            vim.b[buf].markdown_keys = true
        end
    end
end

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
            format = function(diagnostic)
                return string.format(
                    "%s (%s) [%s]",
                    diagnostic.message,
                    diagnostic.source,
                    diagnostic.code or diagnostic.user_data.lsp.code
                )
            end,
        },
    })

    -- Assign helper windows for LSP hover text and signature help.
    local methods = vim.lsp.protocol.Methods
    vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover)
    vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers
        .signature_help)

    -- Define icons for diagnostics
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    -- Add key maps for jumping to diagnostics
    vim.keymap.set(
        "n",
        "]d",
        function() vim.diagnostic.goto_next() end,
        { silent = true, desc = "Jump to next diagnostic" }
    )
    vim.keymap.set(
        "n",
        "[d",
        function() vim.diagnostic.goto_prev() end,
        { silent = true, desc = "Jump to previous diagnostic" }
    )

    -- Open a diagnostic floating window if no other float is open
    -- https://www.reddit.com/r/neovim/comments/tvy18v/comment/i3cfsr5/?utm_source=share&utm_medium=web2x&context=3
    local function open_diag_float()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then return end
        end
        vim.diagnostic.open_float({
            focusable = false,
            scope = "line",
            severity_sort = true,
            source = "if_many",
        })
    end

    -- Create autocommand to show diagnostics window when hovering over an issue
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = require("globals").user_au_group,
        pattern = { "*" },
        callback = open_diag_float,
    })
end

return M
