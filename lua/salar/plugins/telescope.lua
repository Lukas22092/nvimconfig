return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local rg_args = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"!",
			".git",
		}

		local defaults = {
			vimgrep_arguments = rg_args,
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
					["<C-e>"] = actions.to_fuzzy_refine,
				},
			},
		}

		local ok_rndr, rndr = pcall(require, "rndr")
		if ok_rndr and rndr.telescope_buffer_previewer_maker then
			defaults.buffer_previewer_maker = rndr.telescope_buffer_previewer_maker
		end

		telescope.setup({
			defaults = defaults,
			pickers = {
				live_grep = {
					additional_args = function()
						return rg_args
					end,
				},
				grep_string = {
					additional_args = function()
						return rg_args
					end,
				},
			},
		})

		telescope.load_extension("fzf")

		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep (ripgrep)" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find document symbols" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
	end,
}
