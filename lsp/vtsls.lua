local vue_language_server_path = "vue-language-server"

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

local capabilities = require("blink.cmp").get_lsp_capabilities()
return {
	cmd = { "vtsls", "--stdio" },
	capabilities = capabilities,
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
}
