return {
	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',

	require("plugins.modules.lsp-zero"),
	require("plugins.modules.nvim-treesitter"),
	require("plugins.modules.nvim-telescope"),
	require("plugins.modules.nvim-dap"),
	require("plugins.modules.comment"),
	require("plugins.modules.nvim-tree"),
	require("plugins.modules.nvim-surround"),
	require("plugins.modules.nvim-autopairs"),
	require("plugins.modules.which-key"),

	require("plugins.modules.lualine"),

	require("plugins.modules.indent-blankline"),
}
