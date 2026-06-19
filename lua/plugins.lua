local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {

		-- Miscellanous
		-- ##########################################################
		{ "neovim/nvim-lspconfig" },
		{ "LunarVim/bigfile.nvim" },
		{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
		{ "maxmx03/solarized.nvim" },
		{ "olimorris/onedarkpro.nvim" },
		{ "rebelot/kanagawa.nvim" },
		{ "folke/tokyonight.nvim" },
		{ "karb94/neoscroll.nvim", opts = { duration_multiplier = 0.4 } },
		{ "sphamba/smear-cursor.nvim", opts = { smear_insert_mode = false } },
		{
			"shortcuts/no-neck-pain.nvim",
			opts = {
				width = 140,
				autocmds = {
					enableOnVimEnter = true,
					enableOnTabEnter = true,
				},
				mappings = {
					enabled = true,
					toggle = "<leader>np",
				},
			},
		},
		{
			"XXiaoA/atone.nvim",
			cmd = "Atone",
			opts = {
				ui = {
					compact = true,
				},
			},
			keys = {
				{ "<a-u>", ":Atone<cr>", { desc = "Undo Tree (atone)", silent = true } },
			},
		},
		-- Debugmaster
		-- ##########################################################
		{
			"miroshQa/debugmaster.nvim",
			dependencies = {
				"mfussenegger/nvim-dap",
				"mfussenegger/nvim-dap-python",
				"theHamsta/nvim-dap-virtual-text",
			},
			config = function()
				require("nvim-dap-virtual-text").setup({})

				local orignal_signcolumn_bg = ""
				vim.api.nvim_create_autocmd("User", {
					pattern = "DebugModeChanged",
					callback = function(args)
						local sc_hl = vim.api.nvim_get_hl(0, { name = "SignColumn", link = false })
						if not orignal_signcolumn_bg and sc_hl.bg then
							orignal_signcolumn_bg = string.format("#%06x", sc_hl.bg)
						end
						if args.data.enabled then
							vim.api.nvim_set_hl(0, "SignColumn", { bg = "#4a4433" })
						else
							vim.api.nvim_set_hl(0, "SignColumn", { bg = orignal_signcolumn_bg })
						end
					end,
				})

				local dap = require("dap")
				-- prevent unnecessary buffer switching
				dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"

				local dappy = require("dap-python")
				dappy.setup("~/.local/share/uv/tools/debugpy/bin/python")
				dappy.test_runner = "pytest"
				table.insert(dap.configurations.python, {
					type = "python",
					request = "launch",
					name = "select file",
					program = "${command:pickFile}",
					console = "integratedTerminal",
				})
				table.insert(dap.configurations.python, {
					type = "python",
					request = "launch",
					name = "select file (jinja and allcode)",
					program = "${command:pickFile}",
					console = "integratedTerminal",
					jinja = true,
					justMyCode = false,
				})
			end,
			keys = {
				{
					"<a-d>",
					":lua require('debugmaster').mode.toggle()<cr>:NoNeckPain<cr>",
					{ desc = "Debug Mode toggle", silent = true },
				},
				{ "<leader>v", ":DapVirtualTextToggle<cr>", { desc = "Virtal text (toggle)", silent = true } },
			},
		},
		-- Neotest
		-- ##########################################################
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-neotest/nvim-nio",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
				"nvim-neotest/neotest-python",
			},
			config = function()
				require("neotest").setup({
					adapters = {
						require("neotest-python"),
					},
				})
			end,
			keys = {
				{
					"<leader>ts",
					":lua require('neotest').summary.toggle()<cr>",
					{ desc = "Toggle test summary", silent = true },
				},
				{
					"<leader>to",
					":lua require('neotest').output_panel.toggle()<cr>",
					{ desc = "Toggle test output", silent = true },
				},
				{ "<leader>tn", ":lua require('neotest').run.run()<cr>", { desc = "Test nearest", silent = true } },
				{
					"<leader>td",
					":lua require('neotest').run.run({strategy = 'dap'})<cr>",
					{ desc = "Debug nearest", silent = true },
				},
			},
		},
		-- Treesitter
		-- ##########################################################
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				vim.o.foldmethod = "expr"
				vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.o.foldlevel = 99
				vim.api.nvim_create_autocmd("FileType", {
					pattern = {
						"python",
						"markdown",
						"yaml",
						"lua",
						"html",
						"css",
						"javascript",
						"typescript",
						"vue",
						"toml",
						"json",
						"dockerfile",
						"terraform",
						"bicep",
						"sparql",
						"turtle",
						"http",
						"hurl",
					},
					callback = function()
						vim.treesitter.start()
					end,
				})
			end,
		},
		-- CodeCompanion
		-- ##########################################################
		{
			"olimorris/codecompanion.nvim",
			config = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			opts = {
				interactions = {
					chat = {
						adapter = "openai",
					},
					inline = {
						adapter = "openai",
					},
				},
			},
			keys = {
				{ "<a-c>", ":CodeCompanionChat toggle<cr>", { desc = "Chat Mode (toggle)", silent = true } },
				{ "<a-c>", "<esc>:CodeCompanion ", mode = "i" },
			},
		},
		-- Kulala
		-- ##########################################################
		{
			"mistweaverco/kulala.nvim",
			ft = { "http" },
			opts = {
				contenttypes = {
					["application/sparql-query"] = {
						ft = "sparql",
					},
					["application/sparql-results+json"] = {
						ft = "json",
						formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
					},
					["application/ld+json"] = {
						ft = "json",
						formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
					},
					["text/turtle"] = {
						ft = "turtle",
					},
					["text/anot+turtle"] = {
						ft = "turtle",
					},
					["text/csv"] = {
						ft = "csv",
					},
				},
			},
		},
		-- Telescope
		-- ##########################################################
		{
			"nvim-telescope/telescope.nvim",
			event = "VeryLazy",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
			},
			keys = {
				{ "<a-f>", ":Telescope find_files<cr>", { desc = "Find files", silent = true } },
				{ "<a-F>", ":Telescope resume<cr>", { desc = "Resume fuzzy find", silent = true } },
				{ "<a-b>", ":Telescope builtin<cr>", { desc = "Telescope built ins", silent = true } },
				{ "<leader>fo", ":Telescope oldfiles<cr>", { desc = "Find old files", silent = true } },
				{ "<leader>fg", ":Telescope live_grep<cr>", { desc = "Find grep", silent = true } },
				{ "<leader>fb", ":Telescope buffers<cr>", { desc = "Find buffers", silent = true } },
				{ "<leader>fh", ":Telescope help_tags<cr>", { desc = "Find helptags", silent = true } },
				{ "<leader>fc", ":Telescope colorscheme<cr>", { desc = "Find colorschemes", silent = true } },
			},
			config = function()
				local telescope = require("telescope")
				telescope.setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
				})
				telescope.load_extension("ui-select")
			end,
		},
		-- blink.cmp
		-- ##########################################################
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets", "mayromr/blink-cmp-dap" },
			event = "VeryLazy",
			version = "1.*",
			opts = {
				keymap = { preset = "super-tab" },
				completion = { documentation = { auto_show = true } },
				sources = {
					default = { "dap", "lsp", "path", "snippets", "buffer" },
					providers = {
						dap = {
							module = "blink-cmp-dap",
							name = "DAP",
						},
					},
				},
			},
			opts_extend = { "sources.default" },
		},
		-- Conform
		-- ##########################################################
		{
			"stevearc/conform.nvim",
			opts = {
				formatters = {
					bicep = {
						command = "az",
						args = { "bicep", "format", "-f", "$FILENAME" },
						stdin = false,
					},
					sparql_fmt = {
						command = "sparql-formatter",
						args = { "$FILENAME" },
						stdin = true,
					},
					kurra = {
						command = "kurra",
						args = { "file", "reformat", "-f", "longturtle", "$FILENAME" },
						stdin = false,
					},
					hurl = {
						command = "hurl",
						args = { "--test", "$FILENAME" },
						stdin = false,
					},
				},
				formatters_by_ft = {
					python = { "black", "isort" },
					json = { "jq" },
					lua = { "stylua" },
					markdown = { "prettier" },
					bicep = { "bicep" },
					sql = { "sqlfmt" },
					typescript = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					vue = { "prettier" },
					sparql = { "sparql_fmt" },
					sh = { "shfmt" },
					turtle = { "kurra" },
					hurl = { "hurl" },
				},
			},
			keys = {
				{
					"<leader>fm",
					":lua require('conform').format({ async = true })<cr>",
					{ desc = "Format buffer", silent = true },
				},
			},
		},
		-- Oil
		-- ##########################################################
		{
			"stevearc/oil.nvim",
			event = "VimEnter",
			opts = {
				default_file_explorer = true,
				keymaps = {
					["gs"] = {
						callback = function()
							require("oil").set_columns({ "mtime", "permissions", "size" })
						end,
						mode = "n",
						desc = "Long listing (show)",
					},
					["gh"] = {
						callback = function()
							require("oil").set_columns({})
						end,
						mode = "n",
						desc = "Long listing (hide)",
					},
				},
			},
			keys = {
				{ "-", ":Oil<cr>", { desc = "Oil", silent = true } },
			},
		},
		-- Neogit
		-- ##########################################################
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"sindrets/diffview.nvim", -- optional - Diff integration
				"nvim-telescope/telescope.nvim", -- optional
			},
			opts = {
				graph_style = "unicode",
				process_spinner = true,
				commit_editor = {
					show_staged_diff = false,
				},
			},
			keys = {
				{ "<a-n>", ":Neogit<cr>", { desc = "Neogit", silent = true } },
			},
		},
		-- Diffview
		-- ##########################################################
		{
			"sindrets/diffview.nvim",
			event = "VeryLazy",
			opts = {
				use_icons = false,
				enhanced_diff_hl = true,
				keymaps = {
					view = {
						{ "n", "q", ":tabclose<cr>", { silent = true } },
					},
					file_panel = {
						{ "n", "q", ":tabclose<cr>", { silent = true } },
					},
					file_history_panel = {
						{ "n", "q", ":tabclose<cr>", { silent = true } },
					},
				},
			},
			keys = {
				{ "<leader>dv", ":DiffviewOpen<cr>", { desc = "Diffview", silent = true } },
				{ "<leader>df", ":DiffviewFileHistory %<cr>", { desc = "Diffview File history", silent = true } },
			},
		},
		-- Markdown Render / Preview
		-- ##########################################################
		{
			"brianhuster/live-preview.nvim",
			ft = { "markdown" },
			keys = {
				{ "<leader>lp", ":LivePreview start<cr>", { desc = "Live preview (markdown)", silent = true } },
			},
		},
		-- MeowReview
		-- ##########################################################
		{
			"retran/meow.review.nvim",
			dependencies = { "MunifTanjim/nui.nvim", "nvimtools/hydra.nvim" },
			event = "VeryLazy",
			config = function()
				require("meow.review").setup({
					default_exporter = "vibetmux",
				})
				require("meow.review").register_exporter("vibetmux", function(markdown, _root)
					local handle = io.popen("tmux list-panes -F '#{pane_id} #{pane_title}'")
					local result = handle:read("*a")
					handle:close()
					local vibe_pane_id = nil
					for pane_id, title in result:gmatch("(%S+) (%S+)") do
						if title:find("Vibe") then
							vibe_pane_id = pane_id
							break
						end
					end
					if not vibe_pane_id then
						vim.notify("MeowReview: No tmux pane running vibe", vim.log.levels.ERROR)
					end
					local tmp = os.tmpname() .. ".md"
					local f = io.open(tmp, "w")
					if not f then
						vim.notify("MeowReview: could not write temp file", vim.log.levels.ERROR)
						return
					end
					f:write(markdown)
					f:close()
					vim.fn.system({
						"tmux",
						"send-keys",
						"-t",
						vibe_pane_id,
						"'Act on this review @" .. tmp,
						"Enter",
					})
				end)

				-- Add MeowReview hydra
				local hydra = require("hydra")
				hydra({
					name = "MeowReview",
					mode = "n",
					body = "<a-m>",
					config = {
						color = "pink",
						invoke_on_body = true,
						hint = {
							type = "window",
							position = "bottom-right",
						},
					},
					heads = {
						{ "a", "<Plug>(MeowReviewAdd)", { desc = "Add Comment" } },
						{ "d", "<Plug>(MeowReviewDelete)", { desc = "Delete Comment" } },
						{ "e", "<Plug>(MeowReviewEdit)", { desc = "Edit Comment" } },
						{ "v", "<Plug>(MeowReviewGoto)", { desc = "View Comments" } },
						{ "c", "<Plug>(MeowReviewClear)", { desc = "Clear All" } },
						{ "n", "<Plug>(MeowReviewNext)", { desc = "Next Comment" } },
						{ "p", "<Plug>(MeowReviewPrevious)", { desc = "Prev Comment" } },
						{ "X", "<Plug>(MeowReviewExportAndClear)", { desc = "Export & Clear" } },
						{ "<esc>", nil, { exit = true, desc = "Quit" } },
					},
				})
			end,
		},
		-- Grug Far
		-- ##########################################################
		{
			"MagicDuck/grug-far.nvim",
			opts = {},
			keys = {
				{
					"<a-g>",
					function()
						require("grug-far").open({
							windowCreationCommand = "belowright vsplit",
						})
					end,
					{ desc = "GrugFar", silent = true },
				},
				{
					mode = "v",
					"<a-g>",
					function()
						require("grug-far").with_visual_selection({
							windowCreationCommand = "belowright vsplit",
						})
					end,
					{ desc = "GrugFarVisual", silent = true },
				},
			},
		},
	},
	install = { colorscheme = { "habamax" } },
})
