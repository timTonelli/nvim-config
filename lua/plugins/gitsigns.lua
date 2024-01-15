return {
    "lewis6991/gitsigns.nvim",
    tag = "v0.7",
    opts = {
        -- See `:help gitsigns.txt`
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            vim.keymap.set("n", "[c", gitsigns.prev_hunk, { buffer = bufnr, desc = "Go to Previous Hunk" })
            vim.keymap.set("n", "]c", gitsigns.next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
            vim.keymap.set("n", "<leader>ph", gitsigns.preview_hunk, { buffer = bufnr, desc = "[P]review [H]unk" })
        end,
    },
}
