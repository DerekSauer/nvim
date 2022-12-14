local comment_ok, comment = pcall(require, "Comment")

if comment_ok then
    local config = {
        create_mappings = false,
    }

    comment.setup(config)

    vim.keymap.set("n", "<leader>/", function()
        require("Comment.api").toggle.linewise.current()
    end, { desc = "Toggle comment" })

    vim.keymap.set(
        "v",
        "<leader>/",
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        { desc = "Toggle comment" }
    )
else
    vim.notify("Failed to load plugin: comment.nvim.", vim.log.levels.ERROR)
    comment = nil
end
