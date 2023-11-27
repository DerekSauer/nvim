local M = {
    -- Add or delete surrounding text (Brackets, function decorators, etc...)
    "echasnovski/mini.surround",
    version = false,
}

function M.config()
    require("mini.surround").setup()
end

return M
