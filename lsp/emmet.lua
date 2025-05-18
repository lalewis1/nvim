local capabilities = require("blink.cmp").get_lsp_capabilities()
return {
	cmd = { "emmet-ls", "--stdio" },
	capabilities = capabilities,
	root_markers = { ".git" },
	filetypes = {
		"astro",
		"css",
		"eruby",
		"html",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"svelte",
		"typescriptreact",
		"vue",
		"htmlangular",
	},
}
