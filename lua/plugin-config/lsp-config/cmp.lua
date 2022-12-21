local M = {}

function M.setup(lsp_zero)
    local globals = require("globals")

    local nvim_cmp_config = {
        completion = {
            keyword_length = 1,
        },

        window = {
            completion = {
                scrolloff = 3,
                border = globals.border_style,
                col_offset = -3,
                side_padding = 0,
                scrollbar = true,
            },

            documentation = {
                border = globals.border_style,
                scrollbar = true,
            },
        },

        duplicates = {
            nvim_lsp = 1,
            buffer = 1,
            luasnip = 1,
            path = 1,
        },

        sources = {
            { name = "nvim_lsp", priority = 1 },
            { name = "nvim_lsp_signature_help", priority = 2 },
            { name = "buffer", priority = 3 },
            { name = "luasnip", priority = 4 },
            { name = "path", priority = 5 },
        },

        -- Modify completion menu to show an icon (using 'lspkind') for the completion
        -- type, followed by an abbreviation and then menu item
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(
                    entry,
                    vim_item
                )
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. strings[1] .. " "
                kind.menu = "    (" .. strings[2] .. ")"

                return kind
            end,
        },

        -- Disable completions when in a comment
        enabled = function()
            local context = require("cmp.config.context")
            if vim.api.nvim_get_mode().mode == "c" then
                return true
            else
                return not context.in_treesitter_capture("comment")
                    and not context.in_syntax_group("Comment")
            end
        end,
    }
    lsp_zero.setup_nvim_cmp(nvim_cmp_config)

    -- Override the rest of the settings lsp-zero does not merge in
    require("cmp").setup(nvim_cmp_config)
end

return M
