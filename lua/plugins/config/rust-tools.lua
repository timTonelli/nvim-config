return function()
  require('rust-tools').setup({
    server = {
      on_attach = require 'plugins.config.lspconfig.on-attach',
    },
  })
end
