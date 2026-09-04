return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvimtree = require("nvim-tree")

		nvimtree.setup({
			sync_root_with_cwd = true,
			respect_buf_cwd = false,
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			view = {
				side = "left",
				width = 35,
				preserve_window_proportions = true,
			},
			actions = {
				open_file = {
					quit_on_open = false,
					resize_window = true,
				},
			},
			renderer = {
				highlight_opened_files = "all",
				highlight_git = true,
				indent_markers = { enable = true },
				icons = {
					show = { file = true, folder = true, folder_arrow = true, git = true },
				},
			},
			git = { enable = true },
			diagnostics = {
				enable = true,
				show_on_dirs = true,
			},
		})

		require("salar.tools.include_rename").setup(require("nvim-tree.api"))

		local keymap = vim.keymap
		keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
	end,
}