return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local function try_require(mod)
			local ok, m = pcall(require, mod)
			return ok and m or nil
		end

		local lga_actions = try_require("telescope-live-grep-args.actions")
		local trouble_module = try_require("trouble.sources.telescope")

		local trouble_key = nil
		if trouble_module then
			trouble_key = trouble_module.open
		end

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
					},
					n = {
						["<C-s>"] = actions.send_to_qflist + actions.open_qflist,
						["dd"] = function(prompt_bufnr)
							actions.delete_buffer(prompt_bufnr)
						end,
					},
				},
			},
		})

		if trouble_key then
			telescope.setup({
				defaults = {
					mappings = {
						i = { ["<C-t>"] = trouble_key },
						n = { ["<C-t>"] = trouble_key },
					},
				},
			})
		end

		local ok_fzf, _ = pcall(telescope.load_extension, "fzf")
		if not ok_fzf then
			vim.notify("Telescope fzf extension failed to load", vim.log.levels.WARN)
		end

		local ok_lga, _ = pcall(telescope.load_extension, "live_grep_args")
		if not ok_lga then
			vim.notify("Telescope live_grep_args extension failed to load", vim.log.levels.WARN)
		end

		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Grep (ripgrep)" })

		if ok_lga then
			keymap.set("n", "<leader>sg", function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end, { desc = "Grep with args (ripgrep flags: -g, -t, etc.)" })
		else
			keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep (live_grep_args unavailable)" })
		end

		keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find document symbols" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
		keymap.set("n", "<leader>sq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix list" })
		keymap.set("n", "<leader>sl", "<cmd>Telescope loclist<cr>", { desc = "Location list" })
		keymap.set("n", "<leader>sr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
		keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

		vim.api.nvim_create_user_command("SpectreFromTelescope", function()
			local spectre_ok, spectre = pcall(require, "spectre")
			if not spectre_ok then
				vim.notify("spectre.nvim not installed", vim.log.levels.ERROR)
				return
			end
			local qf = vim.fn.getqflist({ items = 0 })
			if #qf.items > 0 then
				spectre.open_qflist(qf.items)
			else
				vim.notify("No quickfix items to send to Spectre", vim.log.levels.WARN)
			end
		end, { desc = "Send quickfix to Spectre for inline editing" })
		keymap.set("n", "<leader>sS", "<cmd>SpectreFromTelescope<cr>", { desc = "Send quickfix to Spectre" })
	end,
}
