local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
  cmd = { "pylsp" },
  capabilities = capabilities,
  root_markers = { ".git", "pyproject.toml" },
  filetypes = { "python" }
}
