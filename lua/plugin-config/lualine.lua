local loaded, lualine = pcall(require, "lualine")

if loaded then
    -- Don't show encoding if its utf-8
    local encoding_override = function()
        local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
        return ret
    end

    -- Don't show file format if its unix
    local fileformat_override = function()
        local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
        return ret
    end

    -- Display an icon if a tree-sitter parser is available for this buffer.
    -- TODO: Doesn't work, nvim-treesitter.parser is failing
    local treesitter_status = function()
        local ts_loaded, treesitter = pcall(require, "nvim-treesitter.parser")
        if ts_loaded then
            local ts_state = treesitter.has_parser() and "" or ""
            return ts_state
        else
            return ""
        end
    end

    -- Get loading and workspace processing status of any LSPs
    -- attached to the buffer
    local lsp_status = function()
        -- TODO: Look up what is in the table returned by this function
        -- and extract what we need
        return vim.lsp.util.get_progress_messages()[1]
    end

    -- Get the names of LSP clients attached to this buffer
    -- TODO: This doesn't work at all, ripped it off from Astronvim
    local lsp_clients = function()
        local buf_client_names = {}
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = self and self.bufnr or 0 })) do
            if client.name == "null-ls" and opts.expand_null_ls then
                local null_ls_sources = {}
                for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
                    for _, source in ipairs(astronvim.null_ls_sources(vim.bo.filetype, type)) do
                        null_ls_sources[source] = true
                    end
                end
                vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
            else
                table.insert(buf_client_names, client.name)
            end
        end
        local str = table.concat(buf_client_names, ", ")
        if type(opts.truncate) == "number" then
            local max_width = math.floor(astronvim.status.utils.width() * opts.truncate)
            if #str > max_width then
                str = string.sub(str, 0, max_width) .. "…"
            end
        end
        return astronvim.status.utils.stylize(str, opts)
    end

    local config = {
        options = {
            theme = "catppuccin",
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename", treesitter_status },
            lualine_x = { lsp_status },
            lualine_y = { encoding_override, fileformat_override, "filetype", "progress" },
            lualine_z = { "location" },
        },
    }

    -- Add navic to the winbar
    local navic_loaded, navic = pcall(require, "nvim-navic")
    if navic_loaded then
        config.winbar = {
            lualine_a = {
                { navic.get_location, cond = navic.is_available },
            },
        }
    end

    lualine.setup(config)
else
    vim.notify("Failed to load plugin: lualine.", vim.log.levels.ERROR)
    lualine = nil
end
