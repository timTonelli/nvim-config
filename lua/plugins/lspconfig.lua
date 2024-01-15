return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "j-hui/fidget.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local diagnostic_signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

        for type, icon in pairs(diagnostic_signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        require("lspconfig.ui.windows").default_options.border = "rounded"

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local lsp_capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

        local default_handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        }

        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup_handlers({
            -- Default handler for all servers
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = lsp_capabilities,
                    handlers = vim.tbl_deep_extend("force", {}, default_handlers),
                })
            end,

            -- Overrides for specific servers
            rust_analyzer = function() end,
            lua_ls = function()
                lspconfig.lua_ls.setup({
                    capabilities = lsp_capabilities,
                    settings = { -- custom settings for lua
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                -- make language server aware of runtime files
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.stdpath("config") .. "/lua"] = true,
                                },
                            },
                        },
                    },
                })
            end,
        })

        -- configure typescript server with plugin
        -- typescript.setup({
        -- 	server = {
        -- 		capabilities = lsp_capabilities,
        -- 		on_attach = on_attach,
        -- 	},
        -- })
    end,
}
