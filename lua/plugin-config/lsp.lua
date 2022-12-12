local loaded, lsp = pcall(require, "lsp-zero")

if loaded then
    lsp.preset('recommended')
    lsp.nvim_workspace()
    lsp.setup()
else
    vim.notify("Failed to load plugin: lsp-zero.", vim.log.levels.ERROR)
    lsp = nil
end
