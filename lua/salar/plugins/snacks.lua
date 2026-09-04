return {
	"folke/snacks.nvim",
	opts = {
		terminal = {
			win = {
				style = "float",
				border = "rounded",
			},
		},
		which_key = {
			icons = {
				breadcrumb = " » ",
				separator = " ➜ ",
				group = "+",
			},
		},
	},
	keys = {
		{
			"<leader>tf",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle floating terminal",
		},
		{
			"<leader>?",
			function()
				Snacks.which_key()
			end,
			desc = "Which-key: show keybindings",
		},
	},
}
