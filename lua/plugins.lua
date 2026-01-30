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
							vim.api.nvim_set_hl(0, "SignColumn", { bg = "#3a5e3a" }) -- greenish
						else
							vim.api.nvim_set_hl(0, "SignColumn", { bg = orignal_signcolumn_bg })
						end
					end,
				})

				local dap = require("dap")
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
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"nvim-treesitter/nvim-treesitter-context",
			},
			event = "VeryLazy",
			config = function()
				vim.o.foldmethod = "expr"
				vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.o.foldlevel = 99

				vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
				vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
				require("treesitter-context").setup({
					enable = false,
				})

				require("nvim-treesitter.configs").setup({
					highlight = { enable = true },
					indent = { enable = true },
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "<cr>",
							node_incremental = "<cr>",
							node_decremental = "<space>",
						},
					},
					textobjects = {
						select = {
							enable = true,
							lookahead = true,
							keymaps = {
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
							},
						},
					},
				})
			end,
			keys = {
				{
					"<leader>c",
					":lua require('treesitter-context').toggle()<cr>",
					{ desc = "Treesitter context (toggle)", silent = true },
				},
			},
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
			keys = {
				{
					"<leader>k",
					":lua require('kulala').scratchpad()<cr>",
					{ desc = "Kulala scratchpad", silent = true },
				},
			},
		},
		-- FZF-Lua
		-- ##########################################################
		{
			"ibhagwan/fzf-lua",
			event = "VeryLazy",
			keys = {
				{ "<a-f>", ":FzfLua files<cr>", { desc = "Find files", silent = true } },
				{ "<a-F>", ":FzfLua resume<cr>", { desc = "Resume fuzzy find", silent = true } },
				{ "<a-b>", ":FzfLua builtin<cr>", { desc = "FzF built ins", silent = true } },
				{ "<leader>fo", ":FzfLua oldfiles<cr>", { desc = "Find old files", silent = true } },
				{ "<leader>fg", ":FzfLua grep_project<cr>", { desc = "Find grep", silent = true } },
				{ "<leader>fb", ":FzfLua buffers<cr>", { desc = "Find buffers", silent = true } },
				{ "<leader>fh", ":FzfLua helptags<cr>", { desc = "Find helptags", silent = true } },
				{ "<leader>fc", ":FzfLua colorschemes<cr>", { desc = "Find colorschemes", silent = true } },
				{ "<leader>gb", ":FzfLua git_branches<cr>", { desc = "Find git branches", silent = true } },
				{ "<leader>gs", ":FzfLua git_status<cr>", { desc = "Git status", silent = true } },
			},
			config = function()
				local fzf = require("fzf-lua")

				fzf.register_ui_select()

				fzf.setup({ "borderless" })

				-- Custom Taskfile Picker
				local taskpicker = function()
					local json = vim.fn.system("task --list-all --json")
					if vim.v.shell_error ~= 0 or not json or json == "" then
						vim.notify(
							"Failed to get task data (is 'task' installed and Taskfile present?)",
							vim.log.levels.ERROR
						)
						return
					end
					local data = vim.fn.json_decode(json)
					if type(data) ~= "table" or not data.tasks or type(data.tasks) ~= "table" then
						vim.notify("No tasks found in Taskfile", vim.log.levels.ERROR)
						return
					end
					local items = {}
					local task_map = {}
					for _, task in ipairs(data.tasks) do
						items[#items + 1] = task.name
						task_map[task.name] = {
							name = task.name,
							summary = "task " .. task.name .. " --summary",
						}
					end
					fzf.fzf_exec(items, {
						prompt = "Run a task> ",
						preview = function(selected)
							local picked = vim.trim(selected[1])
							local task = task_map[picked]
							if not task then
								return "(Task not found)"
							end
							return vim.fn.system(task.summary)
						end,
						actions = {
							["default"] = function(selected)
								local picked = selected[1]
								local task = task_map[picked]
								if not task then
									return
								end
								vim.cmd("tabnew")
								vim.cmd("terminal task " .. task.name)
							end,
						},
					})
				end
				vim.keymap.set("n", "<a-t>", taskpicker, { desc = "Find a task", silent = true })

				-- custom prefix/namespace picker
				local prefixpicker = function()
					local function keys(tbl)
						local keyset = {}
						for k in pairs(tbl) do
							table.insert(keyset, k)
						end
						return keyset
					end
					local map = {
						["brick"] = "https://brickschema.org/schema/Brick#",
						["csvw"] = "http://www.w3.org/ns/csvw#",
						["dc"] = "http://purl.org/dc/elements/1.1/",
						["dcam"] = "http://purl.org/dc/dcam/",
						["dcat"] = "http://www.w3.org/ns/dcat#",
						["dcmitype"] = "http://purl.org/dc/dcmitype/",
						["dcterms"] = "http://purl.org/dc/terms/",
						["delta"] = "http://jena.apache.org/rdf-delta#",
						["doap"] = "http://usefulinc.com/ns/doap#",
						["ex"] = "http://example.org/",
						["foaf"] = "http://xmlns.com/foaf/0.1/",
						["fuseki"] = "http://jena.apache.org/fuseki#",
						["geo"] = "http://www.opengis.net/ont/geosparql#",
						["geof"] = "http://www.opengis.net/def/function/geosparql/",
						["geosparql"] = "http://jena.apache.org/geosparql#",
						["ja"] = "http://jena.hpl.hp.com/2005/11/Assembler#",
						["odrl"] = "http://www.w3.org/ns/odrl/2/",
						["org"] = "http://www.w3.org/ns/org#",
						["owl"] = "http://www.w3.org/2002/07/owl#",
						["prefix"] = "http://qudt.org/vocab/prefix/",
						["prof"] = "http://www.w3.org/ns/dx/prof/",
						["prov"] = "http://www.w3.org/ns/prov#",
						["qb"] = "http://purl.org/linked-data/cube#",
						["qkdv"] = "http://qudt.org/vocab/dimensionvector/",
						["qlss"] = "https://qlever.cs.uni-freiburg.de/spatialSearch/",
						["quantitykind"] = "http://qudt.org/vocab/quantitykind/",
						["qudt"] = "http://qudt.org/schema/qudt/",
						["rdf"] = "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
						["rdfs"] = "http://www.w3.org/2000/01/rdf-schema#",
						["rico"] = "https://www.ica.org/standards/RiC/ontology#",
						["sdo"] = "https://schema.org/",
						["schema"] = "https://schema.org/",
						["sh"] = "http://www.w3.org/ns/shacl#",
						["si-unit"] = "https://si-digital-framework.org/SI/units/",
						["skos"] = "http://www.w3.org/2004/02/skos/core#",
						["sosa"] = "http://www.w3.org/ns/sosa/",
						["sou"] = "http://qudt.org/vocab/sou/",
						["ssn"] = "http://www.w3.org/ns/ssn/",
						["tdb2"] = "http://jena.apache.org/2016/tdb#",
						["text"] = "http://jena.apache.org/text#",
						["time"] = "http://www.w3.org/2006/time#",
						["unit"] = "http://qudt.org/vocab/unit/",
						["vaem"] = "http://www.linkedmodel.org/schema/vaem#",
						["vann"] = "http://purl.org/vocab/vann/",
						["voag"] = "http://voag.linkedmodel.org/schema/voag#",
						["void"] = "http://rdfs.org/ns/void#",
						["wgs"] = "https://www.w3.org/2003/01/geo/wgs84_pos#",
						["xml"] = "http://www.w3.org/XML/1998/namespace",
						["xsd"] = "http://www.w3.org/2001/XMLSchema#",
					}
					fzf.fzf_exec(keys(map), {
						prompt = "Expand prefix> ",
						preview = function(selected)
							local picked = vim.trim(selected[1])
							return map[picked]
						end,
						actions = {
							["default"] = function(selected)
								local picked = vim.trim(selected[1])
								vim.api.nvim_put(
									{ "@prefix " .. picked .. ": <" .. map[picked] .. "> ." },
									"l",
									true,
									true
								)
							end,
						},
					})
				end
				vim.keymap.set({ "n", "v", "i", "x" }, "<a-x>", prefixpicker, { desc = "Find a prefix", silent = true })
			end,
		},
		-- blink.cmp
		-- ##########################################################
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			event = "VeryLazy",
			version = "1.*",
			opts = {
				keymap = { preset = "super-tab" },
				cmdline = { enabled = false },
				completion = { documentation = { auto_show = true } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "omni", "cmdline" },
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
		-- Live Preview (markdown)
		-- ##########################################################
		{
			"brianhuster/live-preview.nvim",
			ft = { "markdown" },
			keys = {
				{ "<leader>lp", ":LivePreview start<cr>", { desc = "Live preview (markdown)", silent = true } },
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
				"ibhagwan/fzf-lua", -- optional
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
	},
	install = { colorscheme = { "habamax" } },
})
