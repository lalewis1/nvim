local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
	cmd = { "vscode-json-language-server", "--stdio" },
  capabilities = capabilities,
	filetypes = { "json", "jsonc" },
	root_markers = { ".git" },
}
