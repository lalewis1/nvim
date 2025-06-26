local capabilities = require("blink.cmp").get_lsp_capabilities()
return {
	cmd = { "typescript-language-server", "--stdio" },
	capabilities = capabilities,
	filetypes = { "javascript", "typescript", "vue" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	init_options = {
		hostInfo = "neovim",
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = "/home/lawso/node_modules/lib/@vue/typescript-plugin",
				languages = { "vue" },
			},
		},
	},
}
