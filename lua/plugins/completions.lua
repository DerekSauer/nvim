local M = {
    -- Code & text completion engine.
    "hrsh7th/nvim-cmp",

    dependencies = {
        -- Snippet completion source.
        "saadparwaiz1/cmp_luasnip",

        -- File path completion source.
        "hrsh7th/cmp-path",

        -- Buffer text completion source.
        "hrsh7th/cmp-buffer",

        -- Attached LSP as a completion source.
        "hrsh7th/cmp-nvim-lsp",

        -- Neovim's command line as a source.
        "hrsh7th/cmp-cmdline",
    },

    -- Enable completions when entering insert mode in a buffer or the command line.
    event = { "InsertEnter", "CmdlineEnter" },
}

function M.config()
    local cmp = require("cmp")
    local cmp_types = require("cmp.types")
    local context = require("cmp.config.context")
    local luasnip = require("luasnip")
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

    -- Weights for reordering LSP completion items.
    local lsp_kind_priority = {
        -- Sort variable names to the top of the list.
        [cmp_types.lsp.CompletionItemKind.Variable] = 1,

        -- Sort LSP snippets to the bottom.
        [cmp_types.lsp.CompletionItemKind.Snippet] = 98,

        -- Sort keywords to the bottom.
        [cmp_types.lsp.CompletionItemKind.Keyword] = 99,

        -- Sort plain text to the bottom.
        [cmp_types.lsp.CompletionItemKind.Text] = 100,
    }

    ---Match an LSP item's `kind` with the priority weights above.
    ---@param kind table The `kind` of an LSP item.
    ---@return number #Sorting weight of a `kind` found in the table of weights, or the `kind's` original weight.
    local function lsp_kind_match(kind)
        return lsp_kind_priority[kind] or kind
    end

    ---Sort LSP completion items according to a table of weights.
    ---Some LSPs emitted many "non-code" completions like snippets or the progamming language's
    ---own keywords. I'd rather have these items at the end of the completion list.
    ---@param entry1 table Item to compare with entry2.
    ---@param entry2 table Item to compare with entry1.
    ---@return boolean|nil
    local function lsp_item_comparator(entry1, entry2)
        local kind1 = lsp_kind_match(entry1:get_kind())
        local kind2 = lsp_kind_match(entry2:get_kind())

        if kind1 ~= kind2 then
            return (kind1 - kind2) < 0
        end
    end

    ---Sort items beginning with underscores to the bottom of the completion list (Python, etc… )
    ---@param entry1 table Item to compare with entry2.
    ---@param entry2 table Item to compare with entry1.
    ---@return boolean|nil
    local function underscore_comparator(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")

        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0

        if entry1_under > entry2_under then
            return false
        elseif entry1_under < entry2_under then
            return true
        end
    end

    ---Determine if the cursor is inside a word.
    ---@return boolean #Returns `true` if the cursor is in a word.
    local function cursor_in_word()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    -- Use cmp's recommended settings for Neovim's built-in completion menu.
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    -- Select the first valid completion.
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    -- Initialize `nvim-cmp`.
    cmp.setup({
        -- Use Luasnip as Cmp's snippet engine.
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        -- Open the completion menu after matching at least two characters.
        completion = {
            keyword_length = 2,
        },

        -- Add our borders and style the completion and documentation windows.
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

        -- Configure the ordering of completion sources.
        -- Fallback to `buffer` completions if no LSP or Snippets completions are found.
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
        }, {
            { name = "buffer", keyword_length = 3 },
        }),

        -- Sorting priorities for completions.
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                lsp_item_comparator,
                underscore_comparator,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
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

        -- Disable completions when in a comment block.
        enabled = function()
            if vim.api.nvim_get_mode().mode == "c" then
                return true
            else
                return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
            end
        end,

        -- Key maps
        mapping = cmp.mapping.preset.insert({
            -- Accept selected completion.
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),

            -- Scroll through completion list.
            ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
            ["<Down>"] = cmp.mapping.select_next_item(select_opts),
            ["<C-k>"] = cmp.mapping.select_prev_item(select_opts),
            ["<C-j>"] = cmp.mapping.select_next_item(select_opts),

            -- Scroll through the documentation window.
            ["<Right>"] = cmp.mapping.scroll_docs(5),
            ["<Left>"] = cmp.mapping.scroll_docs(-5),
            ["<C-l>"] = cmp.mapping.scroll_docs(5),
            ["<C-h>"] = cmp.mapping.scroll_docs(-5),

            -- Open/Close completion menu.
            ["<C-Space>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.abort()
                else
                    cmp.complete()
                end
            end),

            -- Jump to next completion in the list, or next snippet placeholder.
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item(select_opts)
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif cursor_in_word() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            -- Jump to previous completion in the list, or next snippet placeholder.
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item(select_opts)
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
    })

    -- Enable search completions on the command line using the buffer as the source.
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "buffer" },
        }),
    })

    -- Enable command completions on the command line.
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })
end

return M
