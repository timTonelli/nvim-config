return {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = { "Mofiqul/dracula.nvim" },
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = false,
            theme = "dracula",
            component_separators = "|",
            section_separators = "",
        },
    },
}
