local M = {}

function M.setup(lsp_zero)
    local globals = require("globals")

    local nvim_cmp_config = {
        completion = {
            scrolloff = 3,
            border = globals.border_style,
        },

        documentation = {
            border = globals.border_style,
        },

        sources = {
            { name = "path", max_item_count = 5 },
            { name = "nvim_lsp", keyword_length = 3, max_item_count = 10 },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua", max_item_count = 5 },
            { name = "buffer", keyword_length = 3, max_item_count = 5 },
            { name = "luasnip", keyword_length = 2, max_item_count = 5 },
        },

        -- Modify completion menu to show an icon (using 'lspkind') for the completion
        -- type, followed by an abbreviation and then menu item
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. strings[1] .. " "
                kind.menu = "    (" .. strings[2] .. ")"

                return kind
            end,
        },

        -- Disable completions when in a comment
        enabled = function()
            local context = require("cmp.config.context")

            -- Permit completion if in command mode
            if vim.api.nvim_get_mode().mode == "c" then
                return true
            else
                return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
            end
        end,
    }
    lsp_zero.setup_nvim_cmp(nvim_cmp_config)
end

return M
