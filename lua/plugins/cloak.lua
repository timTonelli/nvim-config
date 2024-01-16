return {
    "laytan/cloak.nvim",
    config = function()
        require("cloak").setup({
            cloak_character = "*",
            cloak_length = 16,
            patterns = {
                file_pattern = ".env*",
                cloak_pattern = "=.+",
            },
        })
    end,
}
