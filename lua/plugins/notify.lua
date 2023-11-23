local M = {
    -- Notification daemon.
    "rcarriga/nvim-notify",
}

function M.config()
    -- Assign `nvim-notify` as the global notification daemon.
    vim.notify = require("notify")
end

return M
