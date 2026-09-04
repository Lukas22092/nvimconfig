local log = require("salar.core.log")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "salar.plugins" },
	{ import = "salar.plugins.lsp" },
}, {
	change_detection = {
		notify = false,
	},
	checker = {
		enabled = true,
		notify = false,
	},
})

local ok_theme, err_theme = pcall(function()
	require("salar.core.theme").setup()
end)
if ok_theme then
	log.info("theme setup complete")
else
	log.error("theme setup failed: " .. tostring(err_theme))
end
