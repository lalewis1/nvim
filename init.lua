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

vim.keymap.set("n", "<leader>t", funcs.taskpicker, { desc = "Task picker" })
vim.keymap.set("n", "<leader>x", funcs.expand_prefix, { desc = "Expand a prefix" })

require("lsp")

vim.filetype.add({
	extension = {
		["rq"] = "sparql",
		["trig"] = "trig",
		["ttl"] = "turtle",
		["conf"] = "nginx",
		["service"] = "systemd",
	},
})

vim.cmd.colorscheme("kanagawa")
