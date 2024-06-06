local M = {
    -- Code & text completion engine.
    "hrsh7th/nvim-cmp",

    dependencies = {
        -- File path completion source.
        "hrsh7th/cmp-path",

        -- Buffer text completion source.
        "hrsh7th/cmp-buffer",

        -- Attached LSP as a completion source.
        "hrsh7th/cmp-nvim-lsp",

        -- Neovim's command line as a source.
        "hrsh7th/cmp-cmdline",
    },
}

function M.config()
    local cmp = require("cmp")
    local context = require("cmp.config.context")
    local globals = require("globals")

    -- Abbreviated names for sources.
    local completion_menu_abbr = {
        nvim_lsp = "[LSP]",
        luasnip = "[SNIP]",
        buffer = "[BUF]",
        path = "[PATH]",
    }

    -- Icons for the 'kind' in completion menu entries.
    local completion_menu_icons = {
        Text = " ",
        Method = "󰆧 ",
        Function = "󰊕 ",
        Constructor = " ",
        Field = " ",
        Variable = " ",
        Class = "󰠱 ",
        Interface = " ",
        Module = " ",
        Property = "󰜢 ",
        Unit = "󰑭 ",
        Value = "󰎠 ",
        Enum = " ",
        EnumMember = " ",
        Keyword = "󰌋 ",
        Snippet = " ",
        Color = "󰏘 ",
        File = "󰈙 ",
        Reference = " ",
        Folder = "󰉋 ",
        Constant = "󰏿 ",
        Struct = " ",
        Event = "",
        Operator = " ",
        TypeParameter = " ",
        Misc = " ",
        TabNine = "󰚩 ",
        Copilot = " ",
        Unknown = " ",
    }

    -- Use cmp's recommended settings for Neovim's built-in completion menu.
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    -- Initialize `nvim-cmp`.
    cmp.setup({
        -- Use Neovim's builtin snippet support as Cmp's snippet engine.
        snippet = {
            expand = function(args)
                vim.snippet.expand(args.body)
            end,
        },

        -- Open the completion menu after matching at least two characters.
        completion = {
            keyword_length = 2,
        },

        -- Add our borders to the completion and documentation windows.
        window = {
            completion = {
                scrolloff = 3,
                border = globals.border_style,
                scrollbar = true,
            },

            documentation = {
                border = globals.border_style,
                scrollbar = true,
            },
        },

        -- Modify completion menu to show an icon for the completion, followed
        -- by the completion item itself and source name.
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, item)
                item.kind = completion_menu_icons[item.kind] or "??"
                item.menu = completion_menu_abbr[entry.source.name] or "??"

                return item
            end,
        },

        -- Configure the ordering of completion sources.
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "snippets" },
            { name = "path" },
            { name = "buffer", keyword_length = 3 },
        }),

        -- Disable completions when in a comment block.
        enabled = function()
            if vim.api.nvim_get_mode().mode == "i" then
                return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
            end
        end,

        -- Key maps
        mapping = cmp.mapping.preset.insert({
            -- Accept selected completion.
            ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
            ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),

            -- Scroll through completion list.
            ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

            -- Scroll through the documentation window.
            ["<Right>"] = cmp.mapping(cmp.mapping.scroll_docs(5), { "i", "c" }),
            ["<Left>"] = cmp.mapping(cmp.mapping.scroll_docs(-5), { "i", "c" }),
            ["<C-l>"] = cmp.mapping(cmp.mapping.scroll_docs(5), { "i", "c" }),
            ["<C-h>"] = cmp.mapping(cmp.mapping.scroll_docs(-5), { "i", "c" }),

            -- Open/Close completion menu.
            ["<C-o>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

            -- Abort completion
            ["<C-e"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),

            -- Jump to next completion in the list, or next snippet placeholder.
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.snippet.active({ direction = 1 }) then
                    vim.schedule(function()
                        vim.snippet.jump(1)
                    end)
                else
                    fallback()
                end
            end, { "i", "s" }),

            -- Jump to previous completion in the list, or next snippet placeholder.
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.snippet.active({ direction = -1 }) then
                    vim.schedule(function()
                        vim.snippet.jump(-1)
                    end)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
    })

    -- Enable search completions on the command line using the buffer as the source.
    cmp.setup.cmdline({ "/", "?" }, {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "buffer" },
        }),
    })

    -- Enable command completions on the command line.
    cmp.setup.cmdline(":", {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })
end

return M
