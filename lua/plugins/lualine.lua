return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "Mofiqul/dracula.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            icons_enabled = true,
            theme = "dracula",
            component_separators = "|",
        },
        sections = {
            lualine_b = { { "branch", icon = "" } },
            lualine_c = {
                { "filename", path = 1 }, -- relative from the directory nvim was opened in
            },
            lualine_x = {},
            lualine_y = { "filetype" },
        },
    },
}
