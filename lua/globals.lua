local M = {}

-- Prefered border style for float windows
M.border_style = "single"

-- Define icons for diagnostics
vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",  {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",  {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",  {text = "", texthl = "DiagnosticSignHint"})

return M
