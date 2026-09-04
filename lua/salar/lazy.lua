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

-- Plugin load tracking: log every plugin as it lazily loads
vim.api.nvim_create_autocmd("User", {
	pattern = { "LazyLoad", "LazyDone" },
	callback = function(args)
		local data = args.data
		if data and data.name then
			local state = args.match == "LazyDone" and "done loading" or "started loading"
			log.debug(string.format("plugin %s: %s", data.name, state))
		end
	end,
})

vim.defer_fn(function()
	local plugins = require("lazy.core.config").plugins
	local count = 0
	local errors = {}
	for name, plugin in pairs(plugins) do
		if plugin._.loaded then
			count = count + 1
		end
		if plugin.error then
			errors[#errors + 1] = name .. ": " .. tostring(plugin.error)
		end
	end
	log.info(string.format("startup: %d plugins loaded", count))
	for _, err in ipairs(errors) do
		log.error("plugin error: " .. err)
	end
	if #errors > 0 then
		vim.notify(string.format("lazy.nvim: %d plugin error(s) — see :SalarLog", #errors), vim.log.levels.WARN)
	end
end, 3000)

log.info("lazy.nvim setup complete")
