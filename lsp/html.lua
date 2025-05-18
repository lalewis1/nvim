local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
return {
	cmd = { "vscode-html-language-server", "--stdio" },
	capabilities = capabilities,
	filetypes = { "html", "vue", "htmldjango" },
	init_options = {
		provideFormatter = false,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
}
