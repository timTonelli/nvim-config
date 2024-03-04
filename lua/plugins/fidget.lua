return {
    "j-hui/fidget.nvim",
    tag = "v1.4.0",
    opts = {
        progress = {
            display = {
                overrides = { -- Override options from the default notification config
                    rust_analyzer = { name = "rust-analyzer" },
                },
            },
        },
    },
}
