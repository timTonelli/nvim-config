return {
    -- Rust Plugins
    { "mrcjkb/rustaceanvim", version = "^3", ft = { "rust" } },
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup()
        end,
    },
}
