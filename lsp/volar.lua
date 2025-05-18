local capabilities = require('blink.cmp').get_lsp_capabilities()
return {
	cmd = { "vue-language-server", "--stdio" },
  capabilities = capabilities,
	filetypes = { "vue" },
	root_markers = { "package.json" },
	init_options = {
		typescript = {
			tsdk = "/home/lawso/node_modules/lib/node_modules/typescript/lib/",
		},
	},
}
