-- uv tool install python-lsp-server[pycodestyle,pyflakes,pydocstyle,mccabe]

return {
	cmd = { "pylsp" },
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
						"W391", -- blank line at end of file
						"W292", -- no newline at end of file
					},
					maxLineLength = 88,
				},
			},
		},
	},
}
