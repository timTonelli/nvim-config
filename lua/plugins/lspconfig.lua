return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "j-hui/fidget.nvim",
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        -- Configures lua_ls for writing Neovim configuration
        require("neodev").setup()

        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local diagnostic_signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

        for type, icon in pairs(diagnostic_signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        require("lspconfig.ui.windows").default_options.border = "rounded"

        vim.diagnostic.config({
            float = { border = "rounded" },
        })

        -- LSP Related Keybinds
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("LspKeybinds", { clear = true }),
            callback = function(event)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "[R]e[n]ame" })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
                    { buffer = event.buf, desc = "[C]ode [A]ction" })

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "[G]oto [D]efinition" })
                vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references,
                    { buffer = event.buf, desc = "[G]oto [R]eferences" })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
                    { buffer = event.buf, desc = "[G]oto [I]mplementation" })
                vim.keymap.set("n", "<leader>td", vim.lsp.buf.type_definition,
                    { buffer = event.buf, desc = "[T]ype [D]efinition" })
                vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols,
                    { buffer = event.buf, desc = "[D]ocument [S]ymbols" })
                vim.keymap.set(
                    "n",
                    "<leader>ws",
                    require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    { buffer = event.buf, desc = "[W]orkspace [S]ymbols" }
                )

                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover Documentation" })
                -- TODO: find a better keybind for this
                vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help,
                    { buffer = event.buf, desc = "Signature Documentation" })

                local filetype = vim.filetype.match({ buf = event.buf })

                -- python specific keymaps
                -- TODO: make a snippet
                if filetype == "python" then
                    vim.keymap.set("n", "<leader>nm", 'iif __name__ == "__main__":<CR>',
                        { buffer = event.buf, desc = "if [N]ame == [M]ain" })
                end

                -- go specific keymaps
                -- TODO: make a snippet
                if filetype == "go" then
                    vim.keymap.set("n", "<leader>he", "iif err != nil{<CR>",
                        { buffer = event.buf, desc = "[H]andle [E]rror" })
                end
            end,
        })

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
    end,
}
