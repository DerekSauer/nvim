local M = {
    -- Add `inside` and `around` text objects.
    "echasnovski/mini.ai",
    version = false,
}

function M.config()
    require("mini.ai").setup()
end

return M
