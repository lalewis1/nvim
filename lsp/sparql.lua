local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { "sparql-language-server", "--stdio" },
  capabilities = capabilities,
  filetypes = { "sparql" }
}
