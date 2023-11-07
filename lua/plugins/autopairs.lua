local M = {
    -- Automatic pair (parens, brackets, etc...) insertion.
    "windwp/nvim-autopairs",

    -- Enable auto pairs when entering insert mode in a buffer.
    event = "InsertEnter",
}

function M.config()
    require("nvim-autopairs").setup()

    -- Enable interop between `nvim-cmp` and `nvim-autopairs`.
    -- After selecting a completion it moves the cursor into the
    -- function parameters list automatically.
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
