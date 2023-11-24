local M = {
    "echasnovski/mini.indentscope",
    version = false,
}

function M.config()
    -- Change the color of the indent line to match Neo-tree's indent lines.
    vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "NonText" })

    require("mini.indentscope").setup({
        -- Indent line drawing options.
        draw = {
            -- Delay before redrawing the line after changing scope.
            delay = 50,

            -- Disable animations. I find they make the editing experience "feel" less crisp.
            animation = require("mini.indentscope").gen_animation.none(),
        },

        -- Built-in key mappings.
        mappings = {
            -- Text object effecting text within the indent scope.
            object_scope = "ii",

            -- Text object effecting the entire scope.
            object_scope_with_border = "ai",

            -- Motion to jump to the start of the indent scope.
            goto_top = "[i",

            -- Motion to jump to the end of the indent scope.
            goto_bottom = "]i",
        },

        -- Options which control scope computation.
        options = {
            -- Count the defining object of the scope as being part of the scope.
            -- E.g.: When the cursor is on a function definition, display an indent line
            -- surrounding the function body.
            try_as_border = true,
        },

        -- Which character to use for drawing the scope indicator.
        symbol = "│",
    })
end

return M
