vim.keymap.set(
	{ "n", "i" },
	"<a-m>",
	"<cmd>r!git diff HEAD | sgpt --role Commit<cr>",
	{ desc = "Auto commit message", buffer = true }
)
