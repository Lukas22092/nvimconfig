return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local lga_actions = require("telescope-live-grep-args.actions")
		local trouble = require("trouble.sources.telescope")

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				file_ignore_patterns = {
					"node_modules",
					"vendor",
					"build",
					"%.git",
				},
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-s>"] = actions.send_to_qflist + actions.open_qflist,
						["<C-e>"] = actions.to_fuzzy_refine,
						["<C-t>"] = trouble.open,
					},
					n = {
						["<C-s>"] = actions.send_to_qflist + actions.open_qflist,
						["<C-t>"] = trouble.open,
						["dd"] = function(prompt_bufnr)
							require("telescope.actions").delete_buffer(prompt_bufnr)
						end,
					},
				},
			},
			pickers = {
				live_grep = {
					mappings = {
						i = {
							["<C-f>"] = lga_actions.quote_prompt(),
							["<C-a>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
						},
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-f>"] = lga_actions.quote_prompt(),
							["<C-a>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")

		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Grep (ripgrep)" })
		keymap.set("n", "<leader>sg", function()
			require("telescope").extensions.live_grep_args.live_grep_args()
		end, { desc = "Grep with args (ripgrep flags: -g, -t, etc.)" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find document symbols" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
		keymap.set("n", "<leader>sq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix list" })
		keymap.set("n", "<leader>sl", "<cmd>Telescope loclist<cr>", { desc = "Location list" })
		keymap.set("n", "<leader>sr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
		keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

		-- Send Telescope results to Spectre for inline editing
		vim.api.nvim_create_user_command("SpectreFromTelescope", function()
			local qf = vim.fn.getqflist({ title = 0, items = 0 })
			if #qf.items > 0 then
				require("spectre").open_qflist(qf.items)
			else
				vim.notify("No quickfix items to send to Spectre", vim.log.levels.WARN)
			end
		end, { desc = "Send quickfix to Spectre for inline editing" })
		keymap.set("n", "<leader>sS", "<cmd>SpectreFromTelescope<cr>", { desc = "Send quickfix to Spectre" })
	end,
}