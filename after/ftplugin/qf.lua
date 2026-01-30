vim.keymap.set(
	"n",
	"<tab>",
	"j<cr><c-w>j",
	{ silent = true, buffer = true, noremap = true, desc = "preview quickfix item (next)" }
)
vim.keymap.set(
	"n",
	"<s-tab>",
	"k<cr><c-w>j",
	{ silent = true, buffer = true, noremap = true, desc = "preview quickfix item (prev)" }
)
