local M = {
    -- Snippets engine.
    "L3MON4D3/LuaSnip",

    dependencies = {
        -- Large library of pre-made snippets.
        "rafamadriz/friendly-snippets",
    },

    -- Enable Luasnip when entering insert mode in a buffer or the command line.
    event = { "InsertEnter", "CmdlineEnter" },
}

function M.config()
    -- Load snippets from 'friendly-snippets'.
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Load my own snippets.
    require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets" })

    -- Set additional configuration options for Luasnip.
    require("luasnip").config.set_config({
        history = true,
        enable_autosnippets = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
                active = {
                    virt_text = { { "↺", "markdownBold" } },
                },
            },
        },
    })

    -- Create snippet navigation keymaps.
    vim.keymap.set(
        { "s", "n" },
        "]n",
        function() require("luasnip").jump(1) end,
        { desc = "Next snippet placeholder" }
    )
    vim.keymap.set(
        { "s", "n" },
        "[n",
        function() require("luasnip").jump(-1) end,
        { desc = "Previous snippet placeholder" }
    )
end

return M
