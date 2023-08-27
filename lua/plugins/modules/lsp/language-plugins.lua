return {
  -- Rust
  { 'simrat39/rust-tools.nvim', ft = 'rust', lazy = true },
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    'saecki/crates.nvim',
    event = 'BufRead Cargo.toml',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('crates').setup()
    end,
  },
}
