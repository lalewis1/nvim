local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { 'lua-language-server' },
  capabilities = capabilities,
  filetypes = { 'lua' },
  root_markers = { ".git", '.luarc.json', '.luarc.jsonc' },
}
