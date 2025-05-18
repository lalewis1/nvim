local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = capabilities,
  filetypes = { "python" },
  root_markers = { ".git", "pyproject.toml" }
}
