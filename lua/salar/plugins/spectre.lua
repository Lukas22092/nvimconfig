return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>sr", function() require("spectre").toggle() end, desc = "Spectre: Toggle search/replace" },
		{ "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Spectre: Search word under cursor" },
		{ "<leader>sp", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Spectre: Search in current file" },
	},
	config = function()
		local log = require("salar.core.log")
		require("spectre").setup({
			replace_engine = "sed",
			live_update = true,
			line_sep_start = "┌─────────────────────────────────────────────────────────────────────────────",
			result_padding = "¦  ",
			line_sep = "└─────────────────────────────────────────────────────────────────────────────",
			highlight = {
				search = "SpectreSearch",
				replace = "SpectreReplace",
			},
			mapping = {
				["toggle_line"] = { map = "dd", cmd = "<cmd>lua require('spectre').toggle_line()<CR>", desc = "Toggle line" },
				["enter_file"] = { map = "<CR>", cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>", desc = "Enter file" },
				["send_to_qf"] = { map = "<C-q>", cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>", desc = "Send to quickfix" },
				["replace_cmd"] = { map = "<leader>c", cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>", desc = "Replace all" },
				["show_option_menu"] = { map = "<leader>o", cmd = "<cmd>lua require('spectre').show_options()<CR>", desc = "Show options" },
				["run_replace"] = { map = "<leader>R", cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>", desc = "Run replace" },
				["change_view_mode"] = { map = "<leader>v", cmd = "<cmd>lua require('spectre').change_view()<CR>", desc = "Change view" },
				["toggle_ignore_case"] = { map = "ti", cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>", desc = "Toggle ignore case" },
				["toggle_hidden"] = { map = "th", cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>", desc = "Toggle hidden" },
			},
			find_engine = {
				["rg"] = {
					cmd = "rg",
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					options = {
						["ignore-case"] = { value = "--ignore-case", icon = "[I]", desc = "Ignore case" },
						["hidden"] = { value = "--hidden", icon = "[H]", desc = "Hidden files" },
					},
				},
			},
		})

		vim.api.nvim_set_hl(0, "SpectreSearch", { bg = "#3a5a3a", fg = "#a6e3a1" })
		vim.api.nvim_set_hl(0, "SpectreReplace", { bg = "#5a3a3a", fg = "#f38ba8" })

		log.info("spectre setup complete")
	end,
}