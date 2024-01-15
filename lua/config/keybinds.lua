-- Set leader key to space
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap for moving selected text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- LSP Related Keybinds
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Related Keybinds",
    callback = function(event)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "[R]e[n]ame" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "[C]ode [A]ction" })

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "[G]oto [D]efinition" })
        vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { buffer = event.buf, desc = "[G]oto [R]eferences" })
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = event.buf, desc = "[G]oto [I]mplementation" })
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = event.buf, desc = "Type [D]efinition" })
        vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, { buffer = event.buf, desc = "[D]ocument [S]ymbols" })
        vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, { buffer = event.buf, desc = "[W]orkspace [S]ymbols" })

        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover Documentation" })
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "Signature Documentation" })
    end,
})
