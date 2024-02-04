return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        -- import mason-null-ls plugin safely
        local mason_null_ls = require("mason-null-ls")

        -- enable mason
        mason.setup({
            ui = {
                border = "rounded",
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "lua_ls",
                "gopls",
                "tsserver",
                "astro",
                "html",
                "tailwindcss",
                "dockerls",
                "pyright",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = false, -- not the same as ensure_installed
        })

        mason_null_ls.setup({
            ensure_installed = {
                --[[ formatters ]]
                "gofmt", -- go
                -- "prettierd", -- ts/js
                "prettier", -- ts/js
                "djhtml", -- html jinja template
                "black", -- python
                "stylua", -- lua

                --[[ linters/code action tools ]]
                "eslint_d", -- ts/js
                "ruff", -- python
            },
            automatic_installation = false,
        })
    end,
}
