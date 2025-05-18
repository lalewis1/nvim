local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { 'ruff', 'server' },
  capabilities = capabilities,
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  settings = {},
}
