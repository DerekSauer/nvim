local M = {
    -- Lightweight yet powerful formatter plugin for Neovim.
    "stevearc/conform.nvim",

    -- Enable conform just before saving a file.
    event = "BufWritePre",

    -- Enable conform if we try to access it status info.
    cmd = "ConformInfo",
}

function M.config()
    require("conform").setup({
        -- Specify formatters by file type.
        formatters_by_ft = {
            -- Language specific formatters.
            lua = { "stylua" },
            rust = { "rustfmt" },
            toml = { "taplo" },
        },

        -- Automatically format the buffer when saving the file.
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 500,
        },
    })

    -- Rust Formatter specific options.
    require("conform").formatters.rustfmt = {
        -- Assume Rust 2021.
        args = { "--edition", "2021" },
    }

    -- Define a user command to run conform on the current buffer or selection.
    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })
end

return M
