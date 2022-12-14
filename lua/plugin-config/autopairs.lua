local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")

if autopairs_ok then
    local config = {
        enable_check_bracket_line = true,
    }

    autopairs.setup(config)

    -- Let nvim-cmp know about autopairs
    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
else
    vim.notify("Failed to load plugin: nvim-autopairs.", vim.log.levels.ERROR)
    autopairs = nil
end
