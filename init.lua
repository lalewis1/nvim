vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.python3_host_prog = "$HOME/virtualenvs/nvim/bin/python3"

vim.opt.undofile = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.modeline = false -- because turtle prefixes like ex: cause issues
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.fillchars:append({ diff = "/" })
vim.opt.confirm = true
vim.opt.scrolloff = 1

require("plugins")

local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<leader>w", ":w<cr>", opts)
vim.keymap.set("n", "<leader>z", ":set wrap!<cr>", opts)
vim.keymap.set("n", "q", ":bd<cr>", opts)
vim.keymap.set("n", "<a-q>", ":qa<cr>", opts)
vim.keymap.set("n", "Q", "q", opts)

vim.keymap.set("n", "<a-a>", "ggVG", opts)
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>Y", '"+Y', opts)

-- Window movement / resizing
vim.keymap.set("n", "<c-h>", "<c-w>h", opts)
vim.keymap.set("n", "<c-j>", "<c-w>j", opts)
vim.keymap.set("n", "<c-k>", "<c-w>k", opts)
vim.keymap.set("n", "<c-l>", "<c-w>l", opts)
vim.keymap.set("n", "<a-h>", "2<c-w><", opts)
vim.keymap.set("n", "<a-j>", "2<c-w>-", opts)
vim.keymap.set("n", "<a-k>", "2<c-w>+", opts)
vim.keymap.set("n", "<a-l>", "2<c-w>>", opts)

vim.keymap.set("n", "<esc>", ":nohlsearch<cr>", opts)
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", opts)
vim.keymap.set("n", "[t", ":tabprevious<cr>", opts)
vim.keymap.set("n", "]t", ":tabnext<cr>", opts)
vim.keymap.set("n", "<a-r>", ":belowright 12split | term<cr>i", opts)
vim.keymap.set("n", "<a-p>", ":tabnew | term python<cr>i", opts)
vim.keymap.set("n", "grq", ":lua vim.diagnostic.setqflist()<cr>:copen<cr>", opts)

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable({
	"ansiblels",
	"bashls",
	"bicep",
	"docker_compose_language_service",
	"dockerls",
	"emmet_language_server",
	"gh_actions_ls",
	"html",
	"jsonls",
	"lua_ls",
	"marksman",
	"pylsp",
	"sparql",
	"tailwindcss",
	"turtle",
	"vtsls",
})

vim.filetype.add({
	extension = {
		["rq"] = "sparql",
		["trig"] = "trig",
		["ttl"] = "turtle",
		["conf"] = "nginx",
		["service"] = "systemd",
	},
})

vim.cmd.colorscheme("tokyonight")
