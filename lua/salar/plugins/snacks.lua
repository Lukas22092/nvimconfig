return {
	"folke/snacks.nvim",
	opts = {
		terminal = {
			win = {
				style = "float",
				border = "rounded",
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
	},
}
