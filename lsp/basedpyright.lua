local capabilities = require("blink.cmp").get_lsp_capabilities()
return {
	cmd = { "basedpyright-langserver", "--stdio" },
	capabilities = capabilities,
	root_markers = { ".git", "pyproject.toml" },
	filetypes = { "python" },
	single_file_support = true,
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
}
