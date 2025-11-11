-- uv tool install python-lsp-server[pycodestyle,pyflakes,pydocstyle,mccabe]

local capabilities = require("blink.cmp").get_lsp_capabilities()
return {
	cmd = { "pylsp" },
	capabilities = capabilities,
	root_markers = { ".git", "pyproject.toml" },
	filetypes = { "python" },
	settings = {
		pylsp = {
			plugins = {
				pydocstyle = {
					enabled = false,
				},
				mccabe = {
					enabled = false,
				},
				pycodestyle = {
					ignore = {
						"E501", -- line too long
						"W503", -- line break before binary operator
						"W504", -- line break after binary operator
					},
					maxLineLength = 88,
				},
			},
		},
	},
}
