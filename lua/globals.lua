local M = {}

-- Prefered border style for float windows
M.border_style = { "╒", "═", "╕", "│", "╛", "═", "╘", "│" }

-- Auto command group for our own commands
M.user_au_group = vim.api.nvim_create_augroup("user_cmds", { clear = true })

return M
