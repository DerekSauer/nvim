local config = {
    options = {
        dim_inactive = true,
        styles = {
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE",
            functions = "bold",
            keywords = "italic",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
        },
        modules = { },
    },
}

require("nightfox").setup(config)
vim.cmd("colorscheme duskfox")
