vim.opt.undofile = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.confirm = true
vim.opt.laststatus = 3
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.modeline = false
vim.opt.signcolumn = "yes"
vim.opt.wildignorecase = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "-", ":Explore<cr>")
vim.keymap.set("n", "<leader>z", ":set wrap!<cr>")
vim.keymap.set("n", "q", "<c-w>q")
vim.keymap.set("n", "Q", "q")
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<a-h>", "2<c-w><")
vim.keymap.set("n", "<a-j>", "2<c-w>-")
vim.keymap.set("n", "<a-k>", "2<c-w>+")
vim.keymap.set("n", "<a-l>", "2<c-w>>")
vim.keymap.set("n", "<esc>", ":nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<a-a>", "ggVG")
vim.keymap.set("n", "<tab>", "<c-^>")
vim.keymap.set("n", "<leader>px", function()
	local input = vim.fn.input({ prompt = "prefix: " })
	if input then
		local cmdstr = string.format(
			"r! curl --silent https://kurrawong.github.io/semantic-background/ns/%s.file.json | jq -r '.%s'",
			input,
			input
		)
		vim.cmd(cmdstr)
	end
end, { desc = "semantic background prefix lookup" })

vim.g.netrw_banner = false
vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

require("plugins")

vim.cmd.colorscheme("solarized")

vim.diagnostic.config({ virtual_text = true, signs = true })
vim.lsp.enable("luals")
vim.lsp.enable("pylsp")
vim.lsp.enable("ruff")
vim.lsp.enable("sparql")
vim.lsp.enable("turtle")
vim.lsp.enable("bicep")
vim.lsp.enable("emmet")
vim.lsp.enable("html")
vim.lsp.enable("volar")
vim.lsp.enable("ts_ls")
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
