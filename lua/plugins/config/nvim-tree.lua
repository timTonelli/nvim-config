return function()
  require("nvim-tree").setup()
  vim.keymap.set('n', '<C-f>', '<cmd> NvimTreeToggle <CR>', { desc = 'Toggle file tree' })
  vim.keymap.set('n', '<leader>ft', '<cmd> NvimTreeFocus <CR>', { desc = 'Focus file tree' })
end
