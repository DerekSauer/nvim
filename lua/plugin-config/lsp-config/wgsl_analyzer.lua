local M = {}

function M.setup(lsp_zero)
    -- Get the path to `wgsl_analyzer` installed by Mason.nvim
    local wgsl_analyzer_path = require("mason-registry")
        .get_package("wgsl-analyzer")
        :get_install_path() .. "/bin/"
    local wgsl_analyzer_bin = wgsl_analyzer_path .. "wgsl_analyzer"

    lsp_zero.configure("wgsl_analyzer", {
        cmd = { wgsl_analyzer_bin },
        filetypes = { "wgsl" },
        settings = {},
    })

    -- Autocommand to reparse the launch.json file if it changes
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = { "*.wgsl" },
        command = "set filetype=wgsl",
    })
end

return M
