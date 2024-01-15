local M = {
    -- Fast and easy to configure Neovim status line plugin
    "nvim-lualine/lualine.nvim",

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
}

---Gets the current time.
---@return string #Returns the current time in HH:MM format.
local function time()
    return "  " .. os.date("%H:%M")
end

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

    -- If the cursor is on the first line, force the position to be zero percent.
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

---Get a list of LSP clients attached to the current buffer.
---@returns string #A comma separated list of LSP clients attached to the current buffer.
local function attached_lsp()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    local lsp_list = {}

    for _, client in pairs(attached_clients) do
        table.insert(lsp_list, client.name)
    end

    return table.concat(lsp_list, ",")
end

function M.config()
    local config = {
        options = {
            icons_enabled = true,
            theme = "kanagawa",
            disabled_filetypes = { "telescope" },
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
                    function()
                        return ""
                    end,
                    cond = require("nvim-treesitter.parsers").has_parser,
                },
            },
            lualine_c = { "filename" },
            lualine_x = { attached_lsp },
            lualine_y = { encoding_override, "fileformat", "filetype", time },
            lualine_z = { combined_location },
        },

        extensions = {
            "mason",
            "lazy",
            "neo-tree",
            "quickfix",
            "nvim-dap-ui",
        },
    }

    require("lualine").setup(config)

    -- Listen for LSP progress messages and update the status bar.
    vim.api.nvim_create_autocmd({ "LspProgress" }, {
        callback = function()
            require("lualine").refresh({ scope = "window", place = { "statusline" } })
        end,
        desc = "Listen for new LSP progress messages.",
    })
end

return M
