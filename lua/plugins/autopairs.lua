local M = {
    -- Automatic pair (parenthesis, brackets, etc…) insertion.
    "windwp/nvim-autopairs",

    -- Enable auto pairs when entering insert mode in a buffer.
    event = "InsertEnter",
}

function M.config()
    require("nvim-autopairs").setup()
end

return M
