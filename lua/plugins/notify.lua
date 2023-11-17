local M = {
    -- Automatic pair (parens, brackets, etc...) insertion.
    "rcarriga/nvim-notify",
}

function M.config()
    -- Assign `nvim-notify` as the global notification daemon.
    vim.notify = require("notify")
end

return M
