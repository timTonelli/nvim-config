-------------------------------------- globals -----------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-------------------------------------- options -----------------------------------------

-- Tab size
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Enable break indent
vim.o.breakindent = true
vim.o.smartindent = true

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Line wrap
vim.opt.wrap = false

-- Min lines between cursor and beginning/end of file
vim.opt.scrolloff = 8

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Save undo history
vim.o.undofile = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
-- vim.o.clipboard = 'unnamedplus'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
