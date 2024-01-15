return {
    "nvimtools/none-ls.nvim", -- configure formatters & linters
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local null_ls = require("null-ls")
        local null_ls_utils = require("null-ls.utils")

        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions

        local sources = {
            --[[ formatters ]]
            formatting.prettierd.with({ extra_filetypes = { "astro" } }), -- js/ts
            formatting.stylua, -- lua
            formatting.black, -- python
            -- formatting.djhtml, -- html jinja templates

            --[[ diagnostics ]]
            diagnostics.eslint_d.with({
                -- TODO: should this condition be here?
                condition = function(utils)
                    return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
                end,
            }),
            diagnostics.ruff, -- python

            --[[ code actions ]]
            code_actions.eslint_d.with({
                -- TODO: should this condition be here?
                condition = function(utils)
                    return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
                end,
            }),
        }

        local format_on_save = vim.api.nvim_create_augroup("LspFormatting", {})
        local on_attach = function(current_client, bufnr)
            if current_client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = format_on_save, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = format_on_save,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            filter = function(client)
                                --  only use null-ls for formatting instead of lsp server
                                return client.name == "null-ls"
                            end,
                            bufnr = bufnr,
                        })
                    end,
                })
            end
        end

        null_ls.setup({
            root_dir = null_ls_utils.root_pattern("Cargo.toml", "go.mod", "package.json", "pyproject.toml", ".null-ls-root", "Makefile", ".git"),
            sources = sources,
            on_attach = on_attach,
        })
    end,
}
