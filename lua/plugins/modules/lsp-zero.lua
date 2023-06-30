return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v2.x',
	dependencies = {
		-- LSP Support
		{ 'neovim/nvim-lspconfig' }, -- Required
		{                      -- Optional
			'williamboman/mason.nvim',
			build = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

		-- Autocompletion
		{ 'hrsh7th/nvim-cmp' }, -- Required
		{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
		{ 'L3MON4D3/LuaSnip' }, -- Required
		{ 'rafamadriz/friendly-snippets' },

		-- Language plugins
		{ 'simrat39/rust-tools.nvim',         ft = 'rust',             lazy = true },
		{ 'saecki/crates.nvim',               ft = { 'rust', 'toml' }, lazy = true },

		-- Extras
		{ 'j-hui/fidget.nvim',                tag = "legacy",          opts = {} },
		{ 'folke/neodev.nvim',                opts = {} },
		{ 'jose-elias-alvarez/null-ls.nvim',  ft = 'python' }
	},

	config = function()
		require("mason").setup()
		require('mason-lspconfig').setup()

		local on_attach = function(_, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

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

			-- Disable default keymaps for now
			-- lsp.default_keymaps({ buffer = bufnr })
		end

		-- LSP setup
		local lsp = require("lsp-zero").preset({})

		lsp.ensure_installed({
			"tsserver",
			"tailwindcss",
			"astro",
			"eslint",
			"dockerls",
			"docker_compose_language_service",
			"gopls",
			"rust_analyzer",
			"pyright",
			"lua_ls"
		})

		require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
		require("neodev").setup({})

		lsp.on_attach(on_attach)

		lsp.skip_server_setup({ 'rust_analyzer' })

		lsp.format_on_save({
			format_opts = {
				async = false,
				timeout_ms = 10000,
			},
			servers = {
				['lua_ls'] = { 'lua' },
				['rust_analyzer'] = { 'rust' },
				-- if you have a working setup with null-ls
				-- you can specify filetypes it can format.
				['null-ls'] = { 'javascript', 'typescript', 'python' },
			}
		})

		lsp.setup()

		require('rust-tools').setup({
			server = {
				on_attach = on_attach
			}
		})

		require('crates').setup({
			null_ls = {
				enabled = true,
				name = "crates.nvim",
			}
		})

		local null_ls = require('null-ls')
		null_ls.setup({
			sources = {
				-- TypeScript
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.eslint,

				-- Python
				null_ls.builtins.diagnostics.mypy,
				null_ls.builtins.diagnostics.ruff,
				null_ls.builtins.formatting.black,
			}
		})

		-- Autocompletion setup
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		require('luasnip.loaders.from_vscode').lazy_load()
		luasnip.config.setup {}

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'crates' }
			},
		}
	end,
}
