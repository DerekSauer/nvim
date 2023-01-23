local M = {
    -- Default options
    options = {
        ---Options for the build progress message window.
        ---@class window
        ---@field enabled boolean Open a window to display build progress messages?
        ---@field width number Width of the window in characters.
        ---@field height number Height of the window in lines.
        ---@field border string|string[] Standard Neovim border style name or arrays of characters defining the border style.
        window = {
            enabled = true,
            width = 64,
            height = 12,
            border = require("globals").border_style,
        },
    },
    progress_window = nil,
    final_config = {}
}

---Parse the build metadata emitted by Cargo to find the executable to debug.
---@param cargo_metadata string[] An array of JSON strings emitted by Cargo.
---@return string|nil #Returns the path of the debuggable executable built by
---Cargo or nil if an executable cannot be found.
local function parse_cargo_metadata(cargo_metadata)
    -- Iterate backwards through the metadata list since the executable
    -- will likely be near the end (usually second to last)
    for i = 1, #cargo_metadata do
        local json_table = cargo_metadata[#cargo_metadata + 1 - i]

        -- Some metadata lines may be blank, skip those
        if string.len(json_table) ~= 0 then
            -- Each matadata line is a JSON table,
            -- parse it into a data structure we can work with
            json_table = vim.fn.json_decode(json_table)

            -- Our binary will be the compiler artifact with an executable defined
            if json_table["reason"] == "compiler-artifact"
                and json_table["executable"] ~= vim.NIL
            then
                return json_table["executable"]
            end
        end
    end

    return nil
end

---Create the window and associated buffer and channel that will display build messages.
---@param debug_name string Name of the debug configuration. The created window will be large enough to display the whole name or the size defined in options, whichever is greater.
---@param window_options {enabled: boolean, width: number, height: number, border: string[]|string} Display options for the window.
---@return {buffer: number, window: number, channel: number}|nil #Returns the buffer that stores text for the window, the window itself, and a channel to communicate with the buffer. Returns nil on failure.
---@return string|nil If an error occurs, return a string with the error message, otherwise return nil.
local function create_window(debug_name, window_options)
    -- Create the buffer the will receive Cargo's build messages
    local new_buffer = vim.api.nvim_create_buf(false, true)
    if new_buffer == 0 then
        return nil, "Failed to create build progress message buffer."
    end

    -- Create a window that will display build messages from the buffer
    local window_width = math.max(#debug_name + 1, window_options.width)
    local window_height = window_options.height
    local new_window = vim.api.nvim_open_win(new_buffer, false, {
        relative = "editor",
        width = window_width,
        height = window_height,
        col = vim.api.nvim_get_option("columns") - window_width - 2,
        row = vim.api.nvim_get_option("lines")
            - vim.api.nvim_get_option("cmdheight")
            - window_options.height
            - 3,
        border = window_options.border,
        style = "minimal",
    })
    if new_window == 0 then
        return nil, "Failed to create build progress message window."
    end

    -- Open a channel to the buffer so we can send build messages to it
    local new_channel = vim.api.nvim_open_term(new_buffer, {})
    if new_channel == 0 then
        return nil, "Failed to create build progress message channel."
    end

    return { buffer = new_buffer, window = new_window, channel = new_channel }
end

---Destroy the build message window and associated buffer and channel.
---@param window_objects {buffer: number, window: number, channel: number}
local function destroy_window(window_objects)
    if window_objects.channel ~= 0 then
        vim.fn.chanclose(window_objects.channel)
        window_objects.channel = nil
    end

    if window_objects.window ~= 0 then
        vim.api.nvim_win_close(window_objects.window, { force = true })
        window_objects.window = nil
    end

    if window_objects.buffer ~= 0 then
        vim.api.nvim_buf_delete(window_objects.buffer, { force = true })
        window_objects.buffer = nil
    end
end

---Callback called when the Cargo process starts.
local function cargo_start()
    -- Create build progress window
    if M.options.window.enabled then
        local window_error = nil
        M.progress_window, window_error = create_window(M.final_config.name, M.options.window)
        if not M.progress_window then
            vim.api.nvim_err_writeln("Cargo Inspector Window Error:\n" .. window_error)
        end
    end
end

---Callback called when the Cargo process emits data to stderr. Cargo emits build progress messages to stderr.
---@param error string|nil If not nil, an error occured and `error` is a string containing the error message.
---@param data string Data emitted by Cargo to stderr.
---@return nil #Returns early without processing `data` if an error occurs.
local function cargo_stderr(error, data)
    if error then
        vim.api.nvim_err_writeln("Cargo Inspector: Error in Cargo's stderr callback\n" .. error)
        return
    end

    if M.progress_window then
        vim.schedule(function()
            vim.api.nvim_chan_send(M.progress_window.channel, data .. "\r\n")
        end)
    end
end

---Callback called when the Cargo process terminates.
---@param job userdata The plenary.job that is exiting.
---@param exit_code number The process's exit code.
local function cargo_exit(job, exit_code)
    -- Destroy build progress window
    if M.progress_window then
        vim.schedule(function()
            destroy_window(M.progress_window)
            M.progress_window = nil
        end)
    end

    -- If Cargo ran successfully send the build meta data off for parsing
    if exit_code == 0 then
        local executable_name = parse_cargo_metadata(job:result())
        if executable_name ~= nil then
            M.final_config.program = executable_name
        else
            vim.api.nvim_err_writeln("Cargo could not find an executable for debug configuration:\n" ..
                M.final_config.name)
        end
    else
        vim.api.nvim_err_writeln("Cargo failed to compile debug configuration:\n" .. M.final_config.name)
    end
end

---Parse the `cargo` table of a DAP configuration, running any Cargo tasks
---defined in the `cargo` table then extracting the debuggable binary that
---results. Also fills in Rust specific debugging hints for LLDB.
---@param dap_config table A DAP configuration with a `cargo` table.
---@param user_options table|nil The user's options for Cargo Inspector.
---@return table #Returns a DAP configuration with the debuggable binary
---defined and some additional Rust debugging hints for LLDB.
---@public
function M.inspect(dap_config, user_options)
    M.final_config = vim.deepcopy(dap_config)

    -- Extend default option with user's choices
    if user_options then
        M.options = vim.tbl_deep_extend('force', M.options, user_options)
    end

    -- Verify that Cargo exists
    local cargo_path = vim.fn.exepath("cargo")
    if cargo_path == "" then
        vim.api.nvim_err_writeln("Cargo Inspector Error: Cargo cannot be found.")
        return M.final_config
    end

    -- Instruct Cargo to emit build metadata as JSON
    if M.final_config.cargo.args then
        table.insert(M.final_config.cargo.args, "--message-format=json")
    else
        M.final_config.cargo.args = { "--message-format=json" }
    end

    -- Run the Cargo process
    local cargo_job = require("plenary.job"):new({
        command = "cargo",
        args = M.final_config.cargo.args,
        cwd = M.final_config.cwd,
        env = M.final_config.cargo.env,
        skip_validation = true,
        enable_handlers = true,
        on_start = cargo_start,
        on_stderr = cargo_stderr,
        on_exit = vim.schedule_wrap(cargo_exit),
        detached = false,
        enable_recording = true
    }):start()

    -- The `cargo` section of the configuration is no longer needed
    M.final_config.cargo = nil

    return M.final_config
end

return M
