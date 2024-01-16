return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", tag = "nerd-v2-compat" },
    },
    config = function()
        require("nvim-tree").setup({
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
        })

        vim.keymap.set("n", "<C-f>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle file tree" })
        -- vim.keymap.set("n", "<leader>ft", "<cmd> NvimTreeFocus <CR>", { desc = "Focus file tree" })
    end,
}
