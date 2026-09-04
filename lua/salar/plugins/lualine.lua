return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		lualine.setup({
			options = {
				theme = "auto",
			},
			sections = {
				lualine_b = {
					{ "branch" },
					{ "diagnostics" },
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("SalarLualineThemeSync", { clear = true }),
			callback = function()
				lualine.refresh()
				local groups = {
					"LualineNormal",
					"LualineNormalMode",
					"LualineInsert",
					"LualineInsertMode",
					"LualineVisual",
					"LualineVisualMode",
					"LualineCommand",
					"LualineCommandMode",
					"LualineReplace",
					"LualineReplaceMode",
					"LualineInactive",
					"LualineInactiveMode",
				}
				for _, group in ipairs(groups) do
					local hl = vim.api.nvim_get_hl(0, { name = group })
					vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "none" }))
				end
			end,
		})
	end,
}
