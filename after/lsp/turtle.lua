local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { "turtle-language-server", "--stdio" },
  capabilities = capabilities,
  filetypes = { "turtle" },
}
