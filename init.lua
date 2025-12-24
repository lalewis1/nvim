vim.opt.undofile = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.confirm = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.modeline = false
vim.opt.signcolumn = "yes"
vim.opt.wildignorecase = true
vim.opt.scrolloff = 2

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = false
vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"
vim.g.netrw_sizestyle = "H"

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>z", ":set wrap!<cr>")
vim.keymap.set("n", "q", ":bd<cr>")
vim.keymap.set("n", "<a-q>", ":qa<cr>")
vim.keymap.set("n", "Q", "q")
vim.keymap.set("n", "<a-h>", "2<c-w><")
vim.keymap.set("n", "<a-j>", "2<c-w>-")
vim.keymap.set("n", "<a-k>", "2<c-w>+")
vim.keymap.set("n", "<a-l>", "2<c-w>>")
vim.keymap.set("n", "<esc>", ":nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<a-a>", "ggVG")
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "exit terminal mode" })
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "[t", ":tabprevious<cr>")
vim.keymap.set("n", "]t", ":tabnext<cr>")
vim.keymap.set("n", "<tab>", ":bp<cr>")
vim.keymap.set("n", "<s-tab>", ":bn<cr>")
vim.keymap.set("n", "<a-r>", ":belowright 12split | term<cr>i", { desc = "terminal (repl)" })
vim.keymap.set("n", "<a-p>", ":tabnew | term python<cr>i", { desc = "python console" })

require("plugins")
local funcs = require("functions")

vim.keymap.set("n", "<leader>t", funcs.taskpicker)

vim.cmd.colorscheme("tokyonight")

vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable("luals")
-- vim.lsp.enable("basedpyright")
vim.lsp.enable("pylsp")
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

vim.filetype.add({
	extension = {
		["trig"] = "trig",
		["ttl"] = "turtle",
		["conf"] = "nginx",
		["service"] = "systemd",
	},
})
