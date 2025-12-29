vim.diagnostic.config({ virtual_text = true })

vim.lsp.enable("luals")
vim.lsp.enable("pylsp")
-- vim.lsp.enable("basedpyright")
-- vim.lsp.enable("ruff")
vim.lsp.enable("sparql")
vim.lsp.enable("turtle")
vim.lsp.enable("bicep")
vim.lsp.enable("emmet")
vim.lsp.enable("html")
vim.lsp.enable("json")
vim.lsp.enable("vtsls")
vim.lsp.enable("bashls")
vim.lsp.enable("gh_actions_ls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("dockerls")
vim.lsp.enable("ansiblels")
vim.lsp.enable("marksman")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then
			vim.keymap.set("n", "grq", ":lua vim.diagnostic.setqflist()<cr>:copen<cr>", { buffer = ev.buf })
			if client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
			end
		end
	end,
})
