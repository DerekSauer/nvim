-- Setup null-ls
local loaded, null_ls = pcall(require, "null-ls")
if loaded then
    local null_ls_config = {
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.diagnostics.selene
        }
    }

    null_ls.setup(null_ls_config)
else
    vim.notify("Failed to setup plugin: null-ls.", vim.log.levels.ERROR)
end
