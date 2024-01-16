return {
    -- Rust Plugins
    { "mrcjkb/rustaceanvim", version = "^3", ft = { "rust" } },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup()
        end,
    },
}
