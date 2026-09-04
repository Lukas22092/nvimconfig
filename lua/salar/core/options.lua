vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs / indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.copyindent = true
opt.preserveindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.foldmethod = "marker"
opt.foldmarker = "#pragma region,#pragma endregion"

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("SalarTransparentBg", { clear = true }),
	callback = function()
		local groups = {
			"Normal",
			"NormalNC",
			"NormalFloat",
			"NormalFloatNC",
			"SignColumn",
			"EndOfBuffer",
			"LineNr",
			"LineNrAbove",
			"LineNrBelow",
			"CursorLineNr",
			"CursorLine",
			"CursorLineFold",
			"CursorLineSign",
			"StatusLine",
			"StatusLineNC",
			"WinSeparator",
			"VertSplit",
			"TabLine",
			"TabLineFill",
			"TabLineSel",
			"Visual",
			"Search",
			"CurSearch",
			"IncSearch",
			"ColorColumn",
			"FoldColumn",
			"Pmenu",
			"PmenuSel",
			"PmenuSbar",
			"PmenuThumb",
			"NeoTreeNormal",
			"NeoTreeNormalNC",
			"NeoTreeEndOfBuffer",
			"NeoTreeDimText",
			"NeoTreeDirectoryName",
			"NeoTreeGitAdded",
			"NeoTreeGitConflict",
			"NeoTreeGitDeleted",
			"NeoTreeGitDirty",
			"NeoTreeGitIgnored",
			"NeoTreeGitModified",
			"NeoTreeGitNew",
			"NeoTreeGitRenamed",
			"NeoTreeGitStaged",
			"NeoTreeGitUnstaged",
			"NeoTreeGitUntracked",
			"NvimTreeNormal",
			"NvimTreeNormalNC",
			"NvimTreeEndOfBuffer",
			"NvimTreeWinSeparator",
			"BufferLineFill",
			"BufferLineBackground",
			"BufferLineTab",
			"BufferLineTabSelected",
			"BufferLineTabClose",
			"BufferLineCloseButton",
			"BufferLineCloseButtonVisible",
			"BufferLineCloseButtonSelected",
			"TroubleNormal",
			"TroubleNormalNC",
			"WhichKeyNormal",
			"TelescopeNormal",
			"TelescopePromptNormal",
			"TelescopeResultsNormal",
			"TelescopePreviewNormal",
			"SnacksNormal",
			"SnacksDashboardNormal",
			"LazyNormal",
			"MasonNormal",
			"NotifyBackground",
			"NotifyDEBUGBody",
			"NotifyERRORBody",
			"NotifyINFOBody",
			"NotifyWARNBody",
		}
		for _, group in ipairs(groups) do
			local hl = vim.api.nvim_get_hl(0, { name = group })
			vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "none" }))
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("SalarYankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 300 })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local bo = vim.bo[args.buf]
		bo.autoindent = true
		bo.smartindent = true
		bo.copyindent = true
		bo.preserveindent = true
	end,
})

vim.filetype.add({
	extension = {
		gd = "gdscript",
		gdshader = "gdshader",
		gdshaderinc = "gdshaderinc",
		tres = "gdresource",
		tscn = "gdresource",
		h = "c",
		hpp = "cpp",
	},
	filename = {
		["project.godot"] = "godot",
	},
})
