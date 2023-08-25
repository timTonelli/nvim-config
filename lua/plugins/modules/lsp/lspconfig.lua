return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- enable keybinds only for when lsp server available
		local on_attach = function(_, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end
			local opts = { noremap = true, silent = true, buffer = bufnr }

			nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
			nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
			nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
			nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })

			-- typescript specific keymaps (e.g. rename file and update imports)
			if client.name == "tsserver" then
				opts.desc = "Rename file and update file imports"
				keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports

				opts.desc = "Rename file and update file imports"
				keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>", opts) -- organize imports (not in youtube nvim video)

				opts.desc = "Remove unused imports"
				keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>", opts) -- remove unused variables (not in youtube nvim video)
			end
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local lsp_capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local mason_lspconfig = require('mason-lspconfig')
		mason_lspconfig.setup_handlers({
			-- Generic handler for all servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = lsp_capabilities,
					on_attach = on_attach
				})
			end,

			-- Overrides for specific servers
			["rust_analyzer"] = function()
				require("rust-tools").setup {
					server = {
						capabilities = lsp_capabilities,
						on_attach = on_attach
					}
				}
			end,
			["lua_ls"] = function()
				lspconfig.lua_ls.setup {
					capabilities = lsp_capabilities,
					on_attach = on_attach,
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
				}
			end,
		})

		-- configure html server
		lspconfig["html"].setup({
			capabilities = lsp_capabilities,
			on_attach = on_attach,
			filetypes = { "html", "htmldjango" }
		})

		-- configure typescript server with plugin
		-- typescript.setup({
		-- 	server = {
		-- 		capabilities = lsp_capabilities,
		-- 		on_attach = on_attach,
		-- 	},
		-- })

		-- configure css server
		-- lspconfig["cssls"].setup({
		-- 	capabilities = lsp_capabilities,
		-- 	on_attach = on_attach,
		-- })

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = lsp_capabilities,
			on_attach = on_attach,
		})

		-- configure svelte server
		-- lspconfig["svelte"].setup({
		-- 	capabilities = lsp_capabilities,
		-- 	on_attach = on_attach,
		-- })

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = lsp_capabilities,
			on_attach = on_attach,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
				"htmldjango"
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = lsp_capabilities,
			on_attach = on_attach,
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
}
