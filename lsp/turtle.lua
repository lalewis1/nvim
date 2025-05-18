local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { "node", "/home/lawso/node_modules/bin/turtle-language-server", "--stdio" },
  capabilities = capabilities,
  filetypes = { "turtle" },
}
