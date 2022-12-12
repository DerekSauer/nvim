local M = {}

-- Prefered border style for float windows
M.border_style = { "╒", "═" ,"╕", "│", "╛", "═", "╘", "│" }

-- Configure nvim's diagnostics interface
vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = M.border_style,
        format = function(diagnostic)
            return string.format(
                    "%s (%s) [%s]", 
                    diagnostic.message,
                    diagnostic.source,
                    diagnostic.code or
                    diagnostic.user_data.lsp.code
            )
        end
    }
})

-- Define icons for diagnostics
vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",  {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",  {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",  {text = "", texthl = "DiagnosticSignHint"})

-- Auto command group for our own commands
M.user_au_group = vim.api.nvim_create_augroup('user_cmds', { clear = true })

-- Briefly flash highlighted text when yanking it
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = user_au_group,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
  end,
})

-- Allow closing the following buffer file types by pressing 'q'
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help', 'man'},
  group = user_au_group,
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

return M
