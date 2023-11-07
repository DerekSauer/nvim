local M = {
    -- Fast and easy to configure neovim statusline plugin
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "linrongbin16/lsp-progress.nvim",
    },
}

---Gets the current time.
---@return string #Returns the current time in HH:MM format.
local function time() return "  " .. os.date("%H:%M") end

---Get the file encoding of the current buffer, ignoring UTF-8.
---@return string #Returns the file encoding of the current buffer or an empty string if the file is UTF-8.
local function encoding_override()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
end

---Get the cursor's location in the file.
---@returns string #The cursors location as `line:char (%)'
local function combined_location()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local current_col = vim.fn.virtcol(".")

    if current_line == 1 then
        return string.format(
            "󰓾 %d:%d  0%%%%",
            current_line,
            current_col,
            math.floor(current_line / total_lines * 100)
        )
    else
        return string.format(
            "󰓾 %d:%d  %d%%%%",
            current_line,
            current_col,
            math.floor(current_line / total_lines * 100)
        )
    end
end

function M.config()
    -- Enable LSP progress indicator
    require("lsp-progress").setup({
        max_size = 80,
        format = function(messages)
            if #messages > 0 then
                return messages[1] .. "  LSP"
            else
                return "  LSP"
            end
        end,
    })

    local config = {
        options = {
            icons_enabled = true,
            theme = "kanagawa",
            disabled_filetypes = { "telescope", "mason", "lazy" },
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { require("lazy.status").updates, cond = require("lazy.status").has_updates },
                "branch",
                "diff",
                "diagnostics",
                {
                    function() return "" end,
                    cond = require("nvim-treesitter.parsers").has_parser,
                },
            },
            lualine_c = {
                "filename",
            },
            lualine_x = {
                require("lsp-progress").progress,
            },
            lualine_y = { encoding_override, "fileformat", "filetype", time },
            lualine_z = { combined_location },
        },

        winbar = {
            lualine_y = { { "filename", path = 1, newfile_status = true } },
        },
        inactive_winbar = {
            lualine_y = { { "filename", path = 1, newfile_status = true } },
        },

        extensions = {
            "neo-tree",
            "quickfix",
            "symbols-outline",
            "nvim-dap-ui",
        },
    }

    require("lualine").setup(config)
end

return M
