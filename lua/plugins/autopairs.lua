local M = {
    -- Automatic pair (parens, brackets, etc...) insertion
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    dependencies = { "nvim-cmp" },
}

function M.config()
    local autopairs = require("nvim-autopairs")

    local config = {
        enable_check_bracket_line = true,
    }

    autopairs.setup(config)

    -- Let nvim-cmp know about autopairs
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
